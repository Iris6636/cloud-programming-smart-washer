variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "notification_email" {
  description = "Email address for SNS notifications (you must confirm subscription after deploy)"
  type        = string
}

variable "s3_bucket_images" {
  description = "S3 bucket name for storing washer time images (must be globally unique)"
  type        = string
  default     = "team06-times-image-temp"
}

variable "s3_bucket_website" {
  description = "S3 bucket name for static website hosting (must be globally unique)"
  type        = string
  default     = "team06website-temp"
}
