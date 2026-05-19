output "jvx_tls_keystore_arn" {
  description = "JVX TLS Keystore arn."
  value       = aws_secretsmanager_secret.jvx_tls_keystore.arn
}