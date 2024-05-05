data "aws_iam_policy_document" "assume_role_node" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "eks_node" {
  name               = "${data.terraform_remote_state.infra.outputs.resource_prefix}-eks-node"
  assume_role_policy = data.aws_iam_policy_document.assume_role_node.json
}

resource "aws_iam_role_policy_attachment" "eks_node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node.name
}

resource "aws_eks_node_group" "api" {
  cluster_name    = "${data.terraform_remote_state.infra.outputs.resource_prefix}-k8s-cluster"
  node_group_name = "${data.terraform_remote_state.infra.outputs.resource_prefix}-k8s-node-group-api"
  node_role_arn   = aws_iam_role.eks_node.arn
  instance_types  = [var.work_node_api_instance_type]

  subnet_ids = [
    data.terraform_remote_state.infra.outputs.subnet_private_a_id,
    data.terraform_remote_state.infra.outputs.subnet_private_b_id
  ]

  scaling_config {
    desired_size = var.work_node_api_desired_size
    min_size     = var.work_node_api_min_size
    max_size     = var.work_node_api_max_size
  }

  depends_on = [
    aws_eks_cluster.default,
    aws_iam_role_policy_attachment.eks_node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node-AmazonEC2ContainerRegistryReadOnly
  ]

  tags = {
    Name = "${data.terraform_remote_state.infra.outputs.resource_prefix}-eks-node-group-api"
  }
}
