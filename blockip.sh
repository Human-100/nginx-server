#!/bin/bash

DEFAULT_BLOCK_CONF="/etc/nginx/sites-available/default_block"

sudo tee $DEFAULT_BLOCK_CONF > /dev/null <<EOL
server {
    listen 80 default_server;
    server_name _;

    return 403; # Deny access
}
EOL

sudo ln -sf $DEFAULT_BLOCK_CONF /etc/nginx/sites-enabled/

sudo nginx -t

sudo systemctl reload nginx