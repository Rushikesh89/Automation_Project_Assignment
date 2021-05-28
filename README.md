# Automation_Project
Upgrad Code Assignment

This Script Should Perform below tasks -

1) Perform an update of the package details and the package list at the start of the script.
sudo apt update -y

2) Install the apache2 package if it is not already installed. (The dpkg and apt commands are used to check the installation of the packages.)
Ensure that the apache2 service is running. 
3) Ensure that the apache2 service is enabled. (The systemctl or service commands are used to check if the services are enabled and running. Enabling apache2 as a service ensures that it runs as soon as our machine reboots. It is a daemon process that runs in the background.)
4) Create a tar archive of apache2 access logs and error logs that are present in the /var/log/apache2/ directory and place the tar into the /tmp/ directory. Create a tar of only the .log files (for example access.log) and not any other file type (For example: .zip and .tar) that are already present in the /var/log/apache2/ directory. The name of tar archive should have following format:  <your _name>-httpd-logs-<timestamp>.tar. For example: Ritik-httpd-logs-01212021-101010.tar                                                             Hint : use timestamp=$(date '+%d%m%Y-%H%M%S') )
5)The script should run the AWS CLI command and copy the archive to the s3 bucket. 
#Hint : use timestamp=$(date '+%d%m%Y-%H%M%S') ) to name  the  tar
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
 
6) Copying to the S3 bucket will require AWS Command Line Interface (CLI)  to be installed in the system. You can install AWS CLI manually before writing and testing the script. 

 
  Installing awscli 
  
  sudo apt update
 
  sudo apt install awscli
