#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Get the IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Background the curl requests
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4 &> /tmp/local_ipv4 & 
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone &> /tmp/az & 
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ &> /tmp/macid & 
wait

macid=$(cat /tmp/macid)
local_ipv4=$(cat /tmp/local_ipv4)
az=$(cat /tmp/az)
vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$${macid}/vpc-id)

# Extract the last character of the AZ (suffix) to match the image filename
az_suffix=$${az: -1}



# Construct the image URL based on the AZ suffix
image_url="https://${bucket_name}.s3.amazonaws.com/$${az_suffix}.webp"

# Generate HTML content
cat <<EOF > /var/www/html/index.html
<!doctype html>
<html lang="en" class="h-100">
<head>
<title>Details for EC2 instance</title>
</head>
<body>
<div>
<h1>ASG, ALB, S3 hosted Image</h1> 

<br>
<img src="$${image_url}" alt="Uploaded Image">
<br>

<p><b>Instance Name:</b> $(hostname -f) </p>
<p><b>Instance Private Ip Address: </b> $${local_ipv4}</p>
<p><b>Availability Zone: </b> $${az}</p>
<p><b>Virtual Private Cloud (VPC):</b> $${vpc}</p>
</div>
</body>
</html>
EOF

# Clean up the temp files
rm -f /tmp/local_ipv4 /tmp/az /tmp/macid
