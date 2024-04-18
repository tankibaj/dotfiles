from InquirerPy import inquirer
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

    selected = int(input(colored("Select a pod to describe: ", 'magenta'))) - 1
    selected_pod = pod_list.items[selected]
    return selected_pod.metadata.name


def get_pod_events(v1, namespace, pod_name):
    field_selector = f"involvedObject.name={pod_name}"
    return v1.list_namespaced_event(namespace, field_selector=field_selector)


def describe_pod(namespace="default"):
    pod_list = get_available_pods(namespace)

    if not pod_list:
        print(colored("No pods found in namespace", "red"))
        return

    available_pod_names = [pod.metadata.name for pod in pod_list.items]

    selected_pod_name = inquirer.select(
        message="Choose a pod to describe:",
        choices=available_pod_names
    ).execute()

    v1 = client.CoreV1Api()
    pod_detail = v1.read_namespaced_pod(name=selected_pod_name, namespace=namespace)

    print(colored(f"Details for Pod: {selected_pod_name}", 'cyan', attrs=['bold']))

    print(f"Namespace: {pod_detail.metadata.namespace}")
    print(f"Status: {pod_detail.status.phase}")
    print(f"Pod IP: {pod_detail.status.pod_ip}")
    print(f"Start Time: {pod_detail.status.start_time}")

    print(colored("\nContainers:", 'yellow', attrs=['bold']))
    for container in pod_detail.spec.containers:
        print(f"  - Name: {container.name}")
        print(f"    Image: {container.image}")

    print(colored("\nVolumes:", 'yellow', attrs=['bold']))
    for volume in pod_detail.spec.volumes:
        print(f"  - Name: {volume.name}")
        if volume.persistent_volume_claim:
            print(f"    PVC: {volume.persistent_volume_claim.claim_name}")

    print(colored("\nEvents:", 'yellow', attrs=['bold']))
    events = get_pod_events(v1, namespace, selected_pod_name)
    if not events.items:
        print("No events found.")
    else:
        for event in events.items:
            print(f"  - Reason: {event.reason}")
            print(f"    Message: {event.message}")
            print(f"    Last Timestamp: {event.last_timestamp}")
            print(f"    Type: {event.type}")
