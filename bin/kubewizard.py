#!/usr/bin/env python3


import argparse
from collections import namedtuple

from InquirerPy import inquirer
from kubernetes import config as kube_config
from termcolor import colored

from modules.kubewizard.decode_secrets import decode_secrets
from modules.kubewizard.describe_pod import describe_pod
from modules.kubewizard.exec_interactive_shell import exec_interactive_shell
from modules.kubewizard.monitor_events import monitor_events
from modules.kubewizard.port_forward_service import port_forward_service
from modules.kubewizard.view_pod_logs import view_pod_logs

ActionArgs = namedtuple("ActionArgs", ["namespace", "output_format", "follow", "all_namespaces", "port", "svc_port"])

MAIN_MENU_CHOICES = [
    {"name": "🔍 Watch Logs", "value": "watch_logs"},
    {"name": "🐚 Exec Shell in Pod", "value": "exec_shell"},
    {"name": "🔐 Get Secrets", "value": "get_secrets"},
    {"name": "🔍 Describe Pod", "value": "describe_pod"},
    {"name": "⚡️ Watch Events", "value": "watch_events"},
    {"name": "🔀 Port Forward", "value": "port_forward"},
    {"name": "❓ Help", "value": "help"},
    {"name": "🚪 Quit", "value": "quit"}
]


def get_namespace(namespace=None):
    if namespace:
        return namespace
    kube_config.load_kube_config()
    current_context = kube_config.kube_config.list_kube_config_contexts()[1]['context']
    return current_context.get('namespace', 'default')


def parse_cli_args():
    parser = argparse.ArgumentParser(description="Kubernetes Wizard CLI tool for easy k8s management.")

    parser.add_argument('--all-namespaces', '-A', action='store_true',
                        help='List the requested object(s) across all namespaces.')

    parser.add_argument("--namespace", "-n", type=str,
                        help="Specify the Kubernetes namespace. Default is the one set in your Kubeconfig.")

    parser.add_argument("--output", "-o", choices=["plain", "json"], default="plain",
                        help="Output format of secrets. Options are 'plain' and 'json'. Default is 'plain'.")

    parser.add_argument('--follow', '-f', action="store_true",
                        help='Enable follow mode for logs.')

    parser.add_argument("--port", "-p", type=int,
                        help="Specify the port for port-forwarding. If set to 0, a random port will be chosen.")

    parser.add_argument("--svc-port",
                        help="Specify the service port name or number for port-forwarding. Default uses the first port.")

    args = parser.parse_args()
    return parser, args


def main():
    try:
        parser, args = parse_cli_args()
        action_args = ActionArgs(args.namespace, args.output, args.follow, args.all_namespaces, args.port,
                                 args.svc_port)

        actions = {
            'watch_logs': lambda: view_pod_logs(action_args.namespace, action_args.follow),
            'exec_shell': lambda: exec_interactive_shell(action_args.namespace),
            'get_secrets': lambda: decode_secrets(action_args.namespace, action_args.output_format),
            'describe_pod': lambda: describe_pod(action_args.namespace),
            'watch_events': lambda: monitor_events(action_args.namespace, action_args.all_namespaces),
            'port_forward': lambda: port_forward_service(action_args),
            'quit': lambda: exit("Exiting..."),
            'help': lambda: parser.print_help()
        }

        print(colored('Use the arrow keys to navigate: ↓ ↑', 'dark_grey'))
        selected_action = inquirer.select(
            message="What do you want to do?",
            choices=MAIN_MENU_CHOICES
        ).execute()

        selected_namespace = get_namespace(action_args.namespace)
        action_args = action_args._replace(namespace=selected_namespace)

        action_fn = actions.get(selected_action, lambda: print("Invalid option. Try again."))
        action_fn()

    except KeyboardInterrupt:
        print(colored("\n\nExiting Kubernetes Wizard. Goodbye!", 'red', attrs=['bold']))


if __name__ == "__main__":
    main()
