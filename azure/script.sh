#!/bin/bash
echo "Updating the System"
sudo apt update -y

echo "Installing Utilities"
sudo apt install zip unzip -y 

echo "Installing NGINX Web Server"
sudo apt install nginx -y

echo "Cleanup Document Root"
sudo rm -rf /var/www/html

echo "Clone Ecommerce App"
sudo git clone https://github.com/ravi2krishna/ecomm.git /var/www/html

echo "Finished Deployment Process"