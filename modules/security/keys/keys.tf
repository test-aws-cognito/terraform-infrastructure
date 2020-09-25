resource "aws_key_pair" "pr_01_key" {
  public_key = file("${path.module}/resources/pr-01-key.pub")
  key_name   = var.KEY_NAME
}
