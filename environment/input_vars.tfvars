#moduleVPC
vpc_id = " "
cidr_block = "10.0.0.0/16"
PublicSubnet1Param = "10.0.0.0/24"
PublicSubnet2Param = "10.0.1.0/24"
AppSubnet1Param = "10.0.2.0/24"
AppSubnet2Param = "10.0.3.0/24"
DatabaseSubnet1Param = "10.0.4.0/24"
DatabaseSubnet2Param = "10.0.5.0/24"
lb_default_sg_id = " "
#moduleCompute
elbsubnets = [" "]
asg_subnets=[" "]
albsecuritygroups = [" "]
appsecurtiygroup = [" "]
database_name = " "
db_writer_endpoint = " "
database_username = " "
database_password = " "
efs_id = " "
#module-efs
efssubnetname1 = " "
efssubnetname2 = " "
efssgname = [" "]
#module-databse
instanceclass = "db.t3.small"
db_name = "CasestudyDB"
db_username = "admin"
db_password = "admin123"
dbengine_type = "aurora-mysql"
dbengine_version = "5.7.mysql_aurora.2.07.2"
db_subnet_group = " "
db_security_group = [" "]
cache_engine = "memcached"
cache_node_type = "cache.t3.micro"
cache_parameter_group = "default.memcached1.6"
cache_security_group = [" "]
cache_subnet_group = " "
