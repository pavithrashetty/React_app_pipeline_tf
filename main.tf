terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "http" {
  }
}

provider "aws" {
  region = "us-east-2"
}

#module to get multiple files to S3
module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/build"
}

## Create an S3 bucket
resource "aws_s3_bucket" "s3_creation" {
  bucket = var.bucket_name
  tags = {
    Name = "Pavi bucket from tf"
  }
}
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket     = var.bucket_name
  depends_on = [aws_s3_bucket.s3_creation]
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

## Create an S3 Object referencing the file at "./build/libs/g-hello-0.0.1-SNAPSHOT.jar"
resource "aws_s3_object" "react_static_files" {
  for_each     = module.template_files.files
  bucket       = var.bucket_name
  key          = each.key
  content_type = each.value.content_type

  source      = each.value.source_path
  depends_on  = [aws_s3_bucket.s3_creation]
  source_hash = filemd5(each.value.source_path) #if we need versioning
}

resource "aws_s3_bucket_website_configuration" "bucket_config" {
  bucket = var.bucket_name

  index_document {
    suffix = "index.html"
  }

}

resource "aws_s3_bucket_public_access_block" "bucket_access_block" {
  bucket = var.bucket_name

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.s3_creation.arn}/*"
        ]
      }
    ]
  })
}