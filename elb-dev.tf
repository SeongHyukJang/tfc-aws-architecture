############################# WEB NLB #################################
resource "aws_lb" "web_alb_dev" {
    name = "70491-web-alb-dev"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg_dev.id]
    subnets = [aws_subnet.public_subnet_a_dev.id, aws_subnet.public_subnet_c_dev.id]
}

resource "aws_lb_target_group" "ec2_web_target_group_dev" {
    name = "70491-ec2-web-target-group-dev"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main_vpc_dev.id
}

resource "aws_lb_listener" "web_alb_listener_dev" {
    load_balancer_arn = aws_lb.web_alb_dev.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.ec2_web_target_group_dev.arn
    }
  
}

#######################################################################
############################# WAS NLB #################################
resource "aws_lb" "was_elb_dev" {
    name = "70491-was-elb-dev"
    internal = true
    load_balancer_type = "network"
    subnets = [aws_subnet.ap_private_subnet_a_dev.id]
}

resource "aws_lb_target_group" "ec2_was_target_group_dev" {
    name = "70491-ec2-was-target-group-dev"
    port = 80
    protocol = "TCP"
    vpc_id = aws_vpc.main_vpc_dev.id
}

resource "aws_lb_listener" "was_alb_listener_dev" {
    load_balancer_arn = aws_lb.was_elb_dev.arn
    port = "80"
    protocol = "TCP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.ec2_was_target_group_dev.arn
    }
  
}

#######################################################################