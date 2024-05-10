# ${data.terraform_remote_state.infra.outputs.resource_prefix}-security-group-eks

resource "aws_apigatewayv2_api" "main" {
  name =  "main"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_stage" "main" {
  api_id = aws_apigatewayv2_api.main.id
  name = "dev" 
  auto_deploy = true
}

# # data.terraform_remote_state.infra.outputs.aws_vpc_id

# # resource "aws_security_group" "vpc_link" {
  
# # }

# resource "aws_apigatewayv2_vpc_link" "eks" {
#     name = "eks"
#     security_group_ids = [ aws_security_group.eks.id ]
#     subnet_ids = [data.terraform_remote_state.infra.outputs.subnet_private_a_id,
#                     data.terraform_remote_state.infra.outputs.subnet_private_b_id]

# }

resource "aws_apigatewayv2_integration" "eks" {
    api_id = aws_apigatewayv2_api.main.id

    # integration_uri = "arn:aws:ec2:us-east-1:113240167813:natgateway/nat-0281ba633d686b364"
    integration_uri = "http://${aws_eks_cluster.default.endpoint}/{proxy}"
    integration_method = "ANY"
    integration_type = "HTTP_PROXY"
    connection_type = "INTERNET"
    # connection_type = "VPC_LINK"
    # connection_id = aws_apigatewayv2_vpc_link.eks.id
}

resource "aws_apigatewayv2_route" "proxy_route" {
    api_id = aws_apigatewayv2_api.main.id
    
    route_key = "ANY /{proxy+}"
    target = "integrations/${aws_apigatewayv2_integration.eks.id}"
}

output "url_apigateway" {
  value = "${aws_eks_cluster.default.endpoint}"
}
