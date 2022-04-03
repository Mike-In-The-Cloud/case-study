#create a EFS File system
resource "aws_efs_file_system" "Casestudy-EFS" {
  creation_token = "${terraform.workspace}-Casestudy-EFS"
  encrypted = true
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "${terraform.workspace}-Casestudy-EFS"
  }
}
#create a backup policy
resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.Casestudy-EFS.id

  backup_policy {
    status = "ENABLED"
  }
}
#Mount Efs target to subnet in first AZ
resource "aws_efs_mount_target" "Casestudy-mount-efs-subnet1" {
  file_system_id = aws_efs_file_system.Casestudy-EFS.id
  subnet_id      = var.efssubnetname1
  security_groups = var.efssgname
}
#Mount Efs target to subnet in second AZ
resource "aws_efs_mount_target" "Casestudy-mount-efs-subnet2" {
  file_system_id = aws_efs_file_system.Casestudy-EFS.id
  subnet_id      = var.efssubnetname2
  security_groups = var.efssgname
}

/*
resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.fs.id

  bypass_policy_lockout_safety_check = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "ExamplePolicy01",
    "Statement": [
        {
            "Sid": "ExampleStatement01",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.test.arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "true"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_efs_mount_target" "efs-mount" {
   count = "length(aws_subnet.public_subnet.*.id)"
   file_system_id  = "${aws_efs_file_system.magento-efs.id}"
   subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
   security_groups = ["${aws_security_group.efs-sg.id}"]
}
*/