#RDS Aurora Databse
resource "aws_rds_cluster_instance" "Casestudy-database" {
  count              = 2
  identifier         = "${terraform.workspace}-casestudydatabase-${count.index}"
  cluster_identifier = aws_rds_cluster.Casestudydatabase-cluster.id
  instance_class     = var.instanceclass
  engine             = aws_rds_cluster.Casestudydatabase-cluster.engine
  engine_version     = aws_rds_cluster.Casestudydatabase-cluster.engine_version
  publicly_accessible = false

}

resource "aws_rds_cluster" "Casestudydatabase-cluster" {
  cluster_identifier = "${terraform.workspace}-casestudydatabase"
  availability_zones = [data.aws_availability_zones.available-AZ.names[0],data.aws_availability_zones.available-AZ.names[1]]
  engine             = var.dbengine_type
  engine_version     = var.dbengine_version
  database_name      = var.db_name
  master_username    = var.db_username
  master_password    = var.db_password
  db_subnet_group_name = var.db_subnet_group
  vpc_security_group_ids = var.db_security_group
  storage_encrypted = true
  #deletion_protection = true
  skip_final_snapshot = true
  apply_immediately = true
  tags = {
    Name = "${terraform.workspace}-Casestudy-Database"
  } 
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags,
      # updates these based on some ruleset managed elsewhere.
      tags, availability_zones
    ]
  }
}

#MemcachedElastic Cache
resource "aws_elasticache_cluster" "elasticcache-casestudy" {
  cluster_id           = "${terraform.workspace}-casestudycache"
  preferred_availability_zones    = [data.aws_availability_zones.available-AZ.names[0],data.aws_availability_zones.available-AZ.names[1]]
  engine               = var.cache_engine
  node_type            = var.cache_node_type
  num_cache_nodes      = 2
  parameter_group_name = var.cache_parameter_group
  port                 = 11211
  az_mode              = "cross-az"
  security_group_ids   = var.cache_security_group
  subnet_group_name    = var.cache_subnet_group
  tags = {
    Name = "${terraform.workspace}-Casestudy-Cache"
  }
}

