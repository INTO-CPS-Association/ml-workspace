# Workspace Nouveau

A new workspace image for [DTaaS](https://github.com/INTO-CPS-Association/DTaaS).

We are still very much in the explorative phase. Everything that is
working is subject to change.

## Build Workspace Image

*Either*  
***Compose it***

```ps1
sudo docker compose up
```

*Or*
***Build it***

```ps1
sudo docker build -t workspace-nouveau:latest -f Dockerfile .
```

***Run it***

```ps1
sudo docker run -it --shm-size=512m \
  -p 8080:8080\
  workspace-nouveau:latest
```

## Use Services

An active container provides the following services

* ***Open workspace*** - http://localhost:8080/dtaas-user/tools/vnc?path=dtaas-user%2Ftools%2Fvnc%2Fwebsockify
* ***Open VSCode*** - http://localhost:8080/dtaas-user/tools/vscode
* ***Open Jupyter Notebook*** - http://localhost:8080
* ***Open Jupyter Lab*** - http://localhost:8080/dtaas-user/lab

## Current progress

* Based on the KASM core ubuntu image.
* Added VSCode service with [code-server](https://github.com/coder/code-server),
  is started by the [custom_startup.sh](/startup/custom_startup.sh) script.
* Jupyter is available.
* No longer need to authenticate when opening VNC Desktop.
* User is now a sudoer, can install debian packages, and user password
  can be set at container instantiation (via the environment variable USER_PW).
* All access to services is over http (VNC https is hidden behind reverse proxy).
* Reverse proxy exists, and VNC's websocket is forced to adchere to path structure with 'path' argument as path of http request.
* Still need to get image under 500 MB.
