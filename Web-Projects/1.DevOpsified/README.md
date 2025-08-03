## Project 1: DevOpsified | Complete DevOps Implementation in one project
### Link: https://www.youtube.com/watch?v=HGu9sgoHaJ0&ab_channel=Abhishek.Veeramalla

## Agenda
1. Containeraiztion (Dockerfile)
2. Kubernetes (deploy, svc, ingress)
3. CI (Github Actions)
4. CD (Gitops ArgoCD)
5. Kubernetes Cluster (EKS)
6. Helm Chart
7. Ingress Controller Configuration (Load Balancer) - App exposed to the internet
8. Map DNS (Available for users)

## Two Repositories are used
1. https://github.com/iam-veeramalla/go-web-app
2. https://github.com/iam-veeramalla/ultimate-devops-project-aws 

## 1st repo
1. clone to local machine
2. build it by running `go build -o main .`
3. run the binary `./main' & access `http://localhost:8080/courses`
4. write a Dockerfile
    - Mulitstage: base image
    - stage 2: distroless image
    - expose the port & run the application
```yaml
# Dockerfile
From golang:1.21 as base 

WORKDIR /app

COPY go.mod . # dependencies are stored in the go.mod file

RUN go mod download # install dependencies

COPY . .

RUN go build -o main . # binary main will be created in the docker image

# Final stage - Distroless image

FROM gcr.io/distroless/base

COPY --from=base /app/main .

COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["./main"]
```
5. Run command `docker build -t khaleelorg/go-web-app:v1 .` & Run/Test locally: `docker run -p 8080:8080 -it khaleelorg/go-web-app:v1`
6. Push it to docker `docker push khaleelorg/go-web-app:v1` 
7. Create a folder called k8s for Kubernetes manifest files `mkdir -p k8s/manifests`
8. Create a deployment.yaml file under `/k8s/manifests/deployment.yaml` as below:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: go-web-app
  labels:
    app: go-web-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: go-web-app
  template:
    metadata:
      labels:
        app: go-web-app
    spec:
      containers:
      - name: go-web-app
        image: khaleelorg/go-web-app
        ports:
        - containerPort: 8080
```
9. Create a Service under `/k8s/manifests/service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: go-web-app
  labels:
    app: go-web-app
spec:
  selector:
    app: go-web-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```
10. Create ingress.yaml file under `/k8s/manifests/ingress.yaml`
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: go-web-app
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: go-web-app.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: go-web-app
            port:
              number: 80
```

## 🚀 Now Create EKS Cluster

### 1. Authenticate to AWS
Make sure your AWS CLI is configured:

```bash
aws configure
````

---

### 2. Create EKS Cluster Using `eksctl`

```bash
# Create EKS cluster (managed nodes, public)
eksctl create cluster \
  --name go-web-app-cluster \
  --region us-east-1 \
  --version 1.30 \
  --vpc-cidr 10.100.0.0/16 \
  --nodegroup-name public-nodes \
  --node-type t3.small \
  --nodes 1 \
  --nodes-min 1 \
  --nodes-max 2 \
  --node-private-networking=false \
  --zones us-east-1a \
  --with-oidc \
  --managed
```

---

### 3. Delete EKS Cluster Using `eksctl`

```bash
eksctl delete cluster --name go-web-app-cluster --region us-east-1
```

---

### 🧱 Alternatively: Use Terraform (Preferred for IaC)

Instead of `eksctl`, you can use **Terraform** to create the same EKS cluster.

> 📁 Folder structure:

```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
```

---

### ✅ How to Create EKS with Terraform

```bash
# Step 1: Navigate into Terraform project
cd terraform/

# Step 2: Initialize Terraform
terraform init

# Step 3: Preview the changes
terraform plan

# Step 4: Apply and create the cluster
terraform apply
```
---

### 🧼 How to Delete the Cluster with Terraform

```bash
terraform destroy
```

---

### 🌐 What This Will Create

* EKS cluster named `go-web-app-cluster` in `us-east-1`
* Kubernetes version `1.30`
* Public worker nodes (`t3.small`)
* VPC with CIDR `10.100.0.0/16`
* IAM Roles and OIDC enabled
---

11. Update kubeconfig to view aws eks cluster locally
`aws eks --region us-east-1 update-kubeconfig --name go-web-app-cluster` OR
`aws eks --region us-east-1 update-kubeconfig --name go-web-app-cluster --kubeconfig ~/.kube/config`

12. Check relevant Security group & Open nodeports if you want:
```shell
aws ec2 describe-instances --filters "Name=private-dns-name,Values=ip-10-100-2-205.ec2.internal" \
  --query "Reservations[*].Instances[*].SecurityGroups[*].GroupId" --region us-east-1

# Now open Node Ports

aws ec2 authorize-security-group-ingress \
  --group-id sg-07d3aad0f272ba811 \
  --protocol tcp \
  --port 30000-32767 \
  --cidr 0.0.0.0/0 \
  --region us-east-1
  ```

12. Now Implement Ingress Controller
```shell
# Github Community Ingress Controller: https://github.com/kubernetes/ingress-nginx
# Documentation link: https://kubernetes.github.io/ingress-nginx/deploy/#aws
# Chsose aws ingress controller
# Note: This nginx ingress controller creates a network Load Balancer
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/aws/deploy.yaml4 # command

# How it works?
Ingress ---> Ingress Controller ---> Load Balancer
Ingress controller watches ingress & creates a Load Blancer
It is not practically possible to create LB everytime, that's why we need an nginx ingress controller & ingress
Ingress controller is written by communities & private companies such as AWS etc. 
It will watch with ingress-class=nginx just like pods service discovery like labels and selectors.
```

13. Access Load blancer which ingress-controller just created.
14. Helm
```shell
# first install helm 
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Create helm chart
 helm create go-web-app-chart
 ls
 Chart.yaml  charts  templates  values.yaml # it will create these files

# Chart.yaml is a metadata
# Go to template folder and remove everything: 
`rm -rf *`
# Copy everyting from k8s/manifests to template directory
` sudo cp ../../../k8s/manifests/* .`

# Edit deployment.yaml file and change image tag to jinja2 template
`image: khaleelorg/go-web-app:{{ .Values.image.tag }}` # replace V1 tag

# install helm chart
helm install go-web-app ./go-web-app-chart

# uninstall helm if you want
helm uninstall go-web-app
```

## CI/Cd
- CI via Github Action
- CD via GitOps (ArgoCD)

### Process
1. Build and Unit test
2. Static Code Analysis
3. Create & Push Docker images
4. Update Helm - CI via Github Action
5. ArgoCD will install the helm chart on a kubernetes cluster




























#### Note!

conductor llc, cities, visas, engineering org, devops, modern hybrid, bare metal, challenges, obserable, plantform automation, ci/cd,  
terraform, ansible, container,
aws kubernetes, ci/cd, 

hr interview
technnical interview
platform engineering
aws eks 2.5 (prepartion plus)
team: 25 team members

eks, elk stacked

85k - 
