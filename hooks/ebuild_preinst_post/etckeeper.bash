#!/bin/bash

source "${PALUDIS_EBUILD_DIR}/echo_functions.bash"

einfo "running 'etckeeper pre-install'"

etckeeper pre-install
