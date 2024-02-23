DOCKER_USERNAME ?= cscotti78
APPLICATION_NAME ?= hello-world
GIT_HASH ?= $(shell git log -n 1 | head -n 1 | sed -e 's/^commit //' | head -c 8)
_BUILD_ARGS_TAG ?= ${GIT_HASH}
_BUILD_ARGS_RELEASE_TAG ?= latest
_BUILD_ARGS_DOCKERFILE ?= Dockerfile
ANSIBLE_PLAYBOOK_FOLDER ?= ./ansible_playbook

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% 0-9a-zA-Z_-]+:.*?##/ { printf "  \033[32m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

_builder:
		# docker build --tag ${DOCKER_USERNAME}/${APPLICATION_NAME}:${_BUILD_ARGS_TAG} -f ./docker/${_BUILD_ARGS_DOCKERFILE} .
		docker build --tag ${APPLICATION_NAME}:${_BUILD_ARGS_TAG} -f ./docker/${_BUILD_ARGS_DOCKERFILE} .

_pusher:
		docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}:${_BUILD_ARGS_TAG}

_releaser:
		docker pull ${DOCKER_USERNAME}/${APPLICATION_NAME}:${_BUILD_ARGS_TAG}
		docker tag  ${DOCKER_USERNAME}/${APPLICATION_NAME}:${_BUILD_ARGS_TAG} ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest
		docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}:${_BUILD_ARGS_RELEASE_TAG}

build: ## build image from Dockerfile
		$(MAKE) _builder

push:
		$(MAKE) _pusher

release:
		$(MAKE) _releaser

build_%: ## build image from Dockerfile.% with build_% param
		$(MAKE) _builder \
					-e _BUILD_ARGS_TAG="$*-${GIT_HASH}" \
					-e _BUILD_ARGS_DOCKERFILE="Dockerfile.$*"

push_%: ## push image based on Dockerfile.% with push_% param
		$(MAKE) _pusher \
					-e _BUILD_ARGS_TAG="$*-${GIT_HASH}"

release_%: ## push release image based on Dockerfile.% with release_% param
		$(MAKE) _releaser \
					-e _BUILD_ARGS_TAG="$*-${GIT_HASH}" \
					-e _BUILD_ARGS_RELEASE_TAG="$*-latest"


docker_start: ## start docker (based on minikube / docker-only instance)
		ansible-playbook -i hosts ${ANSIBLE_PLAYBOOK_FOLDER}/playbook_docker_start.yml
		eval $(minikube -p docker-only docker-env)

docker_stop: ## stop docker (based on minikube)
		ansible-playbook -i hosts ${ANSIBLE_PLAYBOOK_FOLDER}/playbook_docker_stop.yml

docker_rebuild: ## rebuild default docker image (based on minikube / docker-only instance)
		ansible-playbook -i hosts ${ANSIBLE_PLAYBOOK_FOLDER}/playbook_docker_rebuild.yml

img: ## list docker images
		docker image list

container: ## list docker containers
		docker container list


minikube_start: ## start minikube with one nodes
		ansible-playbook -i hosts ${ANSIBLE_PLAYBOOK_FOLDER}/playbook_minikube_start.yml

minikube_start_multi_nodes: ## start minikube with n nodes
		ansible-playbook -i hosts ${ANSIBLE_PLAYBOOK_FOLDER}/playbook_minikube_start_multi_nodes.yml

minikube_stop: ## stop minikube
		ansible-playbook -i hosts ${ANSIBLE_PLAYBOOK_FOLDER}/playbook_minikube_stop.yml

minikube_delete: ## delete minikube
		ansible-playbook -i hosts ${ANSIBLE_PLAYBOOK_FOLDER}/playbook_minikube_delete.yml


clean: ## Tidy up local environment
	find . -name \*.pyc -delete
	find . -name __pycache__ -delete
