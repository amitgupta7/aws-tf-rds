terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
//create an aws provider
provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_vpc" "test-vpc" {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
}

resource "aws_internet_gateway" "test-gateway" {
    vpc_id = "${aws_vpc.test-vpc.id}"
}

resource "aws_subnet" "test_public_subnet" {
    vpc_id = "${aws_vpc.test-vpc.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.region}b"
    tags = {
      Name = "public_subnet"
    }
}

resource "aws_subnet" "test_private_subnet1" {
    vpc_id = "${aws_vpc.test-vpc.id}"
    cidr_block = "10.0.101.0/24"
    availability_zone = "${var.region}b"
    tags = {
      Name = "public_subnet"
    }
}

resource "aws_subnet" "test_private_subnet2" {
    vpc_id = "${aws_vpc.test-vpc.id}"
    cidr_block = "10.0.102.0/24"
    availability_zone = "${var.region}c"
    tags = {
      Name = "public_subnet"
    }
}

resource "aws_route_table" "test_public_rt" {
  vpc_id = "${aws_vpc.test-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test-gateway.id}"
  }
}

resource "aws_route_table_association" "test_public_rt_association" {
  subnet_id      = "${aws_subnet.test_public_subnet.id}"
  route_table_id = "${aws_route_table.test_public_rt.id}"
}

resource "aws_route_table" "test_private_rt" {
  vpc_id = "${aws_vpc.test-vpc.id}"
}

resource "aws_route_table_association" "test_private_rt_association1" {
    route_table_id = "${aws_route_table.test_private_rt.id}"
    subnet_id = "${aws_subnet.test_private_subnet1.id}"
}

resource "aws_route_table_association" "test_private_rt_association2" {
    route_table_id = "${aws_route_table.test_private_rt.id}"
    subnet_id = "${aws_subnet.test_private_subnet2.id}"
}
#create a security group for RDS Database Instance
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  vpc_id = "${aws_vpc.test-vpc.id}"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "test_db_subnet_group" {
  name       = "test_db_subnet_group"
  subnet_ids = ["${aws_subnet.test_private_subnet1.id}", "${aws_subnet.test_private_subnet2.id}"]
  
}

#create a RDS Database Instance
resource "aws_db_instance" "myinstance" {
  db_subnet_group_name = aws_db_subnet_group.test_db_subnet_group.id
  engine               = "mysql"
  identifier           = "myrdsinstance"
  allocated_storage    =  20
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "myrdsuser"
  password             = "myrdspassword"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot  = true
  publicly_accessible =  true
}

output "db_instance_endpoint" {
  value       = aws_db_instance.myinstance.endpoint
}