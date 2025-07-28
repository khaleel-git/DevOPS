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

### Now Create EKS Cluster
1. Authenticate to aws by using `aws configure`
2. create eks cluster by using below:
```shell
 # install eks
eksctl create cluster \
  --name go-web-app-cluster \
  --region eu-central-1 \
  --version 1.30 \
  --vpc-cidr 10.100.0.0/16 \
  --nodegroup-name public-nodes \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 3 \
  --node-private-networking=false \
  --zones eu-central-1a,eu-central-1b \
  --with-oidc \
  --managed

# delete eks
eksctl delete cluster --name go-web-app-cluster --region eu-central-1
```

#### Note!
Next time, use terraform for eks cluster
Video link: https://www.youtube.com/watch?v=_BTpd2oYafM&list=PLdpzxOOAlwvI0O4PeKVV1-yJoX2AqIWuf&index=10&ab_channel=Abhishek.Veeramalla
Related github repo: https://github.com/iam-veeramalla/terraform-eks


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
