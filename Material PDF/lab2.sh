#!/bin/bash
#

# Get information from requiredinfo file
TENANTNAME=$(grep tenancyname requiredinfo | cut -f2 -d" ")
TENANTOCID=$(grep tenancyocid requiredinfo | cut -f2 -d" ")
USERNAME=$(grep username requiredinfo | cut -f2 -d" ")
USEROCID=$(grep userocid requiredinfo | cut -f2 -d" ")
AUTHTOKEN=$(grep authtoken requiredinfo | cut -f2 -d" ")
NAMESPACE=$(grep namespace requiredinfo | cut -f2 -d" ")
APMENDPOINT=$(grep apmendpoint requiredinfo | cut -f2 -d" ")
REGIONCODE=$(grep regioncode requiredinfo | cut -f2 -d" ")
APMPUBKEY=$(grep apmpublickey requiredinfo | cut -f2 -d" ")
APMPRIVKEY=$(grep apmprivatekey requiredinfo | cut -f2 -d" ")
OKEOCID=$(grep okeocid requiredinfo | cut -f2 -d" ")

# Print info and wait confirmation to conitnue:
echo "==============================================================="
echo "This the information required information, could we conitnue?:"
echo "==============================================================="
echo "Tenant name: $TENANTNAME"
echo "Tenant OCI ID: $TENANTOCID"
echo "User name: $USERNAME"
echo "User OCI ID: $USEROCID"
echo "Auht token: $AUTHTOKEN"
echo "Namespace: $NAMESPACE"
echo "APM endpoint: $APMENDPOINT"
echo "APM public key: $APMPUBKEY"
echo "APM pirvate key: $APMPRIVKEY"
echo "Region code: $REGIONCODE"
echo "OKE OCI ID: $OKEOCID"
echo "==============================================================="
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

# Login to OCIR with docker command line:
echo "==============================================================="
echo "Login to OCIR with docker cl"
echo "docker login ${REGIONCODE}.ocir.io -u ${NAMESPACE}/${USERNAME}"
echo $AUTHTOKEN | docker login ${REGIONCODE}.ocir.io -u ${NAMESPACE}/${USERNAME} --password-stdin
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP
# Get OKE config file:
echo "==============================================================="
echo "Get OKE config file"
echo "oci ce cluster create-kubeconfig --cluster-id ${OKEOCID} --file $HOME/.kube/config --region ${REGIONCODE} --token-version 2.0.0  --kube-endpoint PUBLIC_ENDPOINT"
oci ce cluster create-kubeconfig --cluster-id ${OKEOCID} --file $HOME/.kube/config --region ${REGIONCODE} --token-version 2.0.0  --kube-endpoint PUBLIC_ENDPOINT
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

# Validating the k8s config file
echo "==============================================================="
echo "Validating access to OKE cluster"
echo kubectl get nodes
kubectl get nodes
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

#
# Deploying application to OKE:
#

# Clone git repo
echo "==============================================================="
echo "Clone git repo"
echo "git clone https://github.com/ChristoPedro/labcodeappdev.git"
git clone https://github.com/ChristoPedro/labcodeappdev.git
echo 
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

# Create container image
echo "==============================================================="
echo "Create container image"
echo "docker build -t ${REGIONCODE}.ocir.io/${NAMESPACE}/ftdeveloper/back ."
cd labcodeappdev/Backend/code
docker build -t ${REGIONCODE}.ocir.io/${NAMESPACE}/ftdeveloper/back .
echo 
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

# listing backend container image
echo "==============================================================="
echo "List container images"
echo "docker images"
docker images
echo 
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP


# Push container image to OCIR Service
echo "==============================================================="
echo "Push container image"
echo "docker push ${REGIONCODE}.ocir.io/${NAMESPACE}/ftdeveloper/back"
docker push ${REGIONCODE}.ocir.io/${NAMESPACE}/ftdeveloper/back
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

# Create kubectl secret:
echo "==============================================================="
echo "ACTION:  Create kubectl secret"
echo "COMMAND: kubectl create secret docker-registry ocisecret --docker-server=${REGIONCODE}.ocir.io --docker-username='${NAMESPACE}/${USERNAME}' --docker-password='${AUTHTOKEN}' --docker-email='${USERNAME}'"
kubectl create secret docker-registry ocisecret --docker-server=${REGIONCODE}.ocir.io --docker-username="${NAMESPACE}/${USERNAME}" --docker-password="${AUTHTOKEN}" --docker-email="${USERNAME}"
echo
echo "kubectl get secrets/ocisecret -o json | grep .dockerconfigjson | grep -v type | cut -f4 -d'\"' | base64 -d"
kubectl get secrets/ocisecret -o json | grep .dockerconfigjson | grep -v type | cut -f4 -d'"' | base64 -d
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

# Modify Deployment manifest file:
echo "==============================================================="
echo "ACTION:  Modify Deployment manifest file"
echo "COMMAND: sed -i \"s/\[Image-Name\]/$REGIONCODE.ocir.io\/${NAMESPACE}\/ftdeveloper\/back/\" Deploybackend.yaml"
cd ~/labcodeappdev/Backend
sed -i "s/\[Image-Name\]/$REGIONCODE.ocir.io\/${NAMESPACE}\/ftdeveloper\/back/" Deploybackend.yaml
sed -i "s@<Substitua pelo Endpoint do APM>@$APMENDPOINT@" Deploybackend.yaml
sed -i "s/<Substitua pela Public Key do APM>/$APMPUBKEY/" Deploybackend.yaml
echo
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

echo "==============================================================="
echo "This is the Deployment file"
echo "cat Deploybackend.yaml"
cat Deploybackend.yaml
echo
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

# Apply Kubectl manifest file
echo "==============================================================="
echo "ACTION:  Apply Kubectl manifest file"
echo "COMMAND: kubectl apply -f Deploybackend.yaml"
kubectl apply -f Deploybackend.yaml
echo
kubectl get pods
echo
kubectl get svc cepapp-backend
echo
echo "Waiting 120 seconds"
sleep 120
kubectl get svc cepapp-backend
echo
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

# Execute the API GW Deployment creation and then return
echo "==============================================================="
echo "ACTION: Execute the API GW Deployment creation and then return"
echo
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

# Get API GW endpoint URL:
cd ~/labcodeappdev/Frontend/code/js
COMPARTMENTID=$(oci iam compartment list | grep -B4 DevFT | head -1 | cut -f4 -d'"')
APIGWENDPOINT=$(oci api-gateway gateway list --compartment-id ${COMPARTMENTID} | grep hostname | cut -f4 -d'"')
sed -i "s@\[Substituia com a URL do API Gateway\]@https://$APIGWENDPOINT/cep/getcep@" api.js
echo "COMPARTMENTID=${COMPARTMENTID}"
echo "APIGWENDPOINT=${APIGWENDPOINT}"

# Modify the index.html with APM Endpoint and APM Public Key
cd ~/labcodeappdev/Frontend/code
sed -i "s@[Substitua com o Endpoint do APM]@$APMENDPOINT@g" index.html
sed -i "s@[Substitua com a Public Key do APM]@$APMPUBKEY@" index.html
# Validating the index.hmtl file:
egrep -w  "window.apmrum.ociDataUploadEndpoint|window.apmrum.OracleAPMPublicDataKey|crossorigin" index.html

# Create Application Front container image
echo "==============================================================="
echo "Create container image"
echo "docker build -t ${REGIONCODE}.ocir.io/${NAMESPACE}/ftdeveloper/front ."
docker build -t ${REGIONCODE}.ocir.io/${NAMESPACE}/ftdeveloper/front .
echo 
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

# Push Application Front container image to OCIR Service
echo "==============================================================="
echo "Push container image"
echo "docker push ${REGIONCODE}.ocir.io/${NAMESPACE}/ftdeveloper/front"
docker push ${REGIONCODE}.ocir.io/${NAMESPACE}/ftdeveloper/front
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

# Modify Deployment manifest file:
echo "==============================================================="
echo "ACTION:  Modify Deployment manifest file"
echo "COMMAND: sed -i \"s/\[Image-Name\]/$REGIONCODE.ocir.io\/${NAMESPACE}\/ftdeveloper\/front/\" Deployfrontend.yaml"
cd ~/labcodeappdev/Frontend
sed -i "s/\[Image-Name\]/$REGIONCODE.ocir.io\/${NAMESPACE}\/ftdeveloper\/back/" Deployfrontend.yaml
echo
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP

# Apply Kubectl manifest file
echo "==============================================================="
echo "ACTION:  Apply Kubectl manifest file"
echo "COMMAND: kubectl apply -f Deployfrontend.yaml"
kubectl apply -f Deployfrontend.yaml
echo
kubectl get pods
echo 
kubectl get svc cepapp-front
echo
echo "Waiting 120 seconds ..."
sleep 120
kubectl get svc cepapp-front
PUBLICIP=$(kubectl get svc cepapp-front | tail -1 | awk '{print $4}')
echo 
echo "Testing the endpoint: "
curl http://${PUBLICIP}
echo
echo "Please type ENTER to continue or Ctrl + C to cancel the execution"
read VARTEMP
