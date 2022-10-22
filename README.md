# Purpose
This post is for developper who want to find an alternative to docker-desktop due to its license cost


# Requirements on macos
```
brew install docker kyperkit ansible kubectl
```

# minikube (docker only - less cpu and memory consuming)
Without docker-desktop, is it hard to use docker. You can work with minikube's docker environnement in order to run and build image.
```
#start
ansible-playbook -i hosts ./playbook_docker_start.yml

#stop
ansible-playbook -i hosts ./playbook_docker_stop.yml
```


# minikube (docker + kubernetes)
Launch minikube as default
```
#start
ansible-playbook -i hosts ./playbook_minikube_start.yml

#stop
ansible-playbook -i hosts ./playbook_minikube_stop.yml
```


# install kind (kubernetes in docker) on minikube's docker
Without docker-desktop, is it hard to install kind. I find an alternative which is base on minikube's docker environnement.
minikube is started on hyperkit with its k8s disabled. After we start kind docker image on it (in order to have one or more k8s nodes).
The <kind-mkind> cluster can be reach with kubectl (with an ssh tunnel)
```
#start
ansible-playbook -i hosts ./playbook_kind_start.yml

#stop
ansible-playbook -i hosts ./playbook_kind_stop.yml
```


# for ansible debug
```
ANSIBLE_CONFIG=ansible.cfg ansible-playbook ...
```
