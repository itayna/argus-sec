output "s3_bucket_name" {
  value = aws_s3_bucket.argus_sec_bucket.id
}

output "ecr_repository_name" {
  value = aws_ecr_repository.argus_sec_ecr.name
}

output "ecr_repository_uri" {
  value = "161192472568.dkr.ecr.us-east-1.amazonaws.com/${aws_ecr_repository.argus_sec_ecr.name}"
}

output "ec2_instance_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "ec2_key_pair_name" {
  value = aws_instance.jenkins.key_name
}

output "ec2_instance_public_dns" {
  value = aws_instance.jenkins.public_dns
}