#!/usr/bin/env bash
set -e

rm -Rf ${STARTUPDIR}/audio_input
rm -Rf ${STARTUPDIR}/gamepad
rm -Rf ${STARTUPDIR}/jsmpeg
rm -Rf ${STARTUPDIR}/printer
rm -Rf ${STARTUPDIR}/recorder
rm -Rf ${STARTUPDIR}/smartcard
rm -Rf ${STARTUPDIR}/upload_server
rm -Rf ${STARTUPDIR}/webcam

apt-get clean
rm -rf /var/lib/apt/lists/*
rm -Rf /root/.cache/pip
rm -rf /tmp/*