output "vpc-id" {
  value = aws_vpc.CaseStudyVPC.id
}

output "PublicSubnet1Name" {
  value = aws_subnet.PublicSubnet1.id
}

output "PublicSubnet2Name" {
  value = aws_subnet.PublicSubnet2.id
}

output "AppSubnet1Name" {
  value = aws_subnet.AppSubnet1.id
}

output "AppSubnet2Name" {
  value = aws_subnet.AppSubnet2.id
}

output "DatabaseSubnet1Name" {
  value = aws_subnet.DatabaseSubnet1.id
}

output "DatabaseSubnet2Name" {
  value = aws_subnet.DatabaseSubnet2.id
}

output "ElasticacheSubnetGroupName" {
  value = aws_elasticache_subnet_group.ElasticacheSubnetGroup.id
}

output "rdsSubnetGroupName" {
  value = aws_db_subnet_group.auroraSubnetGroup.id
}

output "rdsSecurityGroupName" {
  value = aws_security_group.RDSSecurityGroup.id
}

output "AppinstanceSGName" {
  value = aws_security_group.AppInstanceSecurityGroup.id
}

output "ElastiCacheSGName" {
  value = aws_security_group.ElastiCacheSecurityGroup.id
}

output "EFSMountTargetSGName" {
  value = aws_security_group.EFSMountTargetSecurityGroup.id
}