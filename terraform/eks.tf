resource "aws_security_group" "eks" {
  name        = "${data.terraform_remote_state.infra.outputs.resource_prefix}-security-group-eks"
  description = "inbound: HTTP + outbound: none"
  vpc_id      = data.terraform_remote_state.infra.outputs.aws_vpc_id

  ingress {
    description = "VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${data.terraform_remote_state.infra.outputs.resource_prefix}-security-group-eks"
  }
}

data "aws_iam_policy_document" "assume_role_cluster" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "eks_cluster" {
  name               = "${data.terraform_remote_state.infra.outputs.resource_prefix}-k8s-cluster"
  assume_role_policy = data.aws_iam_policy_document.assume_role_cluster.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "default" {
  name     = "${data.terraform_remote_state.infra.outputs.resource_prefix}-k8s-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    security_group_ids = [
      aws_security_group.eks.id
    ]
    subnet_ids = [
      data.terraform_remote_state.infra.outputs.subnet_private_a_id,
      data.terraform_remote_state.infra.outputs.subnet_private_b_id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.eks_cluster-AmazonEKSServicePolicy,
  ]

  tags = {
    Name = "${data.terraform_remote_state.infra.outputs.resource_prefix}-k8s-cluster"
  }
}

output "aws_eks_cluster_endpoint" {
  value = aws_eks_cluster.default.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.default.certificate_authority[0].data
}
