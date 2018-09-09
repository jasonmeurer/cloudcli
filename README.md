# cloudcli

Latest Ubuntu Docker container with the following CLIs installed.

* AWS
* Azure
* Gcloud
* Terraform
* Ansible
* Cisco ACI Toolkit - available in /usr/bin/acitoolkit-master/acitoolkit/

The included shell script runs the image with volume from the local machine mapped for easy passing of files.

USAGE

docker build -t cloudcliimage .

