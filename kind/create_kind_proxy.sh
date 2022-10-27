#!/bin/zsh

# ARG 1 = name of profile (kind)
MINIKUBE_PROFILE=$1
#MINIKUBE_PROFILE=mkind

MINIKUBE_IP=$(minikube ip -p "$MINIKUBE_PROFILE")
CLUSTER_SERVER=$(kubectl config view -o jsonpath='{.clusters[?(@.name == "'$(kubectl config current-context)'")].cluster.server}')
#KIND_K8S_PORT=$(cat $HOME/.kube/config |sed -n 's/\(.*\)\(127.0.0.1:\)\(.*\)/\3/p' )
KIND_K8S_PORT=$(echo "$CLUSTER_SERVER"|sed -n 's/\(.*\)\(127.0.0.1:\)\(.*\)/\3/p' )
echo "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -N docker\@$MINIKUBE_IP -p 22 -i $HOME/.minikube/machines/$MINIKUBE_PROFILE/id_rsa -L $KIND_K8S_PORT:127.0.0.1:$KIND_K8S_PORT" > $HOME/.kube/kind_tunnel.sh
chmod +x $HOME/.kube/kind_tunnel.sh

echo "$HOME/.kube/kind_tunnel.sh &"
kubectl cluster-info --context kind-$MINIKUBE_PROFILE 2>/dev/null
if [[ $? == 1 ]]; then
  $HOME/.kube/kind_tunnel.sh &
    echo "(please wait...)"
    sleep 10
    echo kubectl cluster-info --context kind-$MINIKUBE_PROFILE
    kubectl cluster-info --context kind-$MINIKUBE_PROFILE
else 
    echo kubectl cluster-info --context kind-$MINIKUBE_PROFILE
    kubectl cluster-info --context kind-$MINIKUBE_PROFILE
fi
