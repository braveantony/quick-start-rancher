#!/bin/bash

# set -x

URL=$IP

## deploy rancher with podman
[[ ! -d /opt/rancher ]] && sudo mkdir /opt/rancher

sudo podman run --name rancher \
  -d -p 80:80 -p 443:443 \
  -v /opt/rancher:/var/lib/rancher \
  --privileged docker.io/rancher/rancher:v2.8.2 &> /dev/null

until curl -k "https://${URL}/ping" &> /dev/null; do sleep 3; done

echo "Install Rancher ok"

INIT_PASSWORD=$(sudo podman exec -it rancher reset-password |grep -v "New password" |sed 's/\r$//')
sleep 15
PASSWORD="rancheradmin"

# Login Rancher
curl -vvv "https://${URL}/v3-public/localProviders/local?action=login" -H 'content-type: application/json' --data-binary '{"username":"admin","password":"'${INIT_PASSWORD}'"}' --insecure &> /dev/null
LOGINRESPONSE=`curl -s "https://${URL}/v3-public/localProviders/local?action=login" -H 'content-type: application/json' --data-binary '{"username":"admin","password":"'${INIT_PASSWORD}'"}' --insecure`
LOGINTOKEN=`echo $LOGINRESPONSE | jq -r .token`
[[ -n ${LOGINTOKEN} ]] && echo "Login Rancher ok"
#echo ${LOGINTOKEN}

# Change password
curl -s "https://${URL}/v3/users?action=changepassword" -H 'content-type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"currentPassword":"'${INIT_PASSWORD}'","newPassword":"'${PASSWORD}'"}' --insecure &> /dev/null
[[ "$?" == "0" ]] && echo "Change Rancher password ok"

LOGINRESPONSE=`curl -s "https://${URL}/v3-public/localProviders/local?action=login" -H 'content-type: application/json' --data-binary '{"username":"admin","password":"'${PASSWORD}'"}' --insecure`
LOGINTOKEN=`echo $LOGINRESPONSE | jq -r .token`
#echo ${LOGINTOKEN}

# Create API key
APIRESPONSE=`curl -s "https://${URL}/v3/token" -H 'content-type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"type":"token","description":"automation"}' --insecure`
# Extract and store token
APITOKEN=`echo $APIRESPONSE | jq -r .token`
echo "Please copy the following token:"
echo -e "${APITOKEN}\n"

# Configure server-url
RANCHER_SERVER="${URL}"
curl -s "https://${URL}/v3/settings/server-url" -H 'content-type: application/json' -H "Authorization: Bearer $APITOKEN" -X PUT --data-binary '{"name":"server-URL","value":"'https://$RANCHER_SERVER'"}' --insecure &> /dev/null
[[ "$?" == "0" ]] && echo "Configure Rancher server-url ok"
