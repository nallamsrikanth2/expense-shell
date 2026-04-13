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
        exit 1
    else
        echo -e "$2....  $G Success $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo -e "$R please run the inside the root user $N"
    exit 1
else
    echo -e "$G you are a root user $N"
fi


dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing mysql-server"

systemctl enable mysqld  &>>$LOGFILE
VALIDATE $? "enabling the mysqld"

systemctl start mysqld  &>>$LOGFILE
VALIDATE $? "start the mysqld"

mysql -h db.nsrikanth.online -uroot -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
    VALIDATE $? "set up root password"
else
    echo "root password already setup"
fi