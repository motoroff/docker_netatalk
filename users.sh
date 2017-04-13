#!/bin/bash

USERNAME=$1
USER=$2
GROUP=$3
DESCR=$4
HOMEDIR=$5

USAGE='Usage: username uid guid description homedir'
echo $USAGE
echo $USERNAME::$USER:$GROUP:$DESCR:$HOMEDIR: | newusers
docker cp /etc/passwd netatalk_krb5:/etc/passwd
docker cp /etc/shadow netatalk_krb5:/etc/shadow
docker cp /etc/group netatalk_krb5:/etc/group
