terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_s3_bucket" "terraform_state" {
  // !!! Use only to clean old backend !!! Necessary apply before destroy command
  // force_destroy = true

  bucket = var.BUCKET_NAME
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.TABLE_NAME
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
