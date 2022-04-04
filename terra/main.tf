terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

module "casetsudy_vpc" {
    source = "../modules/vpc"
    cidr_block = var.cidr_block
    PublicSubnet1Param = var.PublicSubnet1Param
    PublicSubnet2Param = var.PublicSubnet2Param
    AppSubnet1Param = var.AppSubnet1Param
    AppSubnet2Param = var.AppSubnet2Param
    DatabaseSubnet1Param = var.DatabaseSubnet1Param
    DatabaseSubnet2Param = var.DatabaseSubnet2Param
    lb_default_sg_id = module.casestudy_compute.LBDefaultSGID
}

module "casestudy_efs" {
    source = "../modules/efs"
    efssubnetname1 = module.casetsudy_vpc.AppSubnet1Name
    efssubnetname2 = module.casetsudy_vpc.AppSubnet2Name
    efssgname = [module.casetsudy_vpc.EFSMountTargetSGName]
  
}

module "casestudy_databse" {
    source = "../modules/database"
    db_subnet_group = module.casetsudy_vpc.rdsSubnetGroupName
    db_security_group = [module.casetsudy_vpc.rdsSecurityGroupName]
    db_username = var.db_username
    db_password = var.db_password
    dbengine_type = var.dbengine_type
    dbengine_version = var.dbengine_version
    instanceclass = var.instanceclass
    db_name = var.db_name
    cache_engine = var.cache_engine
    cache_node_type = var.cache_node_type
    cache_parameter_group = var.cache_parameter_group
    cache_security_group = [module.casetsudy_vpc.ElastiCacheSGName]
    cache_subnet_group = module.casetsudy_vpc.ElasticacheSubnetGroupName


}
module "casestudy_compute" {
    source = "../modules/compute"
    vpc_id = module.casetsudy_vpc.vpc-id
    elbsubnets = [module.casetsudy_vpc.PublicSubnet1Name, module.casetsudy_vpc.PublicSubnet2Name]
    asg_subnets = [module.casetsudy_vpc.AppSubnet1Name, module.casetsudy_vpc.AppSubnet2Name]
    albsecuritygroups = [module.casetsudy_vpc.AppinstanceSGName, module.casestudy_compute.LoadBalancerDefaultSecurityGroup]
    appsecurtiygroup = [module.casetsudy_vpc.AppinstanceSGName]
    database_name = module.casestudy_databse.dbname
    db_writer_endpoint = module.casestudy_databse.writer-cluster-endpoint
    database_username = module.casestudy_databse.dbusername
    database_password = module.casestudy_databse.dbpassword
    efs_id = module.casestudy_efs.EFSid
}

/*
module "terraform_state_backend" {
    source = "../modules/terraform_backend"
    stack_name      = var.stack_name
  
}
*/