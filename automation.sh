#initialization of variables
uName=purnima
s3Bucket=upgrad-purnima

inventoryFilePath=/var/www/html/inventory.html
cronJobPath=/etc/cron.d/automation

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

#step7:check inverntory file is present or not
if [ -f "$inventoryFilePath" ]
then
        echo "$inventoryFilePath  File present"
else
        echo "inventory.html File Not Found,Creating the new file"
        touch $inventoryFilePath
        echo "<b>Log Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Date Created &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Size</b>" >> $inventoryFilePath
        echo "new file is created in $inventoryFilePath"
fi
echo "adding backup log status into inventory.html file"
fileSize=$(du -h /var/tmp/$uName-httpd-logs-$timestamp.tar | awk '{print $1}')
echo "Backup Size :$fileSize"
echo "<br>httpd-logs &nbsp;&nbsp;&nbsp;&nbsp; $timestamp &nbsp;&nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp;&nbsp; $fileSize" >> $inventoryFilePath

#step8:checking the cronjob is present in etc/corn.d
if [ -f "$cronJobPath" ]
then
        echo "Cron job is scheduled already"
else
        touch $cronJobPath
        #this cron job will execute on every dat at 12.00
        echo "0 0 * * * root /root/Automation_Project/automation.sh" >> $cronJobPath
        echo "Cron Job is scheduled"
fi