#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0"

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$2 ... $R failure $N"
    else   
        echo -e "$2 .... $G sucess $N"
    fi
}
CHECK_ROOT(){
if [ $USERID -ne 0 ]
then
    echo -e "$R please run inside the root user $N"
else
    echo -e "$G you are root user $N"
fi
}