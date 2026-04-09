#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
N="\e[33m"

VALIDATE(){
    if [ $USERID -ne 0 ]
    then 
        echo -e "$2 is $R failure $N"
    else
        echo -e "$2 is $G succes $N"
}

if [ $USERID -ne 0 ]
then
    echo -e " $R please inside the root user $N"
    exit 1
else
    echo -e "$G you are in root user $N"
fi


dnf install mysql-server -y
VALIDATE $? "installing mysql"

systemctl enable mysqld
VALIDATE $? "enable mysqld"

systemctl start mysqld
VALIDATE $? "start mysqld"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "setting up root pass"






