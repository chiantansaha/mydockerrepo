#!/bin/bash
mykeypairname=$1 
mysecretsmgr=$2

if [ -f "$mykeypairname" ]; then
    echo "File exists\n so removing the file"
    rm -rf $mykeypairname
else
    echo "File does not exist"
fi 

# Check if the key pair already exists or not 
aws ec2 describe-key-pairs --key-names "$mykeypairname" | grep -i "An error" >/tmp/errchk

if [[ -f /tmp/errchk && -s /tmp/errchk ]]
then
    echo "I am here to create key pair" 
    exit 1
else
    echo "File is empty so need to create it"
    aws ec2 create-key-pair --key-name $mykeypairname --query 'KeyMaterial' --output text >$mykeypairname

fi

# Check if the same secrets manager already exists or not 
echo "Checking if the same secrets manager already exists or not"

# pass the keypair to secrets manager 
aws secretsmanager create-secret --name $mysecretsmgr  --description "My secrets manager" --secret-string file://$mykeypairname

rm -rf $mykeypairname
