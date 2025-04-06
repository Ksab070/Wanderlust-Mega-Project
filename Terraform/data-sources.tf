data "aws_eks_cluster" "eks_cluster" {
  name       = aws_eks_cluster.eks.name
  depends_on = [aws_eks_cluster.eks]
}

data "aws_eks_cluster_auth" "eks_auth" {
  name       = aws_eks_cluster.eks.name
  depends_on = [aws_eks_cluster.eks]
}