# Security Group necesario para la creacion el Cluster EKS
resource "aws_security_group" "eks_cluster" {
  name   = "SG-eks-cluster"
  vpc_id = aws_vpc.prod_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}