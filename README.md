# Purpose - Goodbye Docker Desktop, Hello Minikube!
This post is for devops developers who want to find an alternative to docker-desktop due to its license cost


# Requirements on Macos
```
brew install minikube docker docker-compose kyperkit ansible 

#for Kubernetes
brew install kubernetes-cli kube-ps1 kubectx
```

# install
```
git clone git@github.com:cscotti/docker-desktop-alternative.git $HOME/minikube
cd $HOME/minikube
```

# minikube (docker only)
Without docker-desktop, is it hard to use docker. You can work with minikube's docker environment to run and build image.
Here an example which :
- Test if minikube is up & run it if needed with two mount point (`/data` & `/src/app`)
- Build a python image if missing based on `Dockerfile.alpine`
- Run a python container

Note that you can change the file `./app/src/localy/hello-world.py` and it will be refresh in the container due to the mount point (`/data` & `/src/app`)

```
#start
ansible-playbook -i hosts ./playbook_docker_start.yml
docker exec -it python-hello-world /bin/sh
python3 hello-world.py

#stop
ansible-playbook -i hosts ./playbook_docker_stop.yml
```


# minikube (docker + kubernetes)
Run minikube as default on hyperkit
```
#start
ansible-playbook -i hosts ./playbook_minikube_start.yml
kubectl cluster-info --context minikube

#stop
ansible-playbook -i hosts ./playbook_minikube_stop.yml
```


# minikube (docker + kind (kubernetes in docker))
Without docker-desktop, is it hard to install kind. I find an alternative which is based on minikube's docker environment.
minikube is started on hyperkit with its k8s disabled. After we start kind docker image on it (in order to have one or more k8s nodes).
The <kind-mkind> cluster can be reach with kubectl (with a ssh tunnel)
```
#start
ansible-playbook -i hosts ./playbook_kind_start.yml
kubectl cluster-info --context kind-mkind
kubectl get nodes
kubectl get pod

#stop
ansible-playbook -i hosts ./playbook_kind_stop.yml
```

# todo - activate vscode-dev-containers on ansible minikube playbook
https://benmatselby.dev/post/vscode-dev-containers-minikube/


# for ansible debug
```
ANSIBLE_CONFIG=ansible.cfg ansible-playbook ...
```
