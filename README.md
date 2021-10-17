# UpGrad-Course_Assignment: Automation_Project by Purnima Choudhary
---------------------------------------------------------------------
Tasks executed by script:

1- Perform an update of the packages
sudo apt update -y

2- Install the apache2 package if it is not already installed. 
  apt-get install apache2

3- check the apache2 service status
ervice apache2 status
 
4- creat timestamp
timestamp=$(date '+%d%m%Y-%H%M%S')

5- create tar file
cd /var/log/apache2
sudo tar -czvf /var/tmp/purnima-httpd-logs-$timestamp.tar access.log error.log 

6- copy tar file to s3 bucket
aws s3 cp /var/tmp/purnima-httpd-logs-$timestamp.tar s3://upgrad-purnima/purnima-httpd-logs-$timestamp.tar