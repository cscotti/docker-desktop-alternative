# Purpose
This post is for developper who want to find an alternative to docker-desktop due to its license cost


# Requirements on Macos
```
brew install docker kyperkit ansible kubectl
```

# minikube (docker only - less cpu and memory consuming)
Without docker-desktop, is it hard to use docker. You can work with minikube's docker environnement in order to run and build image.
Here an exemple which :
- test if minikube is up & start itr if needed with two mount point (`/data` & `/src/app`)
- Build a python image if missing
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
