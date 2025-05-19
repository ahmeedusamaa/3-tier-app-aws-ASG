output "public_key" {
  value = aws_key_pair.generated_key.id
  description = "The public key for SSH access to the instances"
  
}