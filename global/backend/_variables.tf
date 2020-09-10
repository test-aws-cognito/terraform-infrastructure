variable "BUCKET_NAME" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
}

variable "TABLE_NAME" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
}
