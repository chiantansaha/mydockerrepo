#!/bin/bash
mykeypairname=$1 
mysecretsmgr=$2

if [ -f "$mykeypairname" ]; then
    echo "File exists\n so removing the file"
    rm -rf $mykeypairname
else
    echo "File does not exist"
fi 

# create the keypair 
aws ec2 create-key-pair --key-name $mykeypairname --query 'KeyMaterial' --output text >$mykeypairname
if [ ${#} -eq 0 ]
    then
        echo "$mykeypairname created\\n"    
    else
        echo "$mykeypairname already exists\\n"  
        exit 1 # wrong args
fi

# pass the keypair to secrets manager 
aws secretsmanager create-secret --name $mysecretsmgr  --description "My secrets manager" --secret-string file://$mykeypairname
if [ ${#} -eq 0 ]
    then
        echo "$mysecretsmgr created\\n"    
    else
        echo "$mysecretsmgr already exists\\n"  
        exit 1 # wrong args
fi

rm -rf $mykeypairname
