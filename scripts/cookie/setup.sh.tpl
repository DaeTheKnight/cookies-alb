#!/bin/bash

# Update system packages and install Python and needed dependencies 
yum update -y
yum install -y python3 python3-pip
sudo pip3 install flask requests

# Create a systemd service file for the Flask app
cat > /etc/systemd/system/flask_app.service <<EOF
${systemctl}
EOF

# Start and enable the Flask app service
sudo systemctl start flask_app
sudo systemctl enable flask_app

# Create Flask app directory
mkdir -p /home/ec2-user/flask_app

# Create the Flask app file with the provided content
cat << 'EOF' > /home/ec2-user/flask_app/app.py
${app_content}
EOF

# Run the Flask app in the background
sudo nohup python3 /home/ec2-user/flask_app/app.py &
