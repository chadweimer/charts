#!/bin/sh
set -e

on_exit () {
	[ $? -eq 0 ] && exit
	echo 'ERROR: Feature "Common Utilities" (ghcr.io/devcontainers/features/common-utils) failed to install! Look at the documentation at ${documentation} for help troubleshooting this error.'
}

trap on_exit EXIT

set -a
. ../devcontainer-features.builtin.env
. ./devcontainer-features.env
set +a

echo ===========================================================================

echo 'Feature       : Common Utilities'
echo 'Description   : Installs a set of common command line utilities, Oh My Zsh!, and sets up a non-root user.'
echo 'Id            : ghcr.io/devcontainers/features/common-utils'
echo 'Version       : 2.3.0'
echo 'Documentation : https://github.com/devcontainers/features/tree/main/src/common-utils'
echo 'Options       :'
echo '    INSTALLZSH="true"
    CONFIGUREZSHASDEFAULTSHELL="true"
    USERUID="automatic"
    INSTALLOHMYZSHCONFIG="true"
    UPGRADEPACKAGES="true"
    USERNAME="automatic"
    NONFREEPACKAGES="false"
    INSTALLOHMYZSH="false"
    USERGID="automatic"'
echo 'Environment   :'
printenv
echo ===========================================================================

chmod +x ./install.sh
./install.sh
