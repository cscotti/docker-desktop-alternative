#!/bin/zsh

kind delete cluster --name $1 ||echo 0

cat <<EOF | kind create cluster --name $1 --image kindest/node:v1.20.15 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
  - containerPort: 30015
    hostPort: 8080
    protocol: TCP
  # prometheus
  - containerPort: 30016 # svc/nodePort
    hostPort: 30001 # svc/port
    protocol: TCP
  # Grafana
  - containerPort: 30017 # svc/nodePort
    hostPort: 30002 # svc/port
    #listenAddress: "127.0.0.1"
    protocol: TCP
EOF

