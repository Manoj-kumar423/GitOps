!/bin/bash
#install minikube
sudo apt update && sudo apt upgrade -y

sudo apt install -y curl wget apt-transport-https ca-certificates software-properties-common

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
#minikube -version

#install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#kubectl version --client

#Set Up a minikube Kubernetes Cluster
#Start minikube: Use Docker as the driver (default for minikube on EC2):
minikube start --driver=docker
#kubectl get nodes
#kubectl cluster-info
#kubectl create namespace argocd
#kubectl get namespaces
#kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
#kubectl port-forward svc/argocd-server -n argocd 8080:443
#kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
#Deploy Argo CD Application
#kubectl apply -f k8s/argocd-app.yaml -n argocd

