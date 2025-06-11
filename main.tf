resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.joindevops.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-07b7880de86939082"]
  subnet_id              = "subnet-0c6a7377e3409382e"
  user_data = file("jenkins.sh")

  root_block_device {
    volume_size = 50  # Set root volume size to 50GB
    volume_type = "gp3"  # Use gp3 for better performance (optional)
  }
  tags = merge(
    var.common_tags,
    {
        Name = "Jenkins"
    }
  )
}

resource "aws_instance" "jenkins-agent" {
  ami                    = data.aws_ami.joindevops.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-0baca4e85a0f3eafb"]
  subnet_id              = "subnet-0c6a7377e3409382e"
  user_data = file("jenkins-agent.sh")

  root_block_device {
    volume_size = 50  # Set root volume size to 50GB
    volume_type = "gp3"  # Use gp3 for better performance (optional)
  }
  tags = merge(
    var.common_tags,
    {
        Name = "Jenkins-agent"
    }
  )
}

resource "aws_route53_record" "jenkins" {
  zone_id = var.zone_id
  name    = "jenkins"
  type    = "A"
  ttl     = 1
  records = [aws_instance.jenkins.public_ip]
}

resource "aws_route53_record" "jenkins_agent" {
  zone_id = var.zone_id
  name    = "jenkins-agent"
  type    = "A"
  ttl     = 1
  records = [aws_instance.jenkins-agent.private_ip]
}
resource "aws_route53_record" "jenkins_private" {
  count   = aws_instance.jenkins.private_ip != "" ? 1 : 0
  zone_id = var.zone_id
  name    = "jenkins-private"
  type    = "A"
  ttl     = 1
  records = [aws_instance.jenkins.private_ip]
}
