variable "vpc_id" {
  description = "VPC ID"
  type        = string
  
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}
variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}


variable "frontend_sg" {
  description = "Security group for frontend instances"
  type        = string
}
variable "backend_sg" {
  description = "Security group for backend instances"
  type        = string
}

variable "public_key" {
  description = "Key pair name for EC2 instances"
  type        = string
}



variable "db_password" {
  description = "Database password"
  type        = string
  
}

variable "db_address" {
  description = "Database address"
  type        = string
  
}

variable "db_user" {
  description = "Database user"
  type        = string
  default     = "admin"
  
}

variable "backend_lb_dns_name" {
  description = "Backend load balancer DNS name"
  type        = string
  
}