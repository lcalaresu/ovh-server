#!/usr/bin/env bash
#
# Post-installation Configuration Scripts
#
# First stage script for OVH dedicated servers
# - Get distro name
# - Check server is an OVH dedicated server
# - Download and execute appropriate scripts

# Script version
VERSION=1.0.1

# OVH dedicated servers are expected to run this script as "script"
EXPECT_SCRIPT_PATH="/tmp/script"
# by default, we do NOT ignore checks (we DO check)
IGNORE_CHECK=false

# Remote scripts URI root
export KS_URI_ROOT="https://raw.githubusercontent.com/lcalaresu/ovh-server/refs/heads/main/"

# OS Release file
OSR_FILE="/etc/os-release"

# Secondary script file
NEXT_FILE=/tmp/next

# Error codes
ERR_OK=0
ERR_NOT_DEDICATED=1
ERR_OSR_FILE=2
ERR_DISTRO=3

# -------------------------------------
# USAGE
# -------------------------------------
usage() {
cat <<-EOF
Usage: $0 [OPTIONS]
Starts the post-installation process for the current dedicated server.

OPTIONS
  -I, --ignore-check      ignore dedicated server checks 
                          (continue even if the machine is not a dedicated server)
  -H, --help              display this help message 
  -V, --version           display the version of this scripts

Exit status:
 0  if OK,
 1  if the computer is not a Kimsufi dedicated server,
 2  if distribution cannot be determined,
 3  if distribution is not supported.

EOF
}

# -------------------------------------
# Parsing arguments
# -------------------------------------
while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -H | --help)
            usage
            exit
            ;;
        -V | --version)
            echo -e "$0: version $VERSION.\n"
            exit
            ;;
        -I | --ignore-check)
            IGNORE_CHECK=true
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

# -------------------------------------
# Display errors on channel 2
# -------------------------------------
err() { 
  cat <<< "${0##*/}: $@" 1>&2; 
}

# -------------------------------------
# Check if the server is a dedicated server or not
# -------------------------------------
check_ovh_dedicated () {
  if ! [[ "${0}" == $EXPECT_SCRIPT_PATH ]]; then
    err "unexpected script path ${0}: Not a dedicated server."
    exit $ERR_NOT_DEDICATED
  fi
}

# -------------------------------------
# Get the distribution name
# -------------------------------------
get_distro () {
  if ! [[ -r $OSR_FILE ]]; then
    err "cannot access $OSR_FILE: No such file."
    exit $ERR_OSR_FILE
  fi
  DISTRO=$(sed -n '/^ID=/s///p' /etc/os-release)
}

# -------------------------------------
# Execute a remote file
# -------------------------------------
exec_remote () {
  # 'raw.githubusercontent.com' domain may not clear HTTPS CA checks
  bash <(wget --no-check-certificate -O - $KS_URI_ROOT$1)
  return $?
}

# -------------------------------------
# Execute scripts for Debian servers
# -------------------------------------
cfg_debian () {
  exec_remote "scripts/ovh/ovh_debian"
  exec_remote "scripts/debian/deb_host"
  exec_remote "scripts/debian/deb_google_auth"
  exec_remote "scripts/debian/deb_docker"
}

# -------------------------------------
#               MAIN
# -------------------------------------
main () {
  # Check if the server is a dedicated Kimsufi (if not ask otherwise)
  if [ "$IGNORE_CHECK" == "false" ]; then
    check_ovh_dedicated
  fi 

  # get the distribution
  get_distro

  # start steps depending on the distribution
  case "$DISTRO" in
    debian)
      cfg_debian
      ;;
    *)
      err "unsupported distribution: $DISTRO"
      exit $ERR_DISTRO
      ;;
  esac
  
  # if everything went OK, create a file
  touch postconfig_completed
  exit $ERR_OK
}

main
