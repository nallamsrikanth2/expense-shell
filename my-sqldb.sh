#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log

R="\e[31m"
G="\e[32m"
N="\e[0m"

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$R $2 is failure $N"
    else
        echo -e "$G $2 is success $N"
    fi
}

if [ $USERID -ne 0 ]
then    
    echo -e " $R please run this script inside the root user $N"
else
    echo -e "$G you are in root user $N"
fi

dnf install mysql-server -y
VALIDATE $? "installingvmysql server"

systemctl enable mysqld
VALIDATE $? "enabling the mysqld"

mysql -h db.nsrikanth.online -uroot -pExpenseApp@1 -e 'show databases;'
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1
else
    echo "Already setup root password....Skipping"
fi




