#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e " $R $2 ... Failure $N"
        exit 1
    else
        echo -e "$G $2 ... Success $N"

}

if [ $USERID -ne 0 ]
then
    echo -e " $R please run the inside the root user $N"
    exit 1
else
    echo -e " $G you are root user $N"
fi

dnf module disable nodejs -y  &>>$LOGFILE
VALIDATE $? "disable nodejs"

dnf module enable nodejs:20 -y  &>>$LOGFILE
VALIDATE $? "enable nodejs"

dnf install nodejs -y   &>>$LOGFILE
VALIDATE $? "install nodejs"

id expense
if [ $? -ne 0 ]
then
    useradd expense  &>>$LOGFILE
    VALIDATE $? "creating expense"
else
    echo "user already created"
fi

mkdir -p /app  &>>$LOGFILE
VALIDATE $? "creating app directoty"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>$LOGFILE
VALIDATE $? "download backend code"

cd /app  &>>$LOGFILE
VALIDATE $? "move to app"

rm -rf /app/*  &>>$LOGFILE
VALIDATE $? "removing everything the in cd directory"

unzip /tmp/backend.zip  &>>$LOGFILE
VALIDATE $? "unzip the code"

npm install  &>>$LOGFILE
VALIDATE $? "npm the dependies"

cp /home/ec2-user/expense-shell/backend1.service /etc/systemd/system/backend1.service  &>>$LOGFILE
VALIDATE $? "copy the code in backend1.service"

systemctl daemon-reload   &>>$LOGFILE
VALIDATE $? "realod the code"

systemctl start backend  &>>$LOGFILE
VALIDATE $? "starting the backend"

systemctl enable backend   &>>$LOGFILE
VALIDATE $? "enable the backend"

dnf install mysql -y   &>>$LOGFILE
VALIDATE $? "mysql install"

mysql -h db.nsrikanth.online -uroot -pExpenseApp@1 < /app/schema/backend.sql   &>>$LOGFILE
VALIDATE $? "Load the schema"

systemctl restart backend   &>>$LOGFILE
VALIDATE $? "restart the backend"



