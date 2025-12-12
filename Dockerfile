FROM kasmweb/core-ubuntu-noble:1.18.0 AS configure
USER root

ENV CODE_SERVER_PORT=8054 \
    HOME=/home/kasm-default-profile \
    INST_DIR=${STARTUPDIR}/install \
    JUPYTER_SERVER_PORT=8090 \
    PERSISTENT_DIR=/workspace \
    VNCOPTIONS="${VNCOPTIONS} -disableBasicAuth" \
    KASM_SVC_AUDIO=0 \
    KASM_SVC_AUDIO_INPUT=0 \
    KASM_SVC_UPLOADS=0 \
    KASM_SVC_GAMEPAD=0 \
    KASM_SVC_WEBCAM=0 \
    KASM_SVC_PRINTER=0 \
    KASM_SVC_SMARTCARD=0

WORKDIR $HOME

COPY ./install/ ${INST_DIR}

RUN bash ${INST_DIR}/firefox/install_firefox.sh && \
    bash ${INST_DIR}/nginx/install_nginx.sh && \
    bash ${INST_DIR}/vscode/install_vscode_server.sh && \
    bash ${INST_DIR}/jupyter/install_jupyter.sh && \
    bash ${INST_DIR}/dtaas_cleanup.sh

COPY ./startup/ ${STARTUPDIR}

COPY ./config/kasm_vnc/kasmvnc.yaml /etc/kasmvnc/
COPY ./config/jupyter/jupyter_notebook_config.py /etc/jupyter/

RUN chown 1000:0 ${HOME} && \
    $STARTUPDIR/set_user_permission.sh ${HOME} && \
    rm -Rf ${INST_DIR}

RUN mkdir ${PERSISTENT_DIR} && \
    chmod a+rwx ${PERSISTENT_DIR}

RUN adduser $(id -un 1000) sudo && \
    passwd -d $(id -un 1000)

RUN python3 -c "import os, shlex; print('\n'.join(f'export {k}={shlex.quote(v)}' for k, v in os.environ.items()))" >> /tmp/.docker_set_envs && \
    chmod 755 /tmp/.docker_set_envs

FROM scratch AS deploy
COPY --from=configure / /

EXPOSE 8080

ENTRYPOINT ["/dockerstartup/dtaas_shim.sh", "/dockerstartup/kasm_default_profile.sh", "/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]