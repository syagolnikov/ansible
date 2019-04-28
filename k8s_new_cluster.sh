#!/bin/bash

#install dependencies on all k8s
sudo docker run --rm -it -e ANSIBLE_HOST_KEY_CHECKING=false -v $(pwd):/ansible/playbooks ansible-local k8s-dependencies.yml -i inventory -K --ask-pass

#deploy master node
sudo docker run --rm -it -e ANSIBLE_HOST_KEY_CHECKING=false -v $(pwd):/ansible/playbooks ansible-local k8s-master.yml -vvv  -i inventory -K --ask-pass

sleep 180

#join master node
sudo docker run --rm -it -e ANSIBLE_HOST_KEY_CHECKING=false -v $(pwd):/ansible/playbooks ansible-local k8s-node.yml -vvv  -i inventory -K --ask-pass

#deploy jenkin master
scp -rp ../charts/* ubuntu@$1:/home/ubuntu/
ssh ubuntu@$1 "kubectl apply -f ./charts/jenkins-deployment.yml"
ssh ubuntu@$1 "kubectl apply -f ./charts/jenkins-svc.yml"
ssh ubuntu@$1 "kubectl apply -f ./charts/jenkins-worker-acct.yml"
