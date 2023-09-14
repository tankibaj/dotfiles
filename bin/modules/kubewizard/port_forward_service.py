import argparse
from kubernetes import client, config
from termcolor import colored
import subprocess
import webbrowser
import socket
import threading


class Args:
    def __init__(self, namespace, port, svc_port):
        self.namespace = namespace
        self.port = port
        self.svc_port = svc_port


# Function to read output and open browser if port forwarding starts
def read_output(pipe, local_port):
    while True:
        line = pipe.readline().decode('utf-8').strip()
        if line:
            print(line)
            if "Forwarding from" in line:
                webbrowser.open(f"http://localhost:{local_port}")
        if not line:
            break


def list_services(namespace):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    return v1.list_namespaced_service(namespace=namespace)


def select_service(service_list):
    print(colored("Available Services:", "cyan"))
    for index, service in enumerate(service_list.items):
        print(f"{index + 1}. {service.metadata.name}")

    selected = int(input(colored("Select a service to port-forward: ", 'magenta'))) - 1
    return service_list.items[selected]


def get_service_ports(service):
    return [(port.name, port.port) for port in service.spec.ports]


def is_port_in_use(port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        return s.connect_ex(('localhost', port)) == 0


def get_available_port(default_port):
    if not is_port_in_use(default_port):
        return default_port
    return None


def port_forward_service(args):
    namespace = args.namespace
    chosen_port = args.port
    svc_port = args.svc_port

    service_list = list_services(namespace)

    if not service_list:
        print(colored("No services found in namespace", "red"))
        return

    selected_service = select_service(service_list)
    available_ports = get_service_ports(selected_service)

    if svc_port:
        selected_port = next((port for name, port in available_ports if name == svc_port or port == svc_port), None)
    else:
        selected_port = available_ports[0][1]

    local_port = chosen_port or get_available_port(8001) or 'random'

    # Customized text for terminal
    print(colored("======= Kubernetes Service Port Forward =======", "yellow"))
    print(colored(f"Open svc {selected_service.metadata.name}", "cyan"))
    print(colored(f"Starting to serve on 127.0.0.1:{local_port}", "green"))
    print(colored("Opening service in the default browser...", "blue"))
    print("================================================")

    # Start port-forwarding
    process = subprocess.Popen(
        ["kubectl", "port-forward", f"service/{selected_service.metadata.name}", f"{local_port}:{selected_port}",
         f"--namespace={namespace}"],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )

    # Create threads to read stdout and stderr
    stdout_thread = threading.Thread(target=read_output, args=(process.stdout, local_port))
    stderr_thread = threading.Thread(target=read_output, args=(process.stderr, local_port))

    # Start threads
    stdout_thread.start()
    stderr_thread.start()

    # Wait for threads to finish reading
    stdout_thread.join()
    stderr_thread.join()

    # Wait for the subprocess to terminate
    process.wait()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Port-forward a Kubernetes Service")
    parser.add_argument("--namespace", "-n", default="default", help="Namespace to use")
    parser.add_argument("--port", "-p", type=int, help="Local port for port-forwarding")
    parser.add_argument("--svc-port", help="Service port name or number to forward")

    args = parser.parse_args()
    port_forward_service(args)
