#!/bin/bash

docker run --name=cloudclicontainer -it -v ~/Documents/docker/cloudcli:/var/cloudcli cloudcliimage /bin/bash
