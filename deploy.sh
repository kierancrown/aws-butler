#!/bin/bash
BASEDIR=$(dirname $0)
cd lambda; zip -r ../lambda_payload.zip *; cd ..
terraform apply -input=false -var-file=${BASEDIR}/configs/dev/vars.tfvars -auto-approve