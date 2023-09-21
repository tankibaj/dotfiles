from InquirerPy import inquirer
from kubernetes import client, config
from termcolor import colored


def get_available_pods(namespace):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    return v1.list_namespaced_pod(namespace=namespace)


def view_pod_logs(namespace="default", follow=False):
    pod_list = get_available_pods(namespace)

    if not pod_list:
        print(colored("No pods found in namespace", "red"))
        return

    available_pod_names = [pod.metadata.name for pod in pod_list.items]
    selected_pod = inquirer.select(
        message="Choose a pod to view logs:",
        choices=available_pod_names
    ).execute()

    selected_pod_obj = next(pod for pod in pod_list.items if pod.metadata.name == selected_pod)
    containers = [container.name for container in selected_pod_obj.spec.containers]

    if len(containers) > 1:
        selected_container = inquirer.select(
            message="Choose a container to view logs:",
            choices=containers
        ).execute()
    else:
        selected_container = containers[0]  # Auto-select if there's only one container

    v1 = client.CoreV1Api()

    if follow:
        logs = v1.read_namespaced_pod_log(name=selected_pod, namespace=namespace, container=selected_container,
                                          follow=True, _preload_content=False)
        for line in logs.stream():
            print(line.decode('utf-8').strip())
    else:
        log = v1.read_namespaced_pod_log(name=selected_pod, namespace=namespace, container=selected_container)
        print(colored(f"Logs for {selected_pod} container {selected_container}:", 'cyan', attrs=['bold']))
        print(log)
