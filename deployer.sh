#!/bin/bash

Version='1.0' # Software version

# Reset
Color_Off='\033[0m' # Text Reset

# Regular Colors
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow
Blue='\033[0;34m'   # Blue
White='\033[0;37m'  # White

workdir=${PWD}
modulesdir=$workdir/'modules'

############################################################
# Help                                                     #
############################################################
Help() {
  # Display Help
  echo -e "${Green}____________________${Color_Off}"
  echo -e "${Green}FastDatabaseDeployer ${Color_Off} version ${Yellow}${Version}${Color_Off}"
  echo
  echo -e "${Yellow}Usage:${Color_Off}"
  echo "  command [modules] [options]"
  echo
  echo -e "${Yellow}Available commands:${Color_Off}"
  echo -e "  ${Green}deploy${Color_Off}  Deploy."
  echo
  echo -e "${Yellow}Modules:${Color_Off}"
  echo -e "  ${Green}See subfolder 'modules'${Color_Off}" Folder name.
  echo
  echo -e "${Yellow}Options:${Color_Off}"
  echo -e "  ${Green}-h, --help${Color_Off}      Print this Help."
  echo -e "  ${Green}-V, --version${Color_Off}   Display this application version and exit."
  echo
}

############################################################
# Env                                                      #
############################################################
Env() {
  echo
  echo -e "Working directory: ${Blue}$workdir${Color_Off}"
  echo -e "Modules directory: ${Blue}$modulesdir${Color_Off}"
  echo
  # Set environments
  echo -e Set environments from ${Green}$workdir'/env.sh'${Color_Off}
  source $workdir'/env.sh'
}

############################################################
# Deploy                                                   #
############################################################
Deploy() {
  Env

  if [ "$modules" != '' ]; then
    # Module $modules
    for ((i = 0 ; i < counter ; i++ ));
    do
      Module ${modules[$i]}
      # echo "${modules[$i]}"
    done
  else
    Module init
    Module core
    Module sys
    exit 0;
  fi
}

############################################################
# Module                                                   #
############################################################
Module() {
  if [[ -d "$1" ]]; then
    cd "$1"
  else
    cd $modulesdir
    cd $1
  fi

  sh deployer.sh
  # sh 99_upgrade.sh --up
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

command=
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      # display Help
      Help
      exit 0
      ;;
    -V|--version)
      # display version
      echo "${Version}"
      exit 0
      ;;
    deploy)
      # deploy
      command=deploy
      break
      ;;
    *)
    break
    ;;
  esac
done

if [ "$command" == '' ]; then
  Help
  exit 1
fi

counter=0
modules=()
case "$command" in
  deploy)
    # deploy
    shift
    for arg in "$@"
    do
      if [ "$arg" != '' ]; then
        modules[$counter]=$arg
        ((counter++))
      fi
    done
    Deploy
    exit 1
    ;;
  *)
  break
  ;;
esac
