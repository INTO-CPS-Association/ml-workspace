# Build Instructions

This README contains instructions for building a trimmed down version of the image and
the upgrades done to the same vis-a-vis the upstream.

## Files

Docker file to modify: Dockerfile

Command to buid: docker buildx build -t intocps/ml-workspace-minimal:0.15.0-b4 .

The successful builds are published to docker hub. Please see
[this page](https://hub.docker.com/repository/docker/intocps/ml-workspace-minimal/tags)

The v0.15.0-b2 works well but the v0.15.0-b4 has the following upgrades and problems.
The matching git commits can be seen on the [tags page](https://github.com/INTO-CPS-Association/ml-workspace/tags)
## Upgrades

Cumulative upgrades done:

* Upgrade OS to Ubuntu 22.04
* Upgrade nodejs to 18.x (the vscode server can only work over 18.x)
* Upgrade vscode server to 4.89.0
* Upgrade Jupyter notebook to 6.5.7 (newer versions of notebook and lab require nodejs 20.x or newer)
* Upgrade Jupyter lab to 4.0.2
* Upgrade python to 3.10
* Upgrade Conda and Miniconda to 24.4.0-0


## Problems

* Jupyter lab does not load
* VNC desktop does not work (due to Ubuntu 22.04 upgrade)

