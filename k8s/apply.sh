docker image build ./.. -t evokom/nextcloud-full:test

helm upgrade --install traefik traefik/traefik -f traefik.values.yml --namespace kube-system

kubectl apply -f traefik.middleware.yml
kubectl apply -f postgres.yml
kubectl apply -f redis.yml
kubectl apply -f collabora.yml
kubectl apply -f nextcloud.yml
