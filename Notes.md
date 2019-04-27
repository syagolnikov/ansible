Dockerfile
FROM gliderlabs/alpine:3.3

RUN \
  apk-install \
    curl \
    openssh-client \
    python \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-pip \
    py-setuptools \
    py-yaml \
    tar && \
  pip install --upgrade pip python-keyczar && \
  rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible /root/.ssh/
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts && \
    echo "StrictHostKeyChecking no" >>  /root/.ssh/config

RUN \
  curl -fsSL https://releases.ansible.com/ansible/ansible-2.2.2.0.tar.gz -o ansible.tar.gz && \
  tar -xzf ansible.tar.gz -C ansible --strip-components 1 && \
  rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENTRYPOINT ["ansible-playbook"]


Hints:

Running ansible role deployment:
sudo docker run --rm -it -e ANSIBLE_HOST_KEY_CHECKING=false -v $(pwd):/ansible/playbooks ansible-local role.yml -i inventory --ask-pass

One time ansible run with pem keys:
*** make sure that the pem folder is there:
sudo docker run --rm -it -e ANSIBLE_HOST_KEY_CHECKING=false -v /Users/syagolnikov/Desktop/docker_provisioning/z8/test_environment/key/:/keys:rw -v $(pwd):/ansible/playbooks ansible-local alpine-playbook.yml -i inventory --key-file=/keys/key.pem

SSH key creation:
ssh-keygen
Copy over it server
sudo docker run --rm -it -e ANSIBLE_HOST_KEY_CHECKING=false -v /Users/syagolnikov/Desktop/git/ansible/key/:/key/ -v $(pwd):/ansible/playbooks ansible-local ssh_copy.yml -i inventory --key-file=/key/id_rsa --ask-pass

Troubleshooting:
-Make sure clients have py installed (python-minimal) and that client and server match python version (2.7 must be on both)
-Make sure you can ping from outside of the container (on a laptop)
-Login to ansible-test container and run commands with -vvvv
-ansible web -i inventory -m ping -u devops --ask-pass
-ansible-playbook -i inventory test.yml --ask-pass

Resources used
https://github.com/mingfang/docker-ansible/blob/master/Dockerfile
https://hub.docker.com/r/philm/ansible_playbook/  
