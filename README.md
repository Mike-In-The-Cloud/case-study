# Goal
In this case study, you will deploy a highly available, resilient and secured web application to AWS using infrastructure as code. You will also create a full Software Development Life Cycle (SDLC) environment with isolated stages (Main, CI/CD, Development, Staging and Production).

# Background
The customer Drone Shuttles Ltd. is currently running their website on an outdated platform hosted in their own data center. They are about to launch a new product that will revolutionize the market and want to increase their social media presence with a blogging platform. During their ongoing modernization process they decide they want to use WordPress for their marketing efforts.

They do not know what kind of traffic to expect so the solution should be able to adapt to traffic spikes. It is expected that during the new product launch or marketing campaigns there could be increases of up to 4 times the typical load. It is crucial that the platform remains online even in case of a significant geographical failure. The customer is also interested in disaster recovery capabilities in case of a region failure.
Their development team wants to be able to release new versions of the application multiple times per day, without requiring any downtime. They also want to have multiple separated environments to support their development efforts. As there will be multiple environments, their admin team needs tools to support their operations and help them with visualizing and debugging the state of the environments, user & permission management and costs. The website will be exposed to the internet; thus, their security team also needs to have visibility into the platform and its operations. Each team should have its own credentials and limited required access to perform their jobs.

You are tasked to deliver a Proof of Concept for their new website. Your role is to design and implement a solution architecture that covers the previously mentioned requirements, using AWS. The solution should be optimized for costs and easy to maintain/develop in the future.

 

Note: Please try to deliver the best solution you can, given the time that you have available. If there are any parts that are not clear, please do not hesitate to reach out for clarification. 

* Make sure the following points are checked:

* There should be SDLC environments for each stage of the development process.

* There should be a centralized billing and logging.

* There should be organization governance with least privilege and zero trust policy for users/groups.

* The application should be able to scale depending on the load.

* There should be no obvious security flaws.

* The implementation should be built in a resilient manner i.e., immune to any disasters like server failures, fire in a region, etc.

* The deployment of the application should be fully automated.

* Production environment should be highly secured.

* Solution should be cost optimized.

 

# Mandatory Services to use
* Git
* IAM
* Infrastructure as code (CloudFormation/Terraform/cdk etc.)
* AWS Organizations
* AWS SSO
* AWS CloudTrail and CloudWatch
* AWS Billing
* AWS Codepipeline
* Route53
* AWS Config
* AWS VPC
* AWS Aurora
* AWS Elasticache
* Amazon Elastic Filesystem (EFS) 
* DNS
* NAT Gateway
* AWS CloudFront

# Usage of Accounts and Services
You are supposed to use your private AWS accounts to complete this case study. Since it will be your private accounts, keep in mind of the following which each team must do as soon as possible:

Make sure your email id is eligible to use AWS Free Tier. If you have used your email id already to create AWS account then you might not be eligible for AWS Free Tier. Follow Eligibility for the AWS Free Tier - AWS Billing (amazon.com) to check your AWS Free tier eligibility.

Create a main account according to the case study and first set up the centralized billing.

Put 1 euro cost threshold for each account and create email notification for threshold breach.

Use the free/cheapest option inside each AWS service. For example, use t2.micro inside VPC which comes under AWS free tier. Check Free Cloud Computing Services - AWS Free Tier (amazon.com) for all the free options inside each AWS service.

Keep an eye on your AWS spend every day.

Delete resources and then delete accounts after the case study is finished. Nothing should be left. Nordcloud will reimburse for costs incurred during this time, but not if you leave stuff in AWS after work is done.

# Timeline and Sprints
Ways of Working
You will collaborate in 4-5 people teams, organized by the trainers.

Each sprint will start on a Monday and end on a Friday. The duration of each sprint is 1 week. 

Every team will select their Scrum master, and the PO will be assigned by the trainers.

Each team will perform a sprint retrospective on the Monday after the sprint.

Each team should have a daily ceremony.

Each team will choose the collaboration tools they prefer. We recommend Jira, GitHub, Slack and Google Meet as communication tools.

 # Expectations and deliverables

| Sprint        | Expectations           | Deliverables  |
| :------------- |:-------------| :----- |
|1 |  <ul><li>Organize, digest, prepare and plan.</li><li>Setup SDLC environments (main, CI/CD, dev, staging and prod) and different users/groups (admin, security, developers etc.) using SSO. Setup and centralized billing and logging.</li></ul> | <ul><li> An isolated set of secure environments and different users/groups. </li> A web portal enabling to login to each of the user specific environments: main, dev, staging, prod, CI/CD. <li> A central billing system enabling you to control your spending across your environments. </li> <li> A central activity view that provides visibility over what is done in each of your environments. </li> <li> A central users and permissions management service enabling you to control what your team members can and cannot do in your different environments. </li> <li> An isolated DNS management zone to securely control your main DNS domains. Getting free domains is explained at the bottom of this document. </li> </ul> |
|2 |<ul><li> Develop a highly available, resilient, secured, auto-scaling multi-tier web application on development environment as developer.</li><li> Code for installing WordPress on ec2 instance is at the bottom of this document.</li></ul>| <ul><li>VPC Network across multiple AWS availability zones in a single AWS region. </li><li> Highly available secured database with cache capability to reduce the load of incoming queries. </li><li> a distributed NFS filesystem to share a single WordPress installation across multiple application servers. </li><li>  A collection of virtual machines based on AWS auto scaling and the AWS Application Load Balancer.</li></ul> |
|3 | <ul><li>Automate the deployment of resources which were created in week 2 to deploy them on staging and production. </li></ul> | <ul><li> *Can be extended to week 4.* </li><li>Infrastructure from week 2 as code in git.</li></li><li>Pipeline for automated deployment in CI/CD environment.</li></li><li>Automated Deployment of resources (written as Infrastructure as code) in staging and production environment which is triggered by git push in master branch.</li></ul>|
|4 | <ul><li>Optional features:</li><li>Customize SSO endpoint</li><li> Find the costs of your deployed resources.</li><li>Use AWS WAF to protect website</li><li>Use AWS global accelerator to speed up the access to website</li><li>Infrastructure as a code for the resources created in  week 1 and create a pipeline in main account to deploy those resources.</li></ul>| The final project with everything up and running, secure and error-free, available for the customer / trainers to check|

```console
#!/bin/bash -xe

EFS_MOUNT="<YOUR-EFS-HOSTNAME>"

DB_NAME="wordpress"
DB_HOSTNAME="<YOUR-DB-HOSTNAME>"
DB_USERNAME="<YOUR-DB-USERNAME>"
DB_PASSWORD="<YOUR-DB-PASSWORD>"

WP_ADMIN="wpadmin"
WP_PASSWORD="WpPassword$"

LB_HOSTNAME="<YOUR-ALB-HOSTNAME>"

yum update -y
yum install -y awslogs httpd24 mysql56 php55 php55-devel php55-pear php55-mysqlnd gcc-c++ php55-opcache

mkdir -p /var/www/wordpress
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $EFS_MOUNT:/ /var/www/wordpress

## create site config
cat <<EOF >/etc/httpd/conf.d/wordpress.conf
ServerName 127.0.0.1:80
DocumentRoot /var/www/wordpress/wordpress
<Directory /var/www/wordpress/wordpress>
  Options Indexes FollowSymLinks
  AllowOverride All
  Require all granted
</Directory>
EOF

## install cache client
pecl install igbinary-2.0.8
wget -P /tmp/ https://s3.amazonaws.com/aws-refarch/wordpress/latest/bits/AmazonElastiCacheClusterClient-1.0.1-PHP55-64bit.tgz
tar -xf '/tmp/AmazonElastiCacheClusterClient-1.0.1-PHP55-64bit.tgz'
cp 'AmazonElastiCacheClusterClient-1.0.0/amazon-elasticache-cluster-client.so' /usr/lib64/php/5.5/modules/
if [ ! -f /etc/php-5.5.d/50-memcached.ini ]; then
    touch /etc/php-5.5.d/50-memcached.ini
fi
echo 'extension=igbinary.so;' >> /etc/php-5.5.d/50-memcached.ini
echo 'extension=/usr/lib64/php/5.5/modules/amazon-elasticache-cluster-client.so;' >> /etc/php-5.5.d/50-memcached.ini

## install wordpress
if [ ! -f /bin/wp/wp-cli.phar ]; then
   curl -o /bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
   chmod +x /bin/wp
fi
# make site directory
if [ ! -d /var/www/wordpress/wordpress ]; then
   mkdir -p /var/www/wordpress/wordpress
   cd /var/www/wordpress/wordpress
   # install wordpress if not installed
   # use public alb host name if wp domain name was empty
   if ! $(wp core is-installed --allow-root); then
       wp core download --version='4.9' --locale='en_GB' --allow-root
       wp core config --dbname="$DB_NAME" --dbuser="$DB_USERNAME" --dbpass="$DB_PASSWORD" --dbhost="$DB_HOSTNAME" --dbprefix=wp_ --allow-root
       wp core install --url="http://$LB_HOSTNAME" --title='Wordpress on AWS' --admin_user="$WP_ADMIN" --admin_password="$WP_PASSWORD" --admin_email='admin@example.com' --allow-root
       wp plugin install w3-total-cache --allow-root
       # sed -i \"/$table_prefix = 'wp_';/ a \\define('WP_HOME', 'http://' . \\$_SERVER['HTTP_HOST']); \" /var/www/wordpress/wordpress/wp-config.php
       # sed -i \"/$table_prefix = 'wp_';/ a \\define('WP_SITEURL', 'http://' . \\$_SERVER['HTTP_HOST']); \" /var/www/wordpress/wordpress/wp-config.php
       # enable HTTPS in wp-config.php if ACM Public SSL Certificate parameter was not empty
       # sed -i \"/$table_prefix = 'wp_';/ a \\# No ACM Public SSL Certificate \" /var/www/wordpress/wordpress/wp-config.php
       # set permissions of wordpress site directories
       chown -R apache\:apache /var/www/wordpress/wordpress
       chmod u+wrx /var/www/wordpress/wordpress/wp-content/*
       if [ ! -f /var/www/wordpress/wordpress/opcache-instanceid.php ]; then
         wget -P /var/www/wordpress/wordpress/ https://s3.amazonaws.com/aws-refarch/wordpress/latest/bits/opcache-instanceid.php
       fi
   fi
   RESULT=$?
   if [ $RESULT -eq 0 ]; then
       touch /var/www/wordpress/wordpress/wordpress.initialized
   else
       touch /var/www/wordpress/wordpress/wordpress.failed
   fi
fi

## install opcache
if [ ! -d /var/www/.opcache ]; then
    mkdir -p /var/www/.opcache
fi
# enable opcache in /etc/php-5.5.d/opcache.ini
sed -i 's/;opcache.file_cache=.*/opcache.file_cache=\/var\/www\/.opcache/' /etc/php-5.5.d/opcache.ini
sed -i 's/opcache.memory_consumption=.*/opcache.memory_consumption=512/' /etc/php-5.5.d/opcache.ini
# download opcache-instance.php to verify opcache status
if [ ! -f /var/www/wordpress/wordpress/opcache-instanceid.php ]; then
    wget -P /var/www/wordpress/wordpress/ https://s3.amazonaws.com/aws-refarch/wordpress/latest/bits/opcache-instanceid.php
fi

chkconfig httpd on
service httpd start
```
