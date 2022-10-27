#!/bin/zsh

# ARG 1 = name of profile (kind)
MINIKUBE_PROFILE=$1
#MINIKUBE_PROFILE=mkind

# NAME             TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
#hello-minikube   NodePort    10.96.189.60   <none>        8080:30385/TCP   16s
kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.10
kubectl expose deployment hello-minikube --type=NodePort --port=8080 --target-port=8080
#patch nodeport
kubectl patch service hello-minikube --type='json' --patch='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value":30015}]'


