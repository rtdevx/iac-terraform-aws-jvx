# INFO: IAM related variables

# INFO: S3 Artifact
variable "s3_artifact" {
  description = "S3 JVX Code artifact"
  type        = string
  default     = "rk-artifact"
}