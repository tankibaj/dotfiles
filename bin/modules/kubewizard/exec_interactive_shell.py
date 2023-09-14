from kubernetes import client, config
from termcolor import colored
from InquirerPy import inquirer
import subprocess


def get_available_pods(namespace):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    return v1.list_namespaced_pod(namespace=namespace)


def exec_interactive_shell(namespace="default"):
    pod_list = get_available_pods(namespace)

    if not pod_list:
        print(colored("No pods found in the namespace", "red"))
        return

    available_pod_names = [pod.metadata.name for pod in pod_list.items]
    selected_pod = inquirer.select(
        message="Choose a pod to exec into:",
        choices=available_pod_names
    ).execute()

    selected_pod_obj = next(pod for pod in pod_list.items if pod.metadata.name == selected_pod)
    containers = [container.name for container in selected_pod_obj.spec.containers]

    if len(containers) > 1:
        selected_container = inquirer.select(
            message="Choose a container to exec into:",
            choices=containers
        ).execute()
    else:
        selected_container = containers[0]  # Auto-select if there's only one container

    # Check if bash is available in the container
    check_bash_command = f"kubectl exec {selected_pod} -n {namespace} -c {selected_container} -- which bash"
    shell_type = "/bin/bash" if subprocess.run(check_bash_command, shell=True,
                                               stdout=subprocess.PIPE,
                                               stderr=subprocess.PIPE).returncode == 0 else "/bin/sh"

    command = f"kubectl exec -it {selected_pod} -n {namespace} -c {selected_container} -- {shell_type}"

    print(colored(f"Executing interactive shell in {selected_pod} container {selected_container}...", 'cyan'))

    subprocess.run(command, shell=True)


if __name__ == "__main__":
    exec_interactive_shell()
