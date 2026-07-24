# 🚀 Production Ready React Application Deployment using AWS DevOps CI/CD Pipeline

## 📌 Project Overview

This project demonstrates an end-to-end DevOps implementation for deploying a React application into a production-ready environment using AWS cloud services.

The application is containerized using Docker, container images are stored securely in Amazon Elastic Container Registry (ECR), deployed on Amazon Elastic Kubernetes Service (EKS), and automated using AWS CodePipeline and AWS CodeBuild.

Amazon CloudWatch is integrated for monitoring build execution, deployment activities, and application logs.

The goal of this project is to implement a scalable, automated, and reliable CI/CD deployment workflow.

---

# 🏗️ Architecture Overview


```
                    Developer
                        |
                        |
                        v

                 GitHub Repository
              Viki07-14/Brain-Tasks-App

                        |
                        |
                        v

                 AWS CodePipeline

                        |
                        |
                        v

                  AWS CodeBuild

                        |
                        |
        --------------------------------
        |                              |
        v                              v

 Docker Image Build              Build Logs

        |
        |
        v

              Amazon ECR Repository

                        |
                        |
                        v

              AWS EKS Kubernetes Cluster

                        |
                        |
                        v

          Kubernetes LoadBalancer Service

                        |
                        |
                        v

              React Application
```

---

# 🎯 Project Objectives

The main objectives of this project are:

- Deploy React application in AWS cloud environment
- Containerize application using Docker
- Store Docker images using Amazon ECR
- Automate build and deployment process
- Deploy application using Kubernetes on AWS EKS
- Implement CI/CD using AWS CodePipeline
- Monitor application and deployment logs using CloudWatch

---

# 🛠️ Technologies Used


| Category | Technology |
|---|---|
| Cloud Platform | AWS |
| Source Control | GitHub |
| Frontend Application | React JS |
| Containerization | Docker |
| Container Registry | Amazon ECR |
| Kubernetes Platform | AWS EKS |
| CI/CD Pipeline | AWS CodePipeline |
| Build Automation | AWS CodeBuild |
| Monitoring | Amazon CloudWatch |
| Operating System | Linux Ubuntu |


---

# 📂 Source Code Repository


GitHub Repository:

```
https://github.com/Viki07-14/Brain-Tasks-App.git
```

---

# 📁 Project Structure


```
Brain-Tasks-App

│
├── src/
│
├── dist/
│
├── Dockerfile
│
├── buildspec.yml
│
├── deployment.yaml
│
├── service.yaml
│
├── package.json
│
└── README.md

```

---

# 1. Application Setup


## Clone Repository


```bash
git clone https://github.com/Viki07-14/Brain-Tasks-App.git

cd Brain-Tasks-App
```

---

## Install Dependencies


```bash
npm install
```

---

## Create Production Build


```bash
npm run build
```


Production build files are generated inside:


```
dist/
```

---

## Run Application Locally


```bash
npm run dev
```


Application runs on:


```
http://localhost:3000
```

---

# 2. Docker Containerization


The React application is packaged into a Docker container.

The production build is served using Nginx for better performance and reliability.


---

# Dockerfile


```dockerfile
FROM public.ecr.aws/nginx/nginx:alpine


RUN rm -rf /usr/share/nginx/html/*


COPY dist/ /usr/share/nginx/html


EXPOSE 80


CMD ["nginx", "-g", "daemon off;"]

```

---

## Build Docker Image


```bash
docker build -t brain-task-app .
```

---

## Run Docker Container


```bash
docker run -p 80:80 brain-task-app
```


Application URL:


```
http://localhost
```

---

# 3. Amazon ECR Configuration


Amazon Elastic Container Registry is used as the Docker image repository.


## ECR Repository


```
brain-task-app
```


AWS Region:


```
ap-south-1
```


ECR URL:


```
213375652280.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app
```

---

## Authenticate Docker with ECR


```bash
aws ecr get-login-password \
--region ap-south-1 | \
docker login \
--username AWS \
--password-stdin \
213375652280.dkr.ecr.ap-south-1.amazonaws.com
```

---

## Tag Docker Image


```bash
docker tag brain-task-app:latest \
213375652280.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest
```

---

## Push Image to ECR


```bash
docker push \
213375652280.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest
```

---

# 4. AWS EKS Kubernetes Deployment


Amazon Elastic Kubernetes Service is used to manage and deploy containers.


## EKS Cluster Details


Cluster Name:

```
Mindtrack
```


Region:

```
ap-south-1
```

---

## Verify Kubernetes Cluster


```bash
kubectl get nodes
```


Example:


```
NAME              STATUS

worker-node-1     Ready

worker-node-2     Ready
```

---

# Kubernetes Deployment Configuration


File:

```
deployment.yaml
```


```yaml
apiVersion: apps/v1

kind: Deployment


metadata:

  name: brain-task-app


spec:

  replicas: 2


  selector:

    matchLabels:

      app: brain-task-app


  template:

    metadata:

      labels:

        app: brain-task-app


    spec:

      containers:

      - name: brain-task-app

        image: 213375652280.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest


        ports:

        - containerPort: 80

```

---

# Kubernetes Service Configuration


File:


```
service.yaml
```


```yaml
apiVersion: v1

kind: Service


metadata:

  name: brain-task-service


spec:

  type: LoadBalancer


  selector:

    app: brain-task-app


  ports:

  - port: 80

    targetPort: 80

```

---

# Deploy Application


Apply Kubernetes resources:


```bash
kubectl apply -f deployment.yaml

kubectl apply -f service.yaml
```


---

## Verify Deployment


Check Pods:


```bash
kubectl get pods
```


Check Service:


```bash
kubectl get svc
```

---

# 5. AWS CodeBuild Configuration


AWS CodeBuild automates the application build and deployment process.


CodeBuild performs:


- Authenticate with Amazon ECR
- Build Docker image
- Tag Docker image
- Push image to ECR
- Configure EKS access
- Deploy Kubernetes manifests


---

# buildspec.yml


```yaml
version: 0.2


phases:


  pre_build:

    commands:

      - echo "Logging into Amazon ECR"

      - aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 213375652280.dkr.ecr.ap-south-1.amazonaws.com



  build:

    commands:

      - echo "Building Docker image"

      - docker build -t brain-task-app:latest .

      - docker tag brain-task-app:latest 213375652280.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest

      - docker push 213375652280.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest



  post_build:

    commands:

      - echo "Deploying application to EKS"

      - aws eks update-kubeconfig --region ap-south-1 --name Mindtrack

      - kubectl apply -f deployment.yaml

      - kubectl apply -f service.yaml

```

---

# 6. AWS CodePipeline CI/CD Workflow


AWS CodePipeline automates the complete software delivery process.


## Pipeline Stages


### Source Stage

Provider:

```
GitHub
```


Repository:


```
Viki07-14/Brain-Tasks-App
```


Trigger:

```
Code Push
```


---

### Build Stage


Provider:


```
AWS CodeBuild
```


Tasks:


- Docker image creation
- ECR authentication
- Image push
- Kubernetes deployment


---

### Deployment Stage


Target:


```
AWS EKS Cluster
```


---

# CI/CD Workflow


```
Developer

   |

   v

GitHub Repository

   |

   v

AWS CodePipeline

   |

   v

AWS CodeBuild

   |

   v

Amazon ECR

   |

   v

AWS EKS

   |

   v

Application Available

```

---

# 7. Monitoring Using Amazon CloudWatch


Amazon CloudWatch is used for monitoring the complete application lifecycle.


## Monitoring Includes


### CodeBuild Logs

Tracks:

- Build execution
- Docker image creation
- ECR push status


### Deployment Logs

Tracks:

- Kubernetes deployment process
- Application rollout status


### Application Logs

Tracks:

- Container logs
- Application availability
- Kubernetes events


---

# Useful Kubernetes Commands


## Check Running Pods


```bash
kubectl get pods
```


## Check Services


```bash
kubectl get svc
```


## View Application Logs


```bash
kubectl logs <pod-name>
```


## Deployment Status


```bash
kubectl describe deployment brain-task-app
```

---

# 8. Application LoadBalancer Access


Get LoadBalancer details:


```bash
kubectl get svc brain-task-service
```


Example:


```
NAME                  TYPE

brain-task-service    LoadBalancer

```


Application URL:


```
http://<AWS-LOADBALANCER-DNS>
```

---

# 9. Version Control


Git commands used:


```bash
git init


git add .


git commit -m "AWS EKS deployment using CodePipeline"


git branch -M main


git remote add origin https://github.com/Viki07-14/Brain-Tasks-App.git


git push -u origin main
```

---

# ✅ Final Deployment Summary


| Component | Details |
|---|---|
| Application | Brain Tasks React Application |
| Source Code | GitHub |
| GitHub User | Viki07-14 |
| Container Platform | Docker |
| Image Registry | Amazon ECR |
| Kubernetes Platform | AWS EKS |
| EKS Cluster | Mindtrack |
| CI/CD Platform | AWS CodePipeline |
| Build Service | AWS CodeBuild |
| Monitoring | Amazon CloudWatch |
| Application Exposure | Kubernetes LoadBalancer |


---

# 🎯 Project Outcome


The React application has been successfully deployed using a complete AWS DevOps CI/CD workflow.


The implementation provides:


✅ Automated Docker image creation  
✅ Secure image storage using Amazon ECR  
✅ Automated build process using AWS CodeBuild  
✅ Continuous delivery using AWS CodePipeline  
✅ Kubernetes deployment using AWS EKS  
✅ LoadBalancer-based application access  
✅ Centralized monitoring using CloudWatch  


This project demonstrates a complete production-ready DevOps deployment architecture using AWS cloud services.
