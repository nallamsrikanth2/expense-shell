#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$LOGFILE.log

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$2 is $R failure $N"
    else
        echo -e "$2 is $G success $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo -e " $R please run the script inside the root server $N"
else
    echo -e "$G you are in root user $N"
fi

dnf install nginx -y  &>>$LOGFILE
VALIDATE $? "install nginx"

systemctl enable nginx   &>>$LOGFILE
VALIDATE $? "enable nginx"

systemctl start nginx    &>>$LOGFILE
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/*   &>>$LOGFILE
VALIDATE $? "removing evrything in that html folder"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip    &>>$LOGFILE
VALIDATE $? "download the frontend code"

cd /usr/share/nginx/html   &>>$LOGFILE
unzip /tmp/frontend.zip    &>>$LOGFILE
VALIDATE $? "unzip the frontend code"

cp /home/ec2-user/expense-shell/expense.conf  /etc/nginx/default.d/expense.conf   &>>$LOGFILE
VALIDATE $? "copiying the code"

systemctl restart nginx   &>>$LOGFILE
VALIDATE $? "restart the nginx"




