# Purpose - Goodbye Docker Desktop, Hello Minikube!
This post is for devops developers who want to find an alternative to docker-desktop due to its license cost

## Requirements on Macos
```
brew install minikube docker docker-compose kyperkit ansible 

#for Kubernetes
brew install kubernetes-cli kube-ps1 kubectx
```

## Install project
```
$ git clone https://github.com/cscotti/docker-desktop-alternative.git $HOME/minikube
$ cd $HOME/minikube
```

# Deploy Minikube instance with Ansible 

## minikube (docker only)
Without docker-desktop, is it hard to use docker. You can work with minikube's docker environment to run and build image.
Here an example which :
- Test if minikube is up & run it if needed with two mount point (`/data` & `/src/app`)
- Build a python image if missing based on `Dockerfile.alpine`
- Run a python container

Note that you can change the file `./app/src/localy/hello-world.py` and it will be refresh in the container due to the mount point (`/data` & `/src/app`)

```
# start
$ ansible-playbook -i hosts ./playbook_docker_start.yml

# set minikube docker env locally
$ eval $(minikube -p docker-only docker-env)

# connect to the container
$ docker exec -it python-hello-world /bin/sh

# run the command in the container & exit
$ python3 hello-world.py

Hello World
{
    "Actors": [
        {
            "name": "Tom Cruise",
            "age": 56,
            "Born At": "Syracuse, NY",
            "Birthdate": "July 3, 1962",
            "photo": "https://jsonformatter.org/img/tom-cruise.jpg"
        },
        {
            "name": "Robert Downey Jr.",
            "age": 53,
            "Born At": "New York City, NY",
            "Birthdate": "April 4, 1965",
            "photo": "https://jsonformatter.org/img/Robert-Downey-Jr.jpg"
        }
    ]
}
{'name': 'Tom Cruise', 'age': 56}

$ exit

# stop minikube
$ ansible-playbook -i hosts ./playbook_docker_stop.yml
```


## minikube (docker + kubernetes)
Run minikube as default on hyperkit
```
#start
$ ansible-playbook -i hosts ./playbook_minikube_start.yml
$ kubectl cluster-info --context minikube

#stop
$ ansible-playbook -i hosts ./playbook_minikube_stop.yml
```


## minikube (docker + kind (kubernetes in docker))

Without docker-desktop, is it hard to install kind. I find an alternative which is based on minikube's docker environment.
minikube is started on hyperkit with its k8s disabled. After we start kind docker image on it (in order to have one or more k8s nodes).
The <kind-mkind> cluster can be reach with kubectl (with a ssh tunnel)

```
# start
$ ansible-playbook -i hosts ./playbook_kind_start.yml
$ kubectl cluster-info --context kind-mkind
$ kubectl get nodes
$ kubectl get pod

# stop
$ ansible-playbook -i hosts ./playbook_kind_stop.yml
```
  
# Activate vscode-dev-containers on ansible minikube playbook
- Launch one of the previous minikube profile
- go to the project dir
```
cd $HOME/minikube
```
- set minikube docker env locally
```
$ minikube profile list
$ eval $(minikube -p <profile_name> docker-env)
```
- launch vscode from the dir $HOME/minikube which is mounted
```
$ code .
```
- type the shortcut SHIFT+CMD+P
- Type : Dev Containers
- Select : "Try a Dev Containers sample"
- Choose Python
(take some minute to build image)
- Type F5 (Tab Execute / Start debug)
- Open browser and open localhost:9000

    
    
Resources:
<https://benmatselby.dev/post/vscode-dev-containers-minikube/><br>
  
<https://code.visualstudio.com/docs/remote/containers-tutorial>
<https://code.visualstudio.com/docs/remote/containers#_getting-started><br>
vscode plugin : <https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack><br>
test project : <https://github.com/microsoft/vscode-remote-try-python>
  


# Annexe

## check existing minikube instances
```
minikube profile list
```

## remove minikube profile instance
```
minikube -p <profile_name> delete
```
  
## for ansible debug
```
ANSIBLE_CONFIG=ansible.cfg ansible-playbook ...
```

