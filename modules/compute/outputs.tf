output "LoadBalancerDNSName" {
    value = aws_alb.alb.dns_name
}

output "LoadBalancerDefaultSecurityGroup" {
    value = aws_security_group.alb.id
}

output "LBDefaultSGID" {
    value = aws_security_group.alb.id
}