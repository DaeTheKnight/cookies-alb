#!/bin/bash

# Update system packages and install Python3 and pip 
yum update -y  
yum install -y python3 python3-pip  

# Install Flask and requests libraries for the web application
sudo pip3 install flask requests 


# Create the directory for the Flask application files
mkdir -p /home/ec2-user/flask_app  

# Create the main Flask app file with the provided application code
cat << 'EOF' > /home/ec2-user/flask_app/app.py
from flask import Flask, make_response, render_template_string, request
import random  
import requests  

# Initialize a new Flask application
app = Flask(__name__)

# URL of a "safe" image that always displays on the first visit
safe_image = "https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/71b3fa9f-8e3d-40a8-9cbf-944b67456c7a/width=450/workspace_images_602915968439572669_e7d9dcaa093bec1629692861fd9f4e57.jpeg"

# Additional images to display randomly on subsequent visits
images = [
    "https://upload.wikimedia.org/wikipedia/commons/2/2f/Glasto2023_%28181_of_468%29_%2853009327490%29_%28cropped%29.jpg",
    "https://c8.alamy.com/comp/2NGKBH1/oslo-norway-17th-feb-2023-the-american-rapper-and-singer-lizzo-performs-a-live-concert-at-oslo-spektrum-in-oslo-photo-credit-gonzales-photoalamy-live-news-2NGKBH1.jpg",
    "https://theshaderoom.com/wp-content/uploads/2022/08/Lizzo-scaled-e1660693366244.jpg",
    "https://c8.alamy.com/comp/2ET5BAM/lizzo-performs-live-on-the-west-holts-stage-on-day-4-of-glastonbury-2019-worthy-farm-pilton-somerset-picture-date-saturday-29th-june-2019-photo-credit-should-read-david-jensen-2ET5BAM.jpg"
]

@app.route('/')
def index():
    # Generate a token to securely access EC2 instance metadata
    token = requests.put("http://169.254.169.254/latest/api/token", headers={"X-aws-ec2-metadata-token-ttl-seconds": "21600"}).text

    # Fetch metadata for the instance's local IP, availability zone, MAC address, and VPC ID
    local_ipv4 = requests.get("http://169.254.169.254/latest/meta-data/local-ipv4", headers={"X-aws-ec2-metadata-token": token}).text
    az = requests.get("http://169.254.169.254/latest/meta-data/placement/availability-zone", headers={"X-aws-ec2-metadata-token": token}).text
    macid = requests.get("http://169.254.169.254/latest/meta-data/network/interfaces/macs/", headers={"X-aws-ec2-metadata-token": token}).text.strip()
    vpc = requests.get(f"http://169.254.169.254/latest/meta-data/network/interfaces/macs/{macid}/vpc-id", headers={"X-aws-ec2-metadata-token": token}).text
    hostname = requests.get("http://169.254.169.254/latest/meta-data/hostname", headers={"X-aws-ec2-metadata-token": token}).text

    # Determine which image to display based on the user's visit history
    if request.cookies.get("visited"):
        # Select a random image from the list (excluding the safe image) for returning visitors
        img_url = random.choice(images[1:])
    else:
        # Show the safe image for first-time visitors
        img_url = safe_image

    # Render an HTML response with instance metadata and the chosen image
    resp = make_response(render_template_string(f"""
    <!doctype html>
    <html lang="en" class="h-100">
    <head>
    <title>Details for EC2 instance</title>
    </head>
    <body>
    <div>
    <h1>AWS Instance Details</h1>
    <h1>Samurai Katana</h1>

    <br>
    <img src="{img_url}" alt="Random Image" style="width: 100%; height: auto;">
    <br>

    <p><b>Instance Name:</b> {hostname}</p>
    <p><b>Instance Private Ip Address: </b> {local_ipv4}</p>
    <p><b>Availability Zone: </b> {az}</p>
    <p><b>Virtual Private Cloud (VPC):</b> {vpc}</p>
    </div>
    </body>
    </html>
    """))

    # Set a "visited" cookie to recognize returning visitors, lasting one year
    if not request.cookies.get("visited"):
        resp.set_cookie("visited", "1", max_age=60*60*24*365)

    return resp

if __name__ == "__main__":
    # Run the Flask app on all available network interfaces, listening on port 80
    app.run(host="0.0.0.0", port=80)

EOF

# Run the Flask application in the background, allowing the server to keep running independently
# of the user session. 'nohup' prevents the process from stopping if the session ends,
# and '&' places it in the background so other commands can run concurrently.
sudo nohup python3 /home/ec2-user/flask_app/app.py &
