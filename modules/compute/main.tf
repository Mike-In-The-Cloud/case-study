#Load Balancer
resource "aws_security_group" "alb" {
  name        = "lb_http_default"
  description = "Allow HTTP traffic to instances through Elastic Load Balancer"
  vpc_id =  var.vpc_id
  #idle_timeout = "65"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-default-security_group-ALB"
  }
}
resource "aws_alb" "alb" {
  name = "WPLoadBalancer"
  load_balancer_type = "application"
  security_groups =  var.albsecuritygroups
    # allow inboud http 80 traffic for default security group in the app instance security group
  subnets = var.elbsubnets
  tags = {
    Name = "${terraform.workspace}-Casestudy-ALB"
  }

}

#Target Group
resource "aws_alb_target_group" "group" {
  name     = "terraform-example-alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  # Alter the destination of the health check to be the login page.
  health_check {
    healthy_threshold = 2  
    unhealthy_threshold = 10
    timeout = 50
    interval = 60
    port = 80
    path = "/wp-login.php"
    matcher = "200" # has to be HTTP 200 or fails
  }
   tags = {
    Name = "${terraform.workspace}-Casestudy-targetgroup"
  }
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.group.arn
    type             = "forward"
  }
}

#Launch Template
resource "aws_launch_template" "launch_template" {
  name = "CasestudyLaunchTemplate"
  instance_type = "t2.micro"
  image_id = "ami-0c02fb55956c7d316"
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids = var.appsecurtiygroup
  user_data = base64encode(data.template_file.userdata.rendered)
   tags = {
    Name = "${terraform.workspace}-LaunchTemplate"
  }
}

data "template_file" "userdata" {
  template = file("../shell/wordpress.sh")
  vars = {
        DB_NAME                    = var.database_name
        DB_HOSTNAME                = var.db_writer_endpoint
        DB_USERNAME                = var.database_username
        DB_PASSWORD                = var.database_password
        WP_ADMIN                   = "admin"
        WP_PASSWORD                = "Password"
        WP_EMAIL                   = "xyz@hotmail.fr"
        LB_HOSTNAME                = aws_alb.alb.dns_name
        EFS_ID                     = var.efs_id
  }
}
#AutoScaling Group
resource "aws_autoscaling_group" "wp_autoscaling_group" {
  name = "${aws_launch_template.launch_template.name}-asg"

  min_size             = 2
  desired_capacity     = 2
  max_size             = 4
  
  health_check_type    = "ELB"
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  vpc_zone_identifier  =  var.asg_subnets

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${terraform.workspace}-AutoscalingGroup"
    propagate_at_launch = true
  }
    target_group_arns = [aws_alb_target_group.group.arn]

}