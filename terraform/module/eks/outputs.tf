output "dns" {
  value = aws_db_instance.postgres.address
  sensitive = true
}