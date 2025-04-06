#Create random private key for jenkins
resource "tls_private_key" "key_for_jenkins" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

#Save private key locally
resource "local_file" "ssh_key_local" {
  filename        = "${path.module}/for_ssh.pem"
  content         = tls_private_key.key_for_jenkins.private_key_openssh
  file_permission = "0400"
}

resource "local_file" "jenkins_key_local" {
  filename        = "${path.module}/for_jenkins.pem"
  content         = tls_private_key.key_for_jenkins.private_key_pem
  file_permission = "0400"
}


#Send the public key to AWS
resource "aws_key_pair" "key_pair_jenkins" {
  key_name   = "jenkins_key_pair"
  public_key = tls_private_key.key_for_jenkins.public_key_openssh
  tags       = local.aws_tags
}

