#!/bin/bash

if [ "${SDV_DIR}" = "" ]; then
    echo "you probably want to point SDV_DIR to the game directory" 
fi

for asset in "${@}"; do
    cp -vp "${SDV_DIR}/${asset}" "${SDV_LIB_DIR}"
done
