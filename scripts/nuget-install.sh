#!/bin/bash

set -eux

cd "${LIB_DIR}"

for package in ${@}; do
    nuget install ${package}
done

