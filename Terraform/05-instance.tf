data "aws_ami" "ami_lookup" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

#EIP for master server
resource "aws_eip" "master-eip" {
  domain   = "vpc"
  instance = aws_instance.master-instance.id
}

#EIP for Slave server
resource "aws_eip" "slave-eip" {
  domain   = "vpc"
  instance = aws_instance.slave-instance.id
}

#Master instance
resource "aws_instance" "master-instance" {
  ami                    = data.aws_ami.ami_lookup.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.key_pair_jenkins.key_name
  subnet_id              = aws_subnet.j-subnet.id
  vpc_security_group_ids = [aws_security_group.j-security-group.id]
  user_data              = file("${path.module}/User-data-script/For-master/prerequisites-master.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = merge(local.aws_tags, {
    "Name" = "Jenkins-master"
  })

}

#Slave instance
resource "aws_instance" "slave-instance" {
  ami                    = data.aws_ami.ami_lookup.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.key_pair_jenkins.key_name
  subnet_id              = aws_subnet.j-subnet.id
  vpc_security_group_ids = [aws_security_group.j-security-group.id]
  user_data              = file("${path.module}/User-data-script/For-slave/prerequisites-slave.sh")

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = merge(local.aws_tags, {
    "Name" = "Jenkins-slave"
  })
}