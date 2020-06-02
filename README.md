# ARIG robot tools

Projet permettant de regrouper l'ensemble des outils utilisé pour le debug de nos robots.

Afin de fonctionné correctement il faut avoir installé les outils suivant :
* Docker [https://www.docker.com/]
* Docker compose [https://docs.docker.com/compose/]
* Docker log plugin Loki [https://github.com/grafana/loki/tree/master/cmd/docker-driver]
* Terraform (>= 0.11) [https://www.terraform.io/]
* wait-port [https://github.com/dwmkerr/wait-port]

Ensuite il suffit de lancer le script "run.sh" avec un des arguments suivant :
* start
* stop
* destroy

Il faut également ajouter (au préalable) dans son fichier /etc/hosts la résolution local pour les domaines suivant :
* superviseur.arig.local
* grafana.arig.local
* influxdb.arig.local
* chronograf.arig.local
* loki.arig.local

Enjoy!
