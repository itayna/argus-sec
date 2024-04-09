provider "aws" {
  region     = "us-east-1"
  access_key = "AKIASLB6R574JHC2QEOJ"
  secret_key = "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"
}

# Create VPC
resource "aws_vpc" "jenkins_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "jenkins-vpc"
  }
}

# Create public subnet
resource "aws_subnet" "jenkins_public_subnet" {
  vpc_id     = aws_vpc.jenkins_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "jenkins-public-subnet"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "jenkins-igw"
  }
}

# Create route table and associate with public subnet
resource "aws_route_table" "jenkins_public_rt" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }

  tags = {
    Name = "jenkins-public-rt"
  }
}

resource "aws_route_table_association" "jenkins_public_subnet_association" {
  subnet_id      = aws_subnet.jenkins_public_subnet.id
  route_table_id = aws_route_table.jenkins_public_rt.id
}

# Create security group
resource "aws_security_group" "jenkins_sg" {
  name_prefix = "jenkins-"
  vpc_id      = aws_vpc.jenkins_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Create S3 bucket
resource "aws_s3_bucket" "argus_sec_bucket" {
  bucket = "s3-argus-sec-useast1-01"
}

resource "aws_s3_bucket_acl" "argus_sec_bucket_acl" {
  bucket = aws_s3_bucket.argus_sec_bucket.id
  acl    = "private"
}

# Create ECR repository
resource "aws_ecr_repository" "argus_sec_ecr" {
  name = "ecr-argus-sec-useast1-01"
}

# Create IAM role for EC2 instance
resource "aws_iam_role" "jenkins" {
  name = "jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach IAM policies to the role
resource "aws_iam_role_policy_attachment" "jenkins_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.jenkins.name
}

# Create IAM instance profile
resource "aws_iam_instance_profile" "jenkins" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins.name
}

# Create EC2 instance
resource "aws_instance" "jenkins" {
  ami           = "ami-051f8a213df8bc089" # Latest Amazon Linux 2 AMI
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.jenkins_sg.id,
  ]

  subnet_id = aws_subnet.jenkins_public_subnet.id

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  user_data = <<-EOF
             #!/bin/bash
             sudo yum update -y
             sudo amazon-linux-extras install docker
             sudo systemctl start docker
             sudo systemctl enable docker
             sudo docker run -d -p 8080:8080 -v /var/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock 161192472568.dkr.ecr.us-east-1.amazonaws.com/jenkins-controller:latest
             EOF

  tags = {
    Name = "ec2-argus-sec-useast1-01"
  }
}