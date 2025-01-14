#!/bin/bash

REPO_URL="https://github.com/Human-100/nginx-server.git"  # Replace with your GitHub repo URL
APP_DIR="/var/www/myapp"
DOMAIN="example.com" # Replace with your domain
FRONTEND_BUILD_DIR="$APP_DIR/frontend/build"
BACKEND_DIR="$APP_DIR/backend"
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"

echo "Updating system and installing required packages"
sudo apt update && sudo apt upgrade -y
sudo apt install -y git nginx nodejs npm


echo "Cloning the repository"
sudo rm -rf $APP_DIR
sudo git clone $REPO_URL $APP_DIR

echo "Setting up the backend..."
cd $BACKEND_DIR
sudo npm install cors
sudo npm install
sudo npm install -g pm2
pm2 start server.js --name backend

echo "Building the frontend..."
cd $APP_DIR/frontend
sudo npm install
sudo npm run build

echo "Configuring Nginx..."
sudo tee $NGINX_CONF > /dev/null <<EOL
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        root $FRONTEND_BUILD_DIR;
        index index.html;
        try_files \$uri /index.html;
    }

    location /api/ {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

echo "Enabling Nginx configuration..."
sudo ln -sf $NGINX_CONF /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-available/default

sudo rm -f /etc/nginx/sites-enabled/default

sudo nginx -t && sudo systemctl restart nginx

echo "Adding domain to /etc/hosts for local testing..."
sudo bash -c "echo '127.0.0.1 $DOMAIN' >> /etc/hosts"

echo "Web app setup is complete! Access it via http://$DOMAIN"

