resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.joindevops.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-06520ec3327a345da"]
  subnet_id              = "subnet-0ab65c04248000ac8"
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
  vpc_security_group_ids = ["sg-0d679b6f128394e1c"]
  subnet_id              = "subnet-0ab65c04248000ac8"
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
