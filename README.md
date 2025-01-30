# SKDB Deploy

## Overview
**SKDB Deploy** is a deployment repository for the **SKDB** application. This repository contains the necessary **Docker Compose** setup and deployment scripts to run the application on any Linux-based Docker environment.

## Features
- **Dockerized Setup**: Uses `docker-compose` to manage services.
- **Automated Updates**: Includes scripts to update both the **application code** and **deployment configuration**.
- **Environment Variable Support**: Uses an `.env` file for configuration.

---

## 🚀 Installation Instructions

### **1️⃣ Prerequisites**
Ensure you have the following installed:
- **Docker & Docker Compose**
- **Git**
- **SSH Access** to your server

### **2️⃣ Clone the Repository**
SSH into your server and navigate to your preferred directory:
```sh
cd /opt/docker
```
Clone the repository:
```sh
git clone https://github.com/angelxmoreno/skdb-deploy.git
cd skdb-deploy
```

### **3️⃣ Configure Environment Variables**
Copy the example environment file:
```sh
cp .env.example .env
```
Edit `.env` and update your settings:
```sh
nano .env
```
Save and exit (`CTRL+X`, then `Y`, then `Enter`).

### **4️⃣ Build & Start the Containers**
```sh
docker-compose build
```
```sh
docker-compose up -d
```
Verify running containers:
```sh
docker ps
```
Access the application in your browser:
```
http://<SERVER_IP>:8080
```

---

## 📜 Deployment Scripts

### **`update-app.sh` (Update SKDB Application Code)**
This script pulls the latest version of the **SKDB app**, installs dependencies, runs migrations, and restarts the application.

#### **Usage:**
```sh
./update-app.sh
```

#### **What It Does:**
- Pulls the latest app code from GitHub.
- Installs Composer dependencies.
- Runs database migrations & seeds.
- Restarts the PHP container.

### **`update-deploy.sh` (Update Deployment Configuration)**
This script pulls the latest version of the **deployment configuration**, rebuilds the containers, and restarts everything.

#### **Usage:**
```sh
./update-deploy.sh
```

#### **What It Does:**
- Pulls the latest deployment configuration from GitHub.
- Rebuilds & restarts Docker containers.
- Cleans up unused Docker images.

---

## 🔄 Automating Updates
To keep your application updated automatically, set up a **cron job**:
```sh
crontab -e
```
Add this line to update every night at 2 AM:
```sh
0 2 * * * cd /opt/docker/skdb-deploy && ./update-deploy.sh
```

---

## 🛠 Troubleshooting
### **Checking Logs**
If you encounter issues, check the logs for more details:
```sh
docker logs skdb_php  # Check application logs
```
```sh
docker logs skdb_db   # Check database logs
```
```sh
docker logs skdb_nginx  # Check web server logs
```

### **Permission Issues with Docker**
If you see `permission denied while trying to connect to the Docker daemon`:
```sh
sudo chmod 666 /var/run/docker.sock
```

### **502 Bad Gateway**
If you see a **502 error**, restart the Nginx container:
```sh
docker-compose restart nginx
```

---

## 🤝 Contributing
To contribute to this project, create a pull request on the **`skdb-deploy`** repository.

---

## 📄 License
This project is licensed under the **MIT License**.

---

🚀 **Now your SKDB app is fully deployed!** 🎉

