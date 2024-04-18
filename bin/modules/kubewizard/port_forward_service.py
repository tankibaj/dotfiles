import socket
import subprocess
import threading
import webbrowser

from InquirerPy import inquirer
from kubernetes import client, config
from termcolor import colored


# Function to read output and open browser if port forwarding starts
def read_output(pipe, local_port):
    webbrowser_opened = False
    while True:
        line = pipe.readline().decode('utf-8').strip()
        if line:
            if "Forwarding from" in line and not webbrowser_opened:
                webbrowser.open(f"http://127.0.0.1:{local_port}")
                webbrowser_opened = True  # Ensure the browser is opened only once
            elif "Forwarding from" in line or "Handling connection for" in line:
                # Skip these lines, don't print them.
                continue
            else:
                print(line)
        if not line:
            break


def list_services(namespace):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    return v1.list_namespaced_service(namespace=namespace)


def select_service(service_list):
    available_service_names = [service.metadata.name for service in service_list.items]
    selected_service_name = inquirer.select(
        message="Choose a service to port-forward:",
        choices=available_service_names
    ).execute()
    return next(service for service in service_list.items if service.metadata.name == selected_service_name)


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

    if not service_list or not service_list.items:
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
    print(colored(f"Open svc {selected_service.metadata.name}", "cyan"))
    print(colored(f"Starting to serve on 127.0.0.1:{local_port}", "green"))
    print(colored("Opening service in the default browser...", "blue"))

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
