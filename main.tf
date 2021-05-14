
provider "aws" {
  region  = var.region
  
}




# Define VPC
resource "aws_vpc" "test_vpc" {

  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "TestVPC"
  }
}

#Define public Subnet
resource "aws_subnet" "test_subnet" {

  vpc_id = aws_vpc.test_vpc.id
  cidr_block= "172.16.10.0/24"
  
  tags = {
    Name = "TestSubnet"
  }
  
}

# Define the internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "TestIGW"
  }
}

# Define the route table
resource "aws_route_table" "test_rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "TestSubnet RT"
  }
}
# Assign the route table to the public Subnet
resource "aws_route_table_association" "test_subnet_rt" {
  subnet_id = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_rt.id
}

# Define the security group for public subnet
resource "aws_security_group" "test_sg" {
  name = "vpc_test_web"
  description = "Allow incoming/Outgoing HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  vpc_id=aws_vpc.test_vpc.id
  tags = {
    "Name" = "TestInstance_SG"
  }

  
}


# Define SSH key pair for our instances
#resource "aws_key_pair" "default" {
#  key_name = "testkeypair"
#  public_key = file(var.key_path)
#}

#Define instance for our web server
resource "aws_instance" "test_instance" {
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id = aws_subnet.test_subnet.id
  associate_public_ip_address = true
   vpc_security_group_ids = [aws_security_group.test_sg.id]
  key_name = aws_key_pair.default.id
  

 

 // provisioner "remote-exec" {
    //inline = [
     // "sudo yum update -y",
    //  "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2",
   //   "sudo yum install -y httpd",
    //  "sudo systemctl start httpd"
  //  ]
// }
  //  connection {

   //   type= "ssh"
   //   password=""
    //  private_key = file("~/.ssh/id_rsa")
  //    host= self.public_ip
//    }
  
  


  

  tags = {
    Name = "TestInstance"
  }
}

