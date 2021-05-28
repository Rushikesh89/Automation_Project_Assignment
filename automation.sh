#initialization of variables
uName=rushikesh
s3Bucket=upgrad-rushikesh
#step1: Update the package details and package list at the start of the script
sudo apt update -y
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

