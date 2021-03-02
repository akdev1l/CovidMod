#!/bin/bash

SRC_DIR="$PWD"
( 
    cd "${BUILD_DIR}"
    find "${SRC_DIR}/${ASSET_DIR}" -maxdepth 1 -mindepth 1 -print0 |
         xargs -t --null -I{} bash -c 'ln -s {} $(basename {})'
)
    zip -r "${RELEASE_ARCHIVE}" "${@}"

