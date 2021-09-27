#!/bin/bash

yum update -y
yum -y install httpd
systemctl start httpd.service
systemctl enable httpd.service
aws s3 cp s3://${bucket_name}/${html_name} /var/www/html/index.html