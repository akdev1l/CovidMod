#!/bin/bash

SMAPI_URL="https://github.com/Pathoschild/SMAPI/releases/download/3.9.2/SMAPI-3.9.2-installer.zip"

cd "${SMAPI_DIR}"

curl -L "${SMAPI_URL}" > smapi.zip
unzip -oj smapi.zip
unzip -o unix-install.dat
