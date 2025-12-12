#!/usr/bin/env bash
set -xe

# Installs Jupyter and Python3

apt-get update && apt-get install -y \
    python3 \
    python3-pip

pip install --break-system-packages --no-cache-dir \
    jupyterlab \
    notebook