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
5. Run command `docker build -t khaleelorg/go-web-app:v1 .`
