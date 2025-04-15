#Create a security group for EKS cluster, since it is messing up with the VPC's SG
resource "aws_security_group" "sg-for-eks" {
  name = "${local.eks_name}-sg"
  description = "SG created for EKS"
  vpc_id = aws_vpc.main-vpc.id
  tags   = local.aws_tags
}

#Define ingress for the EKS SG
resource "aws_vpc_security_group_ingress_rule" "ingress-for-sg-eks" {
  security_group_id = aws_security_group.sg-for-eks.id
  #Reference j-security-group sg as a source 
  referenced_security_group_id = aws_security_group.j-security-group.id
  ip_protocol = -1
  tags = local.aws_tags
}

#Define egress for the EKS SG
resource "aws_vpc_security_group_egress_rule" "egress-for-sg-eks" {
  security_group_id = aws_security_group.sg-for-eks.id
  #Reference j-security-group sg as a source 
  referenced_security_group_id = aws_security_group.j-security-group.id
  ip_protocol = -1
  tags = local.aws_tags
}

#Open Kubernetes port 30000 - 32767
resource "aws_vpc_security_group_ingress_rule" "ingress-for-sg-eks-node-ports" {
  security_group_id = aws_security_group.sg-for-eks.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 30000
  to_port           = 32767
  ip_protocol       = "tcp"
}

#Create the role for the EKS cluster
resource "aws_iam_role" "eks-cluster" {
  #Not using variable as this 
  name = local.cluster_role_name

  # This IAM policy is required so that the EKS can take IAM roles, this is a trust policy
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "eks.amazonaws.com"
            }
        }
    ]
}
POLICY
}

#Attach the permission policy to the role
resource "aws_iam_role_policy_attachment" "cluster-policy" {
  #policy given here is a managed policy provided by aws, which defines the permissions for the AWS EKS cluster, we bind it with the above created role
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_eks_cluster" "eks" {
  name     = "wanderlust"
  role_arn = aws_iam_role.eks-cluster.arn
  version  = local.eks_version

  vpc_config {
    security_group_ids = [aws_security_group.sg-for-eks.id]
    subnet_ids         = [aws_subnet.j-subnet.id, aws_subnet.j-subnet2.id]
    #We are disabling private access to the EKS cluster using Private endpoint, worker notes can't connect to the control plane (if cluster is hosted in private subnet) unless NAT gateway / Internet gateway is setup
    endpoint_private_access = false
    endpoint_public_access  = true
  }

  access_config {
    #Settting the authentication mode to API and Config map 
    authentication_mode = "API_AND_CONFIG_MAP"
    #Cluster creator will get admin permissions
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [aws_iam_role_policy_attachment.cluster-policy]
  tags = local.aws_tags
}