provider "aws" {
  region = "eu-north-1"
}

resource "aws_vpc" "spark_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "spark_vpc"
  }
}

resource "aws_internet_gateway" "spark_igw" {
  vpc_id = aws_vpc.spark_vpc.id

  tags = {
    Name = "spark_igw"
  }
}

resource "aws_subnet" "spark_subnet" {
  vpc_id            = aws_vpc.spark_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "spark_subnet"
  }
}

resource "aws_route_table" "spark_rt" {
  vpc_id = aws_vpc.spark_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.spark_igw.id
  }

  tags = {
    Name = "spark_rt"
  }
}

resource "aws_route_table_association" "spark_rta" {
  subnet_id      = aws_subnet.spark_subnet.id
  route_table_id = aws_route_table.spark_rt.id
}

resource "aws_security_group" "spark_sg" {
  name        = "spark_security_group"
  description = "Allow SSH and Spark Web UI access"
  vpc_id      = aws_vpc.spark_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "spark_sg"
  }
}

resource "aws_instance" "spark_instance" {
  ami                    = "ami-09a6bd44f658d0bbc"
  instance_type          = "t3.micro"
  key_name               = "myKey"
  subnet_id              = aws_subnet.spark_subnet.id
  vpc_security_group_ids = [aws_security_group.spark_sg.id]

  user_data = templatefile("${path.module}/init-spark.tpl", {})
  
  tags = {
    Name = "ApacheSparkInstance"
  }
}