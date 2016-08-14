#!/bin/bash
#
# Helper functions to use from /etc/paludis/bashrc and
# package environment control files.
#
# Copyright 2014 by Alex Turbov <i.zaufi@gmail.com>
#

source ${PALUDIS_EBUILD_DIR}/echo_functions.bash

#
# Add options to the end of a given var
# $1 - variable to modify
# $2..$n - options to add
#
add-options()
{
    local var=$1
    shift
    local stmt="$var=\"\$${var} $*\""
    eval "$stmt"
}

#
# Remove options from a given var
# $1 - variable to modify
# $2..$n - options to remove
#
remove-options()
{
    local -r _ro_var="$1"
    shift
    local -a _ro_new_value
    local _ro_opt
    local _ro_del_value

    # Iterate over options in a variable
    for _ro_opt in ${!_ro_var}; do
        # Iterate over options to remove passed as function parameters
        for _ro_del_value in "$@"; do
            [[ ${_ro_opt} == ${_ro_del_value} ]] && continue 2
        done
        _ro_new_value+=( "${_ro_opt}" )
    done
    eval "${_ro_var}=\"${_ro_new_value[@]}\""
}

setup_pkg_env()
{
	local conf
    [[ ! -f /etc/paludis/package_env.conf ]] && return
    # Select configured environments
	local envs=$(for i in `egrep "^${CATEGORY}/(${PN}|\*)(:[^\s]+)?\s" /etc/paludis/package_env.conf | sed 's,[^ ]\+\s,,'`; do echo "${i}"; done | sort -u)
    for conf in $envs; do
        if [[ -f /etc/paludis/env.conf.d/${conf}.conf ]]; then
            source /etc/paludis/env.conf.d/${conf}.conf
        else
            ewarn "Ignore undefined environment configuration: ${conf}"
        fi
    done
}

# Do it!
setup_pkg_env

# kate: hl bash;
