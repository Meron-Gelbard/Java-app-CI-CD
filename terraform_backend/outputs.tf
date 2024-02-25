output "s3_backend_bucket" {
    value = aws_s3_bucket.tf-remote-backend.bucket
}

output "dynamodb_lock_table" {
    value = aws_dynamodb_table.backend_lock.name
}