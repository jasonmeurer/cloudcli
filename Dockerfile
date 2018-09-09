
FROM ubuntu

ENV TERRAFORM_VERSION=0.11.8
ENV ANSIBLE_VERSION=2.6.3
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV ANSIBLE_LIBRARY /ansible/library

RUN \
  apt-get update && \
  apt-get install -y python python-dev python-pip python-virtualenv curl git unzip wget lsb-release apt-transport-https nano apt-utils && \
  pip install Flask && \
  echo "...INSTALLING ANSIBLE..." && \
  pip install ansible==${ANSIBLE_VERSION} && \
  echo "...INSTALLING AWS..." && \
  pip install awscli --upgrade --user && \
  echo "...INSTALLING AZURE..." && \
  AZ_REPO=$(lsb_release -cs) && \
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
  curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -  && \
  apt-get update && apt-get install -y azure-cli && \
  echo "...INSTALLING GCLOUD..." && \
  curl -sSL https://sdk.cloud.google.com | bash && \
  echo "...INSTALLING TERRAFORM..." && \
  cd /tmp && \
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
  echo "...INSTALLING Cisco ACI..." && \
  wget https://github.com/datacenter/acitoolkit/archive/master.zip && \
  unzip master.zip -d /usr/bin && \
  cd /usr/bin/acitoolkit-master/ && \
  python /usr/bin/acitoolkit-master/setup.py install && \
  echo "...CLEAN UP..." && \
  cd /tmp && \
  rm -rf *.zip && \
  rm -rf /tmp/* && \
  rm -rf /var/tmp/* \
  rm -rf /var/lib/apt/lists/*

ENV PATH="~/.local/bin:/root/google-cloud-sdk/bin:/ansible/bin:/usr/bin/acitoolkit-master/acitoolkit:${PATH}"
ENV PYTHONPATH="/ansible/lib:/usr/bin/acitoolkit-master/:/usr/bin/acitoolkit-master/acitoolkit:${PYTHONPATH}"

WORKDIR /var/cloudcli

CMD ["/bin/bash"]
