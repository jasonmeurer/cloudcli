
FROM ubuntu

ENV TERRAFORM_VERSION=0.11.8
ENV ANSIBLE_VERSION=2.5.0
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PYTHONPATH /ansible/lib
ENV ANSIBLE_LIBRARY /ansible/library

RUN \
  apt-get update && \
  apt-get install -y python python-dev python-pip python-virtualenv curl git unzip wget lsb-release apt-transport-https nano && \
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
  echo "...CLEAN UP..." && \
  rm -rf terraform_0.11.8_linux_amd64.zip && \
  rm -rf /tmp/* && \
  rm -rf /var/tmp/* \
  rm -rf /var/lib/apt/lists/*

ENV PATH="~/.local/bin:/root/google-cloud-sdk/bin:/ansible/bin:${PATH}"

WORKDIR /var/cloudcli

CMD ["/bin/bash"]
