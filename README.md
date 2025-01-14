# Nginx Server
This is an Nginx server project based on a Linux environment, demonstrating the deployment of a full-stack application on an Ubuntu server using Nginx as a reverse proxy.

I have created a bash script file that automates dependency installation, repository cloning, frontend and backend setup, Nginx configuration, and service restarts.<br>
You can easily setup your server with this script, just follow the setps below.

## Prerequisites

*   An Ubuntu based server with root or sudo privileges. This can be a virtual machine or a dedicated server either will work.
*   A GitHub repository containing your MERN frontend and backend code. Ensure your repository includes separate frontend and backend folders. Alternatively, you can use the demo frontend and backend code provided in this repository. 
*   A domain name (e.g., abc.com) or the server's IP address for testing purposes.

## Script Usage
Follow these steps to use the deployment script:

1.  **Dowload the script from this repo**
    ```bash
    script.sh
    ```
2.  **Make the script executable:**

    ```bash
    chmod +x script.sh
    ```

3.  **Configure the script (Important):**

    Open `script.sh` in a text editor and modify the following variables at the beginning of the script:

    *   `REPO_URL`: The URL of your application's GitHub repository (e.g., `https://github.com/yourusername/your-app.git`).
    *   `DOMAIN`: Your domain name (e.g., `example.com`). This is crucial for Nginx configuration.
    *   `APP_DIR`: The directory where your application will be deployed (defaults to `/var/www/myapp`). Adjust if needed.
    *   `BACKEND_PORT`: The port your backend server listens on (defaults to `3000`).
    *   `BACKEND_ENTRY_POINT`: The entry point for your backend application (e.g., `server.js`, `index.js`).
    *   `FRONTEND_BUILD_COMMAND`: The command to build your frontend (e.g. `npm run build`, `yarn build`).

4.  **Run the script:**

    ```bash
    sudo ./script.sh
    ```

## Manual Deployment

If you want to do everything manually use the following steps:

1.  **Update System and Install Dependencies:**

    ```bash
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y git nginx nodejs npm
    ```

2.  **Clone the Repository:**

    ```bash
    sudo git clone <repo_url> /path/app_name
    ```

3.  **Set Up the Backend:**

    ```bash
    cd /path/app_name/backend 
    sudo npm install
    sudo npm install -g pm2 
    pm2 start server.js --name backend
    ```

4.  **Build the Frontend:**

    ```bash
    cd /path/app_name/frontend 
    sudo npm install
    sudo npm run build
    ```

5.  **Create the Nginx Configuration File:**
    
    Nginx configurations for individual sites are typically stored in /etc/nginx/sites-available/. You'll create a new file here named after your domain (or a descriptive name).
    ```bash
    sudo nano /etc/nginx/sites-available/example.com  # Replace example.com with your domain
    ```
    This will open the nano text editor (you can use vim, emacs, or any other editor you prefer).

6. **Add the Nginx Configuration:**

    Paste the following configuration into the file. Crucially, replace the placeholder values with your actual values:
    ```nginx
        server {
        listen 80; # Listen on port 80 (standard HTTP port)
        server_name <domain_name>; # Replace with your domain name
    
        location / {
            root /path/app_name/frontend/build; # Replace with the actual path to your frontend build directory
            index index.html;
            try_files $uri $uri/ /index.html; # Handle client-side routing
        }
    
        location /api/ {
            proxy_pass http://localhost:3000; # Replace 3000 with your backend port
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host \$host;
            proxy_cache_bypass \$http_upgrade;
        }
    }
    ```

7.  **Enable Nginx Configuration and Restart Nginx:**

    ```bash
    sudo ln -sf /etc/nginx/sites-available/<domain_name> /etc/nginx/sites-enabled/
    sudo rm -f /etc/nginx/sites-enabled/default # Remove default config
    sudo nginx -t && sudo systemctl restart nginx
    ```

7.  **Add Domain to `/etc/hosts` (For Local Testing):**

    ```bash
    sudo bash -c "echo '127.0.0.1 <domain_name>' >> /etc/hosts"
    ```
8. **Open your browser and type the domain which will open the website over Ngnix**
    ```
    eg example.com # Whatever domain you created earlier
    ```


## Additionally i have provided another script "blockip.sh" for security

 This script will add security features to the server by:
    1. Blocking all traffic that tries to access the server through its ip address.
    2. Enable access to the server only through the domain you created.

**For this**
1. **Download the script from this repo**
    ```bash
    blockip.sh
    ```
2.  **Make the script executable:**

    ```bash
    chmod +x blockip.sh
    ```
3. **Run the script:**

    ```bash
    sudo ./blockip.sh
    ```
    This script will create a default server block in Nginx that captures all traffic accessing the server through the IP address or any domain other than the one you defined. It will deny access by returning a 403 Forbidden response

**Happy Hosting ;)**
