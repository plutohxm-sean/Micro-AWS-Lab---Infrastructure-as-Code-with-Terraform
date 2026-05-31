output "api_url" {
  description = "API Gateway URL"
  value       = "https://${aws_api_gateway_rest_api.api.id}.execute-api.us-east-1.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}"
}

output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.web.public_ip
}

output "ec2_app_url" {
  description = "EC2 App URL"
  value       = "http://${aws_instance.web.public_ip}:3000"
}

output "ecr_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.app.repository_url
}

output "s3_bucket" {
  description = "S3 Bucket Name"
  value       = aws_s3_bucket.storage.bucket
}

output "lambda_function" {
  description = "Lambda Function Name"
  value       = aws_lambda_function.api.function_name
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web.id
}
root@plutohxm:/micro-aws-lab/infra# cat outputs.tf
output "api_url" {
  description = "API Gateway URL"
  value       = "https://${aws_api_gateway_rest_api.api.id}.execute-api.us-east-1.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}"
}

output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.web.public_ip
}

output "ec2_app_url" {
  description = "EC2 App URL"
  value       = "http://${aws_instance.web.public_ip}:3000"
}

output "ecr_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.app.repository_url
}

output "s3_bucket" {
  description = "S3 Bucket Name"
  value       = aws_s3_bucket.storage.bucket
}

output "lambda_function" {
  description = "Lambda Function Name"
  value       = aws_lambda_function.api.function_name
}

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web.id
