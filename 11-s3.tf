# # S3 Bucket Definition
# resource "aws_s3_bucket" "temp" {
#   bucket_prefix = "temp-storage-"
#   force_destroy = true

#   tags = {
#     Name = "temp-storage"
#   }
# }

# # Disable Block Public Access settings
# resource "aws_s3_bucket_public_access_block" "temp" {
#   bucket = aws_s3_bucket.temp.id

#   block_public_acls       = false
#   ignore_public_acls      = false
#   block_public_policy     = false
#   restrict_public_buckets = false
# }

# # Upload RPM files from the local directory to the S3 bucket
# resource "aws_s3_object" "images" {
#   for_each = fileset("${path.module}/images/", "*.webp")  

#   bucket = aws_s3_bucket.temp.id
#   key    = "${each.value}"  # Specify the prefix (folder) in the key
#   source = "${path.module}/images/${each.value}"
#   content_type = "image/webp"  # Set the content type
# }



# # Bucket Policy to allow public access to all objects in the bucket
# resource "aws_s3_bucket_policy" "temp_policy" {
#   bucket = aws_s3_bucket.temp.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = "*"
#         Action = "s3:GetObject"
#         Resource = "${aws_s3_bucket.temp.arn}/*"  # Allow access to all objects
#       }
#     ]
#   })
# }

# # # S3 VPC Endpoint for Private Access
# # resource "aws_vpc_endpoint" "s3_endpoint" {
# #   vpc_id           = aws_vpc.main.id
# #   service_name     = "com.amazonaws.${var.region}.s3"
# #   vpc_endpoint_type = "Gateway"

# #   # Associate with the route tables of the private subnet(s)
# #   route_table_ids = [
# #     aws_subnet.private-app-a.id,
# #     aws_subnet.private-app-b.id,
# #     aws_subnet.private-app-c.id
# #     ]

# #   tags = {
# #     Name = "S3-Endpoint"
# #   }
# # }
