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

    if [[ $(docker plugin ls | grep loki | wc -l) -eq 0 ]] ; then
        docker plugin install  grafana/loki-docker-driver:latest --alias loki --grant-all-permission
    fi
    logInfo " * docker log loki : [${LGREEN}OK${RESTORE}]"

    terraform version > /dev/null || logErrorAndExit "Terraform doit être installé" 3
    logInfo " * terraform : [${LGREEN}OK${RESTORE}]"

    wait-port > /dev/null
    [ $? -eq 127 ] && logErrorAndExit "wait-port doit être installé (https://github.com/dwmkerr/wait-port)" 4
    logInfo " * wait-port : [${LGREEN}OK${RESTORE}]"

    logInfo "Version des binaires ..."
    
    logInfo " * Docker ..."
    docker version
    
    logInfo " * Docker plugins ..."
    docker plugin ls
    
    logInfo " * Docker compose ..."
    docker-compose version
    
    logInfo " * Terraform ..."
    terraform version
}

function printUsage {
    logErrorAndExit " Usage: ./run.sh start|stop|destroy" 99
}

function waitPortsOpened {
    logInfo "Wait all services are up to install infrastructure ..."
    wait-port -t 20000 80
    wait-port -t 20000 81
    wait-port -t 20000 5432
    wait-port -t 20000 8086
    wait-port -t 20000 3000
    wait-port -t 20000 3100
    wait-port -t 20000 8888
}

# Corps du programme #
######################
checkBinaries

systemctl stop httpd
systemctl stop postgresql-docker

if [ "$1" == "start" ] ; then
    # Démarrage infra docker
    docker-compose pull
    docker-compose up -d

	waitPortsOpened

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
    xdg-open http://superviseur.arig.local > /dev/null

elif [ "$1" == "stop" ] ; then
    # Arret infra docker
    docker-compose stop

elif [ "$1" == "destroy" ] ; then
    # Destruction infra
    logInfo "Destruction terraform ..."
    cd infrastructure
    terraform destroy -force
    rm -Rvf .terraform
    rm -vf *.tfstate*
    cd ..

    # Arret infra docker
    logInfo "Destruction docker ..."
    docker-compose down
	docker volume prune -f
	docker network prune -f
else
    printUsage
fi
