resource "aws_kms_key" "flask_app_s3_kms_key" {
  description             = "KMS key for encrypting CodePipeline artifacts in S3"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "flask_app_s3_kms_key_alias" {
  name          = "alias/flask_app_s3kmskey"
  target_key_id = aws_kms_key.flask_app_s3_kms_key.key_id
}