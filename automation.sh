#initialization of variables
uName=purnima
s3Bucket=upgrad-purnima

#step1: Update the packages
apt update -y

#step2: check if apache2 is installed or not
checkApache=$(dpkg --get-selections | grep apache2 | awk '{print $2}' | head -1)
if [ "$checkApache" = "deinstall" ] || [ -z "$checkApache" ];
then
        echo "Started installing apache"
        apt-get install apache2
else
        echo "Apache is installed"
fi

#step3:check if apache server is enabled
apacheStatus=$(service apache2 status | grep -i Active | awk '{print $2}')
if [ "$apacheStatus" = "inactive" ]
then
        systemctl start apache2
        echo "Apache server started"
fi

#step4: again check if service is started or not
serviceStatus=$(service --status-all | grep apache2 | awk '{print $2}')
if [ "$serviceStatus" = "+" ]
then
        echo "Apache service is running"
else
        service apache2 start
        echo "Apache service started"
fi

#creat timestamp
timestamp=$(date '+%d%m%Y-%H%M%S')

#step5: Create a tar archive of apache2 access logs and place the tar into the /tmp/ directory.
cd /var/log/apache2
sudo tar -czvf /var/tmp/$uName-httpd-logs-$timestamp.tar access.log error.log

#step6:copy tar file into s3 bucket
aws s3 cp /var/tmp/$uName-httpd-logs-$timestamp.tar s3://${s3Bucket}/$uName-httpd-logs-$timestamp.tar