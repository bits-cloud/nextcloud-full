## Installation

- use apply.sh to install a demo setup
- use deleteh.sh to uninstall the application
- user: user
- password: secret

## Information

- use kubectl port-forward -n kube-system <TRAEFIK-POD> 30000 30002 to acces the cluster
- on port 30002 you can see the traefik dashboard
- on port 30000 traefik will listen to incoming requests
- with **localhost:30000** you can access the nextcloud instance

#### Important Information

- the readiness- and livelinessprobe have been disabled on the nextcloud container, to avoid restarts during installation with docker-desktop
- this example can not edit documents with collabra, because the collabra-image can not resolve the url to nextcloud
