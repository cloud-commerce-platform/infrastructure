data "aws_kms_key" "containers" {
  key_id = "alias/KMS-containers-platform"
}
