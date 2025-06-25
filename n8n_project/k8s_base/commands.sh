k3d cluster create mycluster \
  --servers 1 \
  --agents 2 \
  --port 8080:80@loadbalancer \
  --port 443:443@loadbalancer \
  --volume "$(pwd):/mnt/data@all"

k3d cluster list
kubectl get nodes