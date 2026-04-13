#!/bin/bash

USERID=$(id -u)
TIMESTAP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$2 ....$R failure  $N"
    else
        echo -e "$2....  $G Success $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo -e "$R please run the inside the root user $N"
else
    echo -e "$G you are a root user $N"
fi


dnf install mysql-server -y
VALIDATE $? "installing mysql-server"

systemctl enable mysqld
VALIDATE $? "enabling the mysqld"

systemctl start mysqld
VALIDATE $? "start the mysqld"

mysqld -h db.nsrikanth.online -uroot -pExpenseApp@1 -e 'show databases;'

if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "set up root password"
else
    echo "root password already setup"
fi