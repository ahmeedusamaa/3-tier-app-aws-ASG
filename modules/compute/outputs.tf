output "frontend_lb_target_group_arn" {
    value = aws_lb_target_group.frontend_tg.arn
}

output "backend_lb_target_group_arn" {
    value = aws_lb_target_group.backend_tg.arn
}