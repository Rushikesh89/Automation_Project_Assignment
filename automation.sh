#initialization of variables
uName=rushikesh
s3Bucket=upgrad-rushikesh
inventoryFilePath=/var/www/html/inventory.html
cronJobPath=/etc/cron.d/automation
#step1: Update the package details and package list at the start of the script
apt update -y
#step2: check if apache2 is installed or not
dpkg -i apache2
if [ $? -ge 1 ]
then
        apt-get install apache2
fi
#step3:check if apache service is running or not
service apache2 status
if [ $? -ge 1 ]
then
        systemctl start apache2
fi
#step 4-A check if service is runnin or not
service apache2 status
if [ $? -eq 0 ]
then
        echo 'Apache2 service is running'
else
        service apache2 start
fi
#step4:creat timestamp to add in this into name
timestamp=$(date '+%d%m%Y-%H%M%S')
#now create tar file into temp folder
cd /var/log/apache2
sudo tar -czvf /var/tmp/$uName-httpd-logs-$timestamp.tar access.log error.log
#step5:copy tar file into s3 bucket
aws s3 cp /var/tmp/$uName-httpd-logs-$timestamp.tar s3://${s3Bucket}/$uName-httpd-logs-$timestamp.tar
#step6:check inverntory file is present or not
if [ -f "$inventoryFilePath" ]
then
        echo "$inventoryFilePath  File Found"
else
        echo "File Not Found,Creating the new file"
        touch $inventoryFilePath
        echo "<b>Log Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Date Created &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Size</b>" >> $inventoryFilePath
        echo "new file is created in $inventoryFilePath"
fi
echo "adding backup log status into html file"
fileSize=$(du -h /var/tmp/$uName-httpd-logs-$timestamp.tar | awk '{print $1}')
echo $fileSize
echo "<br>httpd-logs &nbsp;&nbsp;&nbsp;&nbsp; $timestamp &nbsp;&nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp;&nbsp; $fileSize" >> $inventoryFilePath
#step7:checking the cronjob is present in etc/corn.d
if [ -f "$cronJobPath" ]
then
        echo "Cron job file is present"
else
        touch $cronJobPath
		#this cron job will execute on every dat at 1.00
        echo "0 1 *  * * root /root/Automation_Project/automation.sh" >> $cronJobPath
        echo "Cron Job is scheduled"
fi
