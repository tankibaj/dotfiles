from kubernetes import client, config
from kubernetes import config as kube_config
from termcolor import colored
import subprocess


def get_available_pods(namespace):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    return v1.list_namespaced_pod(namespace=namespace)


def select_pod(pod_list):
    print(colored("Available Pods:", "cyan"))
    for index, pod in enumerate(pod_list.items):
        print(f"{index + 1}. {pod.metadata.name}")

    selected = int(input(colored("Select a pod to exec into: ", 'magenta'))) - 1
    selected_pod = pod_list.items[selected]
    return selected_pod.metadata.name, [container.name for container in selected_pod.spec.containers]


def select_container(containers):
    print(colored("Available Containers:", "cyan"))
    for index, container in enumerate(containers):
        print(f"{index + 1}. {container}")

    selected = int(input(colored("Select a container to exec into: ", 'magenta'))) - 1
    return containers[selected]


def exec_interactive_shell(namespace="default"):
    pod_list = get_available_pods(namespace)

    if not pod_list:
        print(colored("No pods found in the namespace", "red"))
        return

    selected_pod, containers = select_pod(pod_list)

    if len(containers) > 1:
        selected_container = select_container(containers)
    else:
        selected_container = containers[0]

    # Check if bash is available in the container
    check_bash_command = f"kubectl exec {selected_pod} -n {namespace} -c {selected_container} -- which bash"
    shell_type = "/bin/bash" if subprocess.run(check_bash_command, shell=True,
                                               stdout=subprocess.PIPE,
                                               stderr=subprocess.PIPE).returncode == 0 else "/bin/sh"

    command = f"kubectl exec -it {selected_pod} -n {namespace} -c {selected_container} -- {shell_type}"

    print(colored(f"Executing interactive shell in {selected_pod} container {selected_container}...", 'cyan'))

    subprocess.run(command, shell=True)  # This will directly attach to the terminal's stdin, stdout, and stderr


if __name__ == "__main__":
    # Replace with CLI input or set to current context namespace
    namespace = "default"
    exec_interactive_shell(namespace)
