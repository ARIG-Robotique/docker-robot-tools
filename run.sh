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
	echo -e " [ ${LGREEN}INFO${RESTORE} : $DATE ] $1"
}

# Fonction de log warning
function logWarn {
	DATE=`date +"%d-%m-%y %T"`
	echo -e " [ ${LYELLOW}WARN${RESTORE} : $DATE ] $1"
}

# Fonctions de log erreur
function logError {
	DATE=`date +"%d-%m-%y %T"`
	echo -e " [ ${LRED}ERROR${RESTORE} : $DATE ] $1"
}

# Affiche une chaine et termine le script
function logErrorAndExit {
    logError "$1"
    exit $2
}

# Affiche une chaine et termine le script avec 0
function logInfoAndExit {
    logInfo "$1"
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
    export TERRAFORM_BIN=$(which terraform)
    terraform version
}

function printUsage {
    logErrorAndExit " Usage: ./run.sh start|stop|destroy" 99
}

# Corps du programme #
######################
checkBinaries

if [ "$1" == "start" ] ; then
    # Démarrage infra docker
    docker-compose pull
    docker-compose up -d

    sleep 30

    # Provision de l'infra terraform
    cd infrastructure
    terraform apply
    cd ..

elif [ "$1" == "stop" ] ; then
    # Arret infra docker
    docker-compose stop

elif [ "$1" == "destroy" ] ; then
    # Destruction infra
    logInfo "Destruction terraform ..."
    cd infrastructure
    terraform destroy -force
    cd ..

    # Arret infra docker
    logInfo "Destruction docker ..."
    docker-compose down

    # Nettoyage fichier
    logInfo "Nettoyage fichiers ..."
    sudo rm -vf infrastructure/*.tfstate*
    sudo rm -Rvf traefik/log
    sudo rm -Rvf influxdb/data
    sudo rm -Rvf grafana
    sudo rm -Rvf postgres

else
    printUsage
fi