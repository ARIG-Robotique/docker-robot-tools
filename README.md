# ARIG robot tools

Projet permettant de regrouper l'ensemble des outils utilisé pour le debug de nos robots.

Afin de fonctionné correctement il faut avoir installé les outils suivant :
* Docker [https://www.docker.com/]
* Docker compose [https://docs.docker.com/compose/]
* Terraform (>= 0.14.3) [https://www.terraform.io/]

Ensuite il suffit de lancer le script "run.sh" avec un des arguments suivant :
* start
* stop
* destroy

Il faut également ajouter (au préalable) une redirection DNS wildcard (ie dnsmasq) sur le
le conteneur de Traefik (ip 10.50.0.10) :

```
address=/.arig.local/10.50.0.10
```

Enjoy!
