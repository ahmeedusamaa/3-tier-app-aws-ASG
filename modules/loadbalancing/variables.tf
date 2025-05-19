
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

variable "frontend_alb_sg" {
  description = "Security group for frontend ALB"
  type        = string
}
variable "backend_alb_sg" {
  description = "Security group for backend ALB"
  type        = string
}


variable "frontend_lb_target_group_arn" {
  description = "ARN of the frontend load balancer target group"
  type        = string
  
}
variable "backend_lb_target_group_arn" {
  description = "ARN of the backend load balancer target group"
  type        = string
  
}