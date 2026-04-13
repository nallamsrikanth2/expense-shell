#!/bin/bash

CHECK_ROOT

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