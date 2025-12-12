#!/usr/bin/env bash

# Shim script to setup the main user (and anything dependent on the main user)
# before KASM configures itself and sets up it's services.

set -e

source /tmp/.docker_set_envs

if [[ ${DEBUG_ALL:-0} == 1 ]]; then
    export KASM_DEBUG=1
    export DTAAS_DEBUG=1
fi

if [[ ${DTAAS_DEBUG:-0} == 1 ]]; then
    set -x
fi

CURRENT_USER="$(id -un 1000)"

function convert_current_user_to_main_user {
    echo "Changing the identity of the main user from ${CURRENT_USER} to ${MAIN_USER}."
    usermod --login ${MAIN_USER} --move-home --home ${HOME} ${CURRENT_USER}
    groupmod --new-name ${MAIN_USER} ${CURRENT_USER}

    # Set user password if supplied.
    if [[ -n "$USER_PW" ]]; then
        echo "Setting the password of the main user."
        echo "${MAIN_USER}:${USER_PW}" | chpasswd
    elif su -c true "${MAIN_USER}"; then
        echo "[WARNING] No password was supplied for the main user '${MAIN_USER}' and none was already set."
        echo "          Note that main user has sudo permissions."
        echo "          If the main user is unprotected, so is root access."
        echo "          Consider setting the password manually with the 'passwd' command."
    fi
}

function do_user_dependent_configurations {
    echo "Configuring nginx."
    cp -f ${STARTUPDIR}/nginx.conf /etc/nginx/nginx.conf
    python3 ${STARTUPDIR}/configure_nginx.py
}

echo -e "\n---------------- DTAAS SHIM SCRIPT ------------------"

if [ -z "${MAIN_USER}" ]; then
    echo "[ERROR] MAIN_USER wasn't specified! - Ensure that environment variable MAIN_USER is set to the intended user name of the main user."
    exit 1
fi

export HOME=/home/${MAIN_USER}

if [ "${CURRENT_USER}" != "${MAIN_USER}" ]; then
    convert_current_user_to_main_user
    do_user_dependent_configurations
fi

su - ${MAIN_USER}

cd ${HOME}

echo "Continuing KASM script chain: '$@'"
echo -e "------------- END OF DTAAS SHIM SCRIPT --------------\n"
exec "$@"