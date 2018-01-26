#!/bin/bash
#set -x
MASTER_URL="http://54.202.5.161"
SU_USR="admin"
SU_PWD="deleteme"
TKN=$(curl --silent -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"uid":"'${SU_USR}'","password":"'${SU_PWD}'"}' $MASTER_URL/acs/api/v1/auth/login | jq ".token" | xargs)

function checkLicense(){
    echo
    echo "Ping test of License server -- ping...."` curl --silent -H "Content-type: application/json" -H "Authorization: token=${TKN}" -X GET ${MASTER_URL}/licensing/v1/ping`
    echo
    echo "DC/OS License Server Version:"
    curl --silent -H "Content-type: application/json" -H "Authorization: token=${TKN}" -X GET ${MASTER_URL}/licensing/v1/version | jq .
    echo
    echo "Current License Status metrics:"
    curl --silent -H "Content-type: application/json" -H "Authorization: token=${TKN}" -X GET ${MASTER_URL}/licensing/v1/status | jq .
}

function audit(){
  echo "Writing dcos.tar"
  curl --silent -H "Content-type: application/json" -H "Authorization: token=${TKN}" -X GET ${MASTER_URL}/licensing/v1/audit > dcos.tar
  echo
  echo "Perform tar -xvf dcos.tar to extract audit contents"
  echo 
}

# Main

if  [ "${1}" == "audit" ]; then
    audit 
else
    checkLicense
fi
