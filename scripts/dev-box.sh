#!/bin/bash

ContainerID="$(podman build --quiet .)"
podman run --rm \
            -v "$PWD:$PWD" \
            -v "$HOME:/root" \
            -w "$PWD" \
            -e SDV_DIR \
            -it \
            "${ContainerID}"
