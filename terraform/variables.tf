variable "ec2_key_pair_name" {
  description = "Name of the EC2 key pair to use"
  type        = string
}

variable "ec2_root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 30
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}