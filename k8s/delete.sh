kubectl delete -f nextcloud.yml
kubectl delete -f redis.yml
kubectl delete -f collabora.yml
kubectl delete -f postgres.yml
kubectl delete -f traefik.middleware.yml

helm uninstall traefik --namespace kube-system
