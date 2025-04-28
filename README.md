# Continuous Development and Deployment (CDD) Project

## **Project Overview**
This project demonstrates a full **Continuous Development and Deployment (CDD)** pipeline using:
- **Git** for source code management
- **Jenkins** for automation (build, test, push)
- **Docker** for containerization
- **DockerHub** for storing Docker images
- **Render** for application deployment

---

## **Tools and Technologies**
- **Git**
- **Jenkins**
- **Docker**
- **DockerHub**
- **Render**

---

## **Workflow Summary**
1. **Developer** pushes code to **GitHub** (SCM).
2. **Jenkins** pulls the latest code from GitHub.
3. **Jenkins** builds a **Docker image**.
4. **Jenkins** (optional) tests the Docker container.
5. **Jenkins** pushes the Docker image to **DockerHub**.
6. **Render** pulls the Docker image from **DockerHub** and deploys the application.

---

## **Step-by-Step Process**

### **1. Git - Source Code Management**
- Initialized a **Git** repository and pushed the project code to **GitHub**.
- Connected **GitHub repository** to **Jenkins** using Git plugin/Webhook.

---

### **2. Jenkins - Build, Test, Push**
- Installed required **Jenkins plugins**:
  - **Git Plugin**
  - **Docker Plugin**

- Created a **Jenkins Freestyle Project** or a **Jenkins Pipeline**.

- Configured Jenkins to:
  - **Pull the latest code** from GitHub.
  - **Build a Docker image** using a `Dockerfile`.
  - **Test the Docker container** (optional health check).
  - **Push the built Docker image** to **DockerHub**.

#### **Jenkins Pipeline Stages**
- **Checkout Stage**: Pull code from GitHub.
- **Build Stage**: Build Docker image.
- **Test Stage**: (Optional) Run container health check.
- **Push Stage**: Push Docker image to DockerHub.


## **3. Docker and DockerHub**
- **Created a Dockerfile** to containerize the application.
- **Built the Docker image** locally and during Jenkins builds.
- **Created a DockerHub repository**.
- **Used DockerHub login credentials** in Jenkins to push images.

---

## **4. Render Deployment**
- **Signed up** / **Logged in** to [Render](https://render.com/).
- Clicked on **New Web Service**.
- Selected the **"Deploy an existing Docker image"** option.
- Entered the **Docker image URL** from **DockerHub** (e.g., `docker.io/your-dockerhub-username/your-image-name:tag`).
- Configured the service settings:
  - **Environment**: Docker
  - **Instance Type**: Free/Standard (as needed)
  - **Start Command** (optional): If your Docker container needs a custom command.
- Clicked **Create Web Service**.
- **Render** automatically pulled the Docker image from **DockerHub** and started the deployment.
- On every new push to DockerHub, **Render** can be manually refreshed or auto-updated to fetch the new image.

---

## **Final Architecture**

flowchart TD
    Developer --> GitHub
    GitHub --> Jenkins
    Jenkins --> Docker Build
    Docker Build --> DockerHub
    DockerHub --> Render
    Render --> Live Application



---

# Conclusion
By combining Git, Jenkins, Docker, DockerHub, and Render, a complete automated Continuous Development and Deployment (CDD) pipeline is achieved successfully.
