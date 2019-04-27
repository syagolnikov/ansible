## Dockerized ansible deploy of K8s w/Kubeadm


Official Jeknins documentation:
<br>

## Requirements

* 3 VMs running Ubuntu 16.04+ [https://www.ubuntu.com/download/server](https://www.ubuntu.com/download/server) with SSH and python3.

<br>

## 1. Create ansible-local image on Mac or windows

```
$ cd ansible
$ docker build -t ansible-local .

```

## 2. adjust IPs in inventory file to match VM IP's

## 3. Deploy K8s cluster via shell script

bash ./deploy-cluster.sh

## Release Notes

### 1.0.1

* Initial creation of automation
