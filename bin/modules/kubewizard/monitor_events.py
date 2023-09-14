from kubernetes import client, config, watch
from termcolor import colored


def monitor_events(namespace="default", all_namespaces=False):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    w = watch.Watch()

    if all_namespaces:
        print(colored("Monitoring events in all namespaces", "cyan", attrs=['bold']))
        event_stream = w.stream(v1.list_event_for_all_namespaces)
    else:
        print(colored(f"Monitoring events in namespace: {namespace}", "cyan", attrs=['bold']))
        event_stream = w.stream(v1.list_namespaced_event, namespace)

    for event in event_stream:
        event_type = event['type']
        event_obj = event['object']

        print(colored(f"Event Type: {event_type}", "green"))
        print(f"Reason: {event_obj.reason}")
        print(f"Message: {event_obj.message}")
        print(f"Last Timestamp: {event_obj.last_timestamp}")
        print(f"Involved Object: {event_obj.involved_object.name}")
        print(f"Namespace: {event_obj.metadata.namespace}")
        print("=======================================")
