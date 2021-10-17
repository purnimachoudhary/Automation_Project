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

7- check inverntory file is present or not
    else create a new path

8- check the cronjob is present in etc/corn.d
    else make it a schedule

# Note:
Copying to the S3 bucket will require AWS Command Line Interface (CLI)  to be installed in the system. You can install AWS CLI manually before writing and testing the script. 

- Installing awscli 
    sudo apt update
    sudo apt install awscli

- Always run scripts with root privileges or first switch to the root user with sudo su and then run the scripts.
    switch to root user with sudo su or run as sudo
        sudo  su 
        
        ex: sudo ./root/Automation_Project/automation.sh