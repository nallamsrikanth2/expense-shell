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

if [ $USERID -ne 0 ]
then
    echo -e "$R please run inside the root user $N"
else
    echo -e "$G you are root user $N"
fi


dnf install nginx -y 
VALIDATE $? "install the nginx"

systemctl enable nginx
VALIDATE $? "enable nginx"

systemctl start nginx
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "remove the evreything in html file"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "download the frontend code"

unzip /tmp/frontend.zip
VALIDATE $? "unzip the code"

cp /home/ec2-user/expense-shell/expense1.conf /etc/nginx/default.d/expense1.conf


systemctl restart nginx
VALIDATE $? "restart nginx"