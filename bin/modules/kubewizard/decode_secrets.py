from kubernetes import client, config
import base64
import json
from termcolor import colored
import argparse
from pygments import highlight
from pygments.lexers import JsonLexer
from pygments.formatters import TerminalFormatter


def get_available_secrets(namespace="default"):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    secrets = v1.list_namespaced_secret(namespace)
    return [secret.metadata.name for secret in secrets.items]


def decode_secret_data(secret_data):
    decoded_data = {}
    for key, value in secret_data.items():
        decoded_data[key] = base64.b64decode(value).decode("utf-8")
    return decoded_data


def decode_secrets(namespace="default", output_format="plain"):
    available_secrets = get_available_secrets(namespace)

    if not available_secrets:
        print(colored("No secrets found in the current namespace.", "red"))
        return

    print(colored("Available Secrets:", "yellow"))
    for index, secret in enumerate(available_secrets):
        print(f"{index + 1}. {secret}")

    selected = int(input(colored("Select a secret by its number: ", "magenta"))) - 1
    selected_secret = available_secrets[selected]

    v1 = client.CoreV1Api()
    secret_data = v1.read_namespaced_secret(name=selected_secret, namespace=namespace).data

    if not secret_data:
        print(colored("The selected secret has no data.", "red"))
        return

    decoded_data = decode_secret_data(secret_data)
    if output_format == "json":
        json_data = json.dumps(decoded_data, indent=4)
        colorized_json = highlight(json_data, JsonLexer(), TerminalFormatter())
        print(colored(f"Decoded data for secret '{selected_secret}':", "cyan"))
        print(colorized_json)
    else:
        print(colored(f"Decoded data for secret '{selected_secret}':", "cyan"))
        for key, value in decoded_data.items():
            print(f"{key}={value}")


if __name__ == "__main__":
    namespace = "default"
    parser = argparse.ArgumentParser(description="Kubernetes Wizard")
    parser.add_argument("--output", "-o", choices=["plain", "json"], default="plain", help="Output format")
    args = parser.parse_args()

    if args.output == "json":
        decode_secrets(namespace, output_format="json")
    else:
        decode_secrets(namespace)
