resource "aws_key_pair" "ec2Key" {
  key_name   = "SSH_key"
  public_key = file("./ProjectCicdKey980412.pub")
}

# 보안그룹 - instance
resource "aws_security_group" "MySG" {
  name = "MySG"
  description = "Allow HTTP(80/tcp, 8080/tcp), ssh(22/tcp)"
  vpc_id = aws_vpc.MyVPC.id
  ingress {
    description = "Allow HTTP(80)"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPs(8080)"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow ssh(22)"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { 
    Name = "MySG"
  }
}
resource "aws_instance" "CICD_TEST_EC2_1" {
  ami = "ami-06d4b7182ac3480fa" # amazon linux2
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.MySG.id]
  
  subnet_id = aws_subnet.PublicSubnetA1.id
  
  tags = {
    Name = "CICD_TEST_EC2_1"
  }
}
