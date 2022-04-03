output "ClusterName" {
  value = aws_rds_cluster.Casestudydatabase-cluster.database_name
}

output "reader-cluster-endpoint" {
  value = aws_rds_cluster.Casestudydatabase-cluster.reader_endpoint
}

output "writer-cluster-endpoint" {
  value = aws_rds_cluster.Casestudydatabase-cluster.endpoint
}

output "cache-endpoint" {
  value = aws_elasticache_cluster.elasticcache-casestudy.configuration_endpoint
}

output "dbname" {
  value = aws_rds_cluster.Casestudydatabase-cluster.database_name
}

output "dbusername" {
  value = aws_rds_cluster.Casestudydatabase-cluster.master_username
}

output "dbpassword" {
  value = aws_rds_cluster.Casestudydatabase-cluster.master_password
}