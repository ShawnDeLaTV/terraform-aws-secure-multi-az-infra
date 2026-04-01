data "aws_ami" "linux-amazon-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

resource "aws_launch_template" "web_server_lt" {
  image_id               = data.aws_ami.linux-amazon-ami.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.web-server-sg-id]

  user_data = base64encode(<<-EOF
        #!/bin/bash
        # Installation d'Apache
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd

        # Récupération du Token (obligatoire pour IMDSv2)
        TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

        # Récupération de l'AZ via les métadonnées
        AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

        # Création de la page Web avec l'AZ affichée
        echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
        echo "<h2>Zone de disponibilite : <span style='color:red'>$AZ</span></h2>" >> /var/www/html/index.html
        EOF
  )
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity = 3
  max_size         = 4
  min_size         = 2

  vpc_zone_identifier = [var.private-subnet-a-id, var.private-subnet-b-id]
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.web_server_lt.id
    version = "$Latest"
  }
}



/*

resource "aws_instance" "example" {
  count = 2
  ami           = data.aws_ami.linux-amazon-ami.id
  instance_type = "t3.micro"
  subnet_id     = var.private-subnet-a-id
  vpc_security_group_ids = [var.web-server-sg-id]

  user_data = <<-EOF
        #!/bin/bash
        # Installation d'Apache
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd

        # Récupération du Token (obligatoire pour IMDSv2)
        TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

        # Récupération de l'AZ via les métadonnées
        AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

        # Création de la page Web avec l'AZ affichée
        echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
        echo "<h2>Zone de disponibilite : <span style='color:red'>$AZ</span></h2>" >> /var/www/html/index.html
                EOF

  tags = {
    Name = "EC2Instance-${count.index}"
  }
}

resource "aws_instance" "exampleB" {
  count = 2
  ami           = data.aws_ami.linux-amazon-ami.id
  instance_type = "t3.micro"
  subnet_id     = var.private-subnet-b-id
  vpc_security_group_ids = [var.web-server-sg-id]

  user_data = <<-EOF
                #!/bin/bash
                # Use this for your user data (script from top to bottom)
                # install httpd (Linux 2 version)
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "EC2Instance-${count.index}"
  }
}
*/