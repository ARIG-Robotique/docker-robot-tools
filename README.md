# ARIG robot tools

Projet permettant de regrouper l'ensemble des outils utilisé pour le debug de nos robots.

Afin de fonctionné correctement il faut avoir installé les outils suivant :
* Docker [https://www.docker.com/]
* Docker compose [https://docs.docker.com/compose/]
* Terraform (>= 1.0.3) [https://www.terraform.io/]

Ensuite il suffit de lancer le script "run.sh" avec un des arguments suivant :
* start
* stop
* destroy

Optionellement `.run.sh start dev` lancera la stack avec les versions `local` de robots-reader et robots-supervisor.

Il faut également ajouter (au préalable) une redirection DNS wildcard (ie dnsmasq) sur le
le conteneur de Traefik (ip 10.60.0.10) :

```
address=/.arig.org/10.60.0.10
```

Enjoy!
