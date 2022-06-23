#!/usr/bin/env bash

####################
# Couleur en Shell #
####################

RESTORE='\033[0m'
export RESTORE

RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'
export RED
export GREEN
export YELLOW
export BLUE
export PURPLE
export CYAN
export LIGHTGRAY

LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'
export LRED
export LGREEN
export LYELLOW
export LBLUE
export LPURPLE
export LCYAN
export WHITE

####################
# Fonctions de Log #
####################

# Fonction de log info
function logInfo {
  DATE=`date +"%d-%m-%y %T"`
  echo -e " [ ${LGREEN}INFO${RESTORE} : ${DATE} ] $1"
}

# Fonction de log warning
function logWarn {
  DATE=`date +"%d-%m-%y %T"`
  echo -e " [ ${LYELLOW}WARN${RESTORE} : ${DATE} ] $1"
}

# Fonctions de log erreur
function logError {
  DATE=`date +"%d-%m-%y %T"`
  echo -e " [ ${LRED}ERROR${RESTORE} : ${DATE} ] $1"
}

# Affiche une chaine et termine le script
function logErrorAndExit {
  logError "${1}"
  exit ${2}
}

# Affiche une chaine et termine le script avec 0
function logInfoAndExit {
  logInfo "${1}"
  exit 0
}

# Fonctions #
#############

function checkBinaries {
  # Contrôle présence des binaires obligatoire
  logInfo "Contrôle présence binaire obligatoire ..."
  docker version > /dev/null || logErrorAndExit "Docker doit être installé" 1
  logInfo " * docker : [${LGREEN}OK${RESTORE}]"

  docker-compose version > /dev/null || logErrorAndExit "Docker compose doit être installé" 2
  logInfo " * docker-compose : [${LGREEN}OK${RESTORE}]"

  terraform version > /dev/null || logErrorAndExit "Terraform doit être installé" 3
  logInfo " * terraform : [${LGREEN}OK${RESTORE}]"

  logInfo "Version des binaires ..."

  logInfo " * Docker ..."
  docker version

  logInfo " * Docker compose ..."
  docker-compose version

  logInfo " * Terraform ..."
  TF_REQUIRED="v1.0.3"
  TF_VERSION=$(terraform --version | head -1 | cut -d ' ' -f2)
  terraform version
  if [[ "$(printf '%s\n' "${TF_REQUIRED}" "${TF_VERSION}" | sort -V | head -n1)" != "${TF_REQUIRED}" ]] ; then
    logWarn " /!\ Version minimal de Terraform requise : ${TF_REQUIRED}"
    which terraform-select-version && terraform-select-version
  fi
}

function printUsage {
  logErrorAndExit " Usage: ./run.sh start|stop|destroy" 99
}

# Corps du programme #
######################
checkBinaries

if [ "$1" == "start" ] ; then
  which sglk-dev-stack && sglk-dev-stack stop

  # Récupération des IPs des robots
  # Pour Mac : https://unix.stackexchange.com/questions/373309/mac-os-command-to-resolve-hostnames-like-getent-on-linux
  if [ "$(uname)" == "Darwin" ]; then
    export NERELL_IP=192.168.1.177
    export ODIN_IP=192.168.1.178
  else 
    export NERELL_IP=$(getent ahosts nerell | awk '{ print $1 }' | uniq)
    export ODIN_IP=$(getent ahosts odin | awk '{ print $1 }' | uniq)
  fi

  # Démarrage infra docker
  f="-f docker-compose.yml"
  if [ "$2" == "dev" ] ; then
    logInfo "Versions local de reader et superviseur"
    f+=" -f docker-compose.local.yml"
  fi

  eval "docker-compose ${f} pull"
  eval "docker-compose ${f} up --detach --force-recreate"

  # Provision de l'infra terraform
  cd infrastructure

  # Initialisation des plugins (provider) terraform
  terraform init

  while ! terraform apply -auto-approve ; do
      echo ""
      logError "Failed to initiate infrastructure. Wait 5 seconds"
      echo ""
      sleep 5
  done
  cd ..

  # Lancement de l'IHM du superviseur
  if [ "$(uname)" == "Darwin" ]; then
    open http://superviseur.arig.local > /dev/null
  else 
    xdg-open http://superviseur.arig.local > /dev/null
  fi

elif [ "$1" == "stop" ] ; then
  # Arret infra docker
  docker-compose stop

elif [ "$1" == "destroy" ] ; then
  # Destruction infra
  logInfo "Destruction terraform ..."
  cd infrastructure
  terraform destroy -auto-approve
  rm -Rvf .terraform
  rm -vf *.tfstate*
  cd ..

  # Arret infra docker
  logInfo "Destruction docker ..."
  docker-compose down --remove-orphans
else
  printUsage
fi
