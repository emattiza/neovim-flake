with open("flake.lock", "r") as file:
    data = file.read()

import json
from operator import itemgetter
import os
import shlex
from subprocess import run

json_data = json.loads(data)
nodes = json_data["nodes"]


def is_not_flake(node_name, node_body):
    return node_body.get("flake") == False


non_flake_nodes = {
    node_name: node_body
    for node_name, node_body in nodes.items()
    if is_not_flake(node_name, node_body)
}
contents = json.dumps(non_flake_nodes, indent=2)

for item_name, item_body in non_flake_nodes.items():
    owner, repo, source_type, rev = itemgetter("owner", "repo", "type", "rev")(
        item_body["locked"]
    )
    command = f"npins add {source_type} {owner} {repo} -b main --at {rev}"
    breakpoint()
    p_npin_add = run(args=shlex.split(command), cwd=os.getcwd())
