#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $? -ne 0 ]
    then 
        echo -e "$2 is $R failure $N"
        exit 1
    else
        echo -e "$2 is $G sucess $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo -e "$R Please run the script inside the server $N"
    exit 1
else
    echo -e "$G  you are in root user $N"
fi


dnf module disable nodejs -y
VALIDATE $? "disable the nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "enable nodejs:20"

id expense 
if [ $? -ne 0 ]
then
    useradd expense
    VALIDATE $? "creating the user"
else
    echo "already user created"
fi

mkdir -p /app
VALIDATE $? "creating the directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "downloading the backend code"


cd /app
VALIDATE $? "move to cd directory"

rm -rf /app/*
VALIDATE $? "remove everything in app directory"

unzip /tmp/backend.zip
VALIDATE $? "unzip the backend code"

npm install
VALIDATE $? "install the dependences"

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service
VALIDATE $? "copy backend.service into etc file"

systemctl daemon-reload
VALIDATE $? "daemon-reload the services"

systemctl start backend
VALIDATE $? "starting the backend"

systemctl enable backend
VALIDATE $? "enable the backend"

dnf install mysql -y
VALIDATE $? "install the mysql"

mysql -h db.nsrikanth.online -uroot -pExpenseApp@1 < /app/schema/backend.sql
VALIDATE $? "load the schema"

systemctl restart backend
VALIDATE $? "restatr the backend"








    


