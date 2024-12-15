## Project link
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/DEV-AWS-MO-ContainersRedux/downloads/containers-src.zip
unzip containers-src.zip -d aws_containerized_coursera


```Dockerfile
FROM node:gallium-alpine3.14
WORKDIR /app

COPY app .
RUN npm install

CMD node server.js
EXPOSE 8080
```
```shell
docker exec -it 52 sh
docker run -v ~input.txt:/app/input.txt -p 80:8080 first-container
```

Pushed the image to ECR (private)
Used AWS APP Runner to launche the ecr image into service (application)


## ECR (Elastic Container Registry)
AWS App Runner can run repos from ECR
AWS Inspector can scan vulnerabilities and notifies by AWS EventBridge

## Week # 2
Monolithic application
single artifact

### Microservice
```shell
docker-compose build
docker-compose up -d
```

#### install docker compose
```
uname -s # linux os
uname -m # architecture i.e x86_64

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## ECS 
Comparing the control plane and the data plane

1. TASK
2. Schedular
3. Service
4. Container Agent

### Task
```
The Docker image to use with each container in your task.

How much CPU and memory to use with each task or each container within a task.

The launch type to use, which determines the infrastructure where your tasks are hosted.

The Docker networking mode to use for the containers in your task.

The logging configuration to use for your tasks.

Whether the task should continue to run if the container finishes or fails.

The command the container should run when it’s started.

Any data volumes that should be used with the containers in the task.

The AWS Identity and Access Management (IAM) role that your tasks should use.
```

### Schedular & Task placement
ECS scheduling engine:
logic when to start and stop containers
Diff types of app/

1. Service scheduler
availability zone 1
availablitiy zone 2

2. Daemon scheduler


3. Cron-like schedular
Amazon EventBridge


Amazon ECS - placement engine
constraints: 
affinity, distinct instance
Strategies:
Binpack (cost optimized), Spread (high available)
service autoscaling

```shell
aws ecs run-task --cluster ecs-demo --task-definition myapp --count 6 \
--placement-strategy type ="spread", field="attribute:ecs.availability-zone" \
type="binpack", field="memory"
```

There are multiple ways you can schedule tasks: through service scheduling, manual scheduling, 
cron scheduling, or by using custom schedulers.

#### ECS Logs tools
Amazon ECS console - notifications about the instance
CloudWatch Logs - failed logs etc
Amazon ECS Exec - 
Amazon ECS host logs - extract ecs agent log
Amazon ECS host - Docker

## AWS Fargate
fully managed compute platform
only costing while running

### AWS Copilot
AWS Copilot is a command line tool that you can use with Amazon Elastic Container Service (Amazon ECS). Copilot automates the creation of many resources that you need to host your container workloads on Amazon ECS.

1. appliction  -> An application is a logical grouping of resources. 
2. environment -> An environment is used for different settings and stages of your application (such as testing, staging, and production).
3. service     -> a load balanced web service for the frontend, and a backend service for the API.

## AWS EKS (Elastic Kubernetes Service)
AWS Controllers for kubernetes (kubernetes API, aws controllers for kubernetes custom resource)

1. Control Plane -> API -> etcd
2. Worker Nodes (work load runs on worker nodes)


### Namespace
isolates groups of resources in a cluster
### Pod
A pod is the smallest kubernetes object that represents -> one or more containers on a cluster

### Deployment
A deployment is a declarative template for pods

Worker node -> Namespace -> Deployment -> Pod

deployment:
DeploymentSpec, PodTemplateSpec, PodSpec
ServiceSpec (type: LoadBalancer), Cluster Ip (default)
```yml
apiVersion: v1
kind: Service
metadata:
    name: directory-frontend
spec:
    selector:
        app: directory-frontend
    type: LoadBalancer
    ports:
        - protocol: TCP
          port: 80
          targetPort: 80
```

### AWS Load Balancer Controller Add-on
Elastic Load Balancing

### Volumes
problem: ephermal (temp), when container goes away, it is deleted
resolution: use volumes
types of volumes:
#### EBS
emptyDir 
awsElasticBlockStore - EBS disk (permanent disk)
#### Network file system
GlusterFS
CephFS

### Kubernetes Concepts - Scaling and Service Discovery


corp-eks-cluster.yml
```yml
apiVersion: eksctl.io/vlalpha5
kind: ClusterConfig

metadata:
    name: corp-app-eks-cluster
    region: us-east-1
    version: "1.21"

managedNodeGroups:
    - name: nodegroup
      desiredCapacity: 3
      instanceType: t3.small

cloudWatch:
    clusterloggin:
        enableTypes:
            - "controllerManager"

iam:
    withOIDC: true
    serviceAccounts:
        - metadata:
            name: dynamodb-read-only
          attachPolicyARNs:
            - arn:aws:iam::340790186419:policy/eks-directory-service
```

#### Namespace
kubectl get all -all-namespaces
kubectl get pods --all-namespaces

1. Amazon EKS
2. Upgrading your Amazon EKS cluster
3. EKS Best Practices Guide
4. Kubernetes objects
5. Pod networking
6. Logging
7. EKS Workshop (link: https://www.eksworkshop.com/)

### Debuggin with Amazon EKS
1. kubectl logs: View the logs of a container in a Pod.
2. kubectl port-forward: Connect ports on your local host to ports on a container.
3. kubectl exec: Run commands inside a container.

```shell
kubectl logs service/directory-frontend # port mapping issue
kubectl port-forward service/directory-service 5000:80 -> curl -v localhost:5000:80
kubectl exec -it service/directory-service -- /bin/bash

aws logs tail --follow /aws/eks/corp-eks-cluster/cluser
kubectl apply -f dir/service.yml
```
## Amazon CloudWatch Container Insights
cpu, memory, network, Service Count, Container Instance, Task Count
ecs -> account setting -> cloudwatch container insights
cloudwatch dashboard

## Amazon Managed Service for Prometheus 
## Grafana for visualization
## AWS Lambda container image

## Exercise 4 lambda

## AWS App Mesh
envoy proxy
aws app mesh control plane -> data plane (pod - > envoy proxy)
application obsrevability, logging, tracing, metrics

