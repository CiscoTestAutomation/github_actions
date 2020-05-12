#!/bin/bash
set -e

echo "[Entrypoint] Starting pyATS Docker Image ..."
echo "[Entrypoint] Workspace Directory: ${WORKSPACE}"


# activate workspace
# ------------------
echo "[Entrypoint] Activating workspace"
source ${WORKSPACE}/bin/activate


# initial setup
# -------------
if [ ! -f "${WORKSPACE}/.initialized" ]; then

    # install pip packages if detected
    # --------------------------------
    if [ -f "${WORKSPACE}/requirements.txt" ]; then
        echo "[Entrypoint] Installing pip packages: ${WORKSPACE}/requirements.txt"
        ${WORKSPACE}/bin/pip install --requirement ${WORKSPACE}/requirements.txt
        echo ""
    fi

    # run workspace init file if detected
    # -----------------------------------
    if [ -f "${WORKSPACE}/workspace.init" ]; then
        echo "[Entrypoint] Running workspace init: ${WORKSPACE}/workspace.init"
        bash -e ${WORKSPACE}/workspace.init
        echo ""
    fi

    # flag to avoid repeated init
    # ---------------------------
    touch ${WORKSPACE}/.initialized

fi

# enter develop mode
make develop

# cd to repo
cd $GITHUB_WORKSPACE/$1

# run tests
python3 -m unittest discover -t $3 -p $4
