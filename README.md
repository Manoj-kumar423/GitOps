# 🚀 GitOps with ArgoCD on Kubernetes

[![GitOps](https://img.shields.io/badge/GitOps-Enabled-brightgreen)](https://argoproj.github.io/argo-cd/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.25+-blue)](https://kubernetes.io/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

This repository demonstrates a complete GitOps workflow using **Argo CD** to deploy a sample **Python Flask** application on **Kubernetes (via Minikube)** running inside an **AWS EC2 Ubuntu instance**. The deployment is fully automated and synced through GitHub using ArgoCD.

---

## 📌 Table of Contents

- [📦 Tech Stack](#-tech-stack)
- [✨ Features](#-features)
- [🧩 Architecture](#-architecture)
- [🛠 Prerequisites](#-prerequisites)
- [⚙️ Setup Guide](#-setup-guide)
- [🖥 Usage](#-usage)
- [🔄 Testing GitOps](#-testing-gitops)
- [🐛 Troubleshooting](#-troubleshooting)
- [🤝 Contributing](#-contributing)
- [📜 License](#-license)

---

## 📦 Tech Stack

- Python (Flask)
- Docker
- Kubernetes (Minikube)
- ArgoCD
- GitHub
- AWS EC2 (Ubuntu 22.04)

---

## ✨ Features

- **GitOps-enabled**: Git as the single source of truth.
- **Auto-sync deployments** from GitHub to Kubernetes.
- **Declarative Kubernetes configurations**.
- **Argo CD UI** for monitoring and visual control.
- **Self-healing** & rollback support.

---

## 🧩 Architecture

```mermaid
graph TD
    A[GitHub Repository] -->|Manifests + Dockerfile| B[ArgoCD]
    B -->|Deploys to| C[Kubernetes Cluster (Minikube)]
    C -->|App Status| B
    B -->|UI Access| D[ArgoCD Dashboard]
```

---

## 🛠 Prerequisites

- AWS account and EC2 access.
- Ubuntu EC2 instance (t2.medium or higher recommended).
- Open ports:
  - **22** (SSH)
  - **8080** (ArgoCD via port-forward)
  - **30000–32767** (NodePort access for your app)

---

## ⚙️ Setup Guide

### 1. Launch EC2 Instance

- Ubuntu 22.04 LTS
- t2.medium
- Add inbound rules for ports 22, 8080, 30000–32767

### 2. Connect & Install Dependencies

```bash
ssh -i "your-key.pem" ubuntu@<EC2_PUBLIC_IP>
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io git curl
```

### 3. Clone the Repo

```bash
git clone https://github.com/your-username/gitops-argocd-app.git
cd gitops-argocd-app
```

### 4. Build Docker Image and Push to DockerHub

```bash
docker build -t yourdockerhubusername/flask-app:latest .
docker login
docker push yourdockerhubusername/flask-app:latest
```

### 5. Install Minikube & kubectl

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --driver=docker

curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

### 6. Create DockerHub Secret in Kubernetes

```bash
kubectl create secret docker-registry regcred \
  --docker-username=yourdockerhubusername \
  --docker-password=yourpassword \
  --docker-email=youremail@example.com
```

### 7. Edit Deployment YAML

Update the following in `deployment.yaml`:
- Image: `yourdockerhubusername/flask-app:latest`
- Add imagePullSecrets:
```yaml
imagePullSecrets:
  - name: regcred
```

---

## 🖥 Usage

### 1. Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 2. Port-forward ArgoCD UI (8080)

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### 3. Get ArgoCD Admin Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

Login at: `http://<EC2_PUBLIC_IP>:8080`

---

## 🔄 Testing GitOps

1. Modify something in `deployment.yaml` (e.g., image tag)
2. Commit and push the change to GitHub

```bash
git add .
git commit -m "Updated app version"
git push origin main
```

ArgoCD will automatically sync the changes into your Kubernetes cluster.

---

## 🐛 Troubleshooting

### ArgoCD pods not starting
```bash
kubectl get pods -n argocd
kubectl describe pod <pod-name> -n argocd
kubectl logs <pod-name> -n argocd
```

### ArgoCD UI not loading
```bash
kubectl get svc -n argocd
```

Ensure `argocd-server` has an external IP or port-forward is active.

---

## 🤝 Contributing

Contributions are welcome!  
To contribute:

1. Fork the repo  
2. Create your feature branch (`git checkout -b feature/your-feature`)  
3. Commit your changes  
4. Push to your branch (`git push origin feature/your-feature`)  
5. Open a Pull Request

---

## 📜 License

Distributed under the MIT License.  
See [`LICENSE`](LICENSE) for more information.

---

## 🙌 Acknowledgments

Thanks to open-source authors and tutorials that helped shape this workflow.

