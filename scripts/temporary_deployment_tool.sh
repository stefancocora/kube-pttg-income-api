#!/usr/bin/env bash

RC='rc/pttg-income-proving-api'
RCFILE='k8resources/pttg-income-rc.yaml'
APPNAME='pttg-income-proving-ui'
NAMESPACE='pt-i-dev'

echo "--- current version of ${APPNAME} coming from upstream is VERSION=$VERSION"
if [[ -f ./kubectl ]]
then
    echo "kubectl already downloaded, moving on ..."
else
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kubectl"
fi
chmod 755 ./kubectl
#sed 's|${.*pt-income-version.*}|${VERSION}|g' k8resources/pttg-family-migration-ui-rc.yaml
sed -i 's|${.*pt-income-version.*}|'"${VERSION}"'|g' ${RCFILE}
./kubectl -s https://kube-dev.dsp.notprod.homeoffice.gov.uk --insecure-skip-tls-verify=true --namespace=${NAMESPACE} --token=0225CE5B-C9C8-4F3B-BE49-3217B65B41B8  get ${RC} 2>&1 |grep -q "not found"
if [[ $? -eq 1 ]];
then
    echo "--- updating the ${APPNAME} RC ..."
    ./kubectl -s https://kube-dev.dsp.notprod.homeoffice.gov.uk --insecure-skip-tls-verify=true --namespace=${NAMESPACE} --token=0225CE5B-C9C8-4F3B-BE49-3217B65B41B8 delete ${RC}
else
    echo "--- ${APPNAME} RC doesn't exist, moving on ..."
fi
./kubectl -s https://kube-dev.dsp.notprod.homeoffice.gov.uk --insecure-skip-tls-verify=true --namespace=${NAMESPACE} --token=0225CE5B-C9C8-4F3B-BE49-3217B65B41B8 create -f ${RCFILE}