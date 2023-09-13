from kubernetes import client, config
from termcolor import colored


def get_available_pods(namespace):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    return v1.list_namespaced_pod(namespace=namespace)


def select_pod(pod_list):
    print(colored("Available Pods:", "cyan"))
    for index, pod in enumerate(pod_list.items):
        print(f"{index + 1}. {pod.metadata.name}")

    selected = int(input(colored("Select a pod to view logs: ", 'magenta'))) - 1
    selected_pod = pod_list.items[selected]
    return selected_pod.metadata.name, [container.name for container in selected_pod.spec.containers]


def select_container(containers):
    print(colored("Available Containers:", "cyan"))
    for index, container in enumerate(containers):
        print(f"{index + 1}. {container}")

    selected = int(input(colored("Select a container to view logs: ", 'magenta'))) - 1
    return containers[selected]


def view_pod_logs(namespace="default", follow=False):
    pod_list = get_available_pods(namespace)

    if not pod_list:
        print(colored("No pods found in namespace", "red"))
        return

    selected_pod, containers = select_pod(pod_list)

    if len(containers) > 1:
        selected_container = select_container(containers)
    else:
        selected_container = containers[0]

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


if __name__ == "__main__":
    # You can add a CLI parser here to get the namespace from the user
    namespace = "default"  # Replace with CLI input or set to current context namespace
    view_pod_logs(namespace, follow=True)
