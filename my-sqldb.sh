#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$2 is $R failure $N"
        exit 1
    else
        echo -e "$2 is $G success $N"
    fi
}

if [ $USERID -ne 0 ]
then    
    echo -e " $R please run this script inside the root user $N"
    exit 1
else
    echo -e "$G you are in root user $N"
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing mysql server"

systemctl enable mysqld  &>>$LOGFILE
VALIDATE $? "enabling the mysqld"

systemctl start mysqld
VALIDATE $? "starting the mysqld"

mysql -h db.nsrikanth.online -uroot -pExpenseApp@1 -e 'show databases;'   &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1  &>>$LOGFILE
else
    echo -e "Already setup root password....$Y Skipping $N"
fi




