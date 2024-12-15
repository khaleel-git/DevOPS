## Project documentation
https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/DEV-AWS-MO-ContainersRedux/exercise-5-eks.html

## Project code
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/DEV-AWS-MO-ContainersRedux/downloads/containers-src.zip
unzip containers-src.zip -d aws_eks

### Install eksctl
```shell 
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
```
### Install kubectl
```shell
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```
### Install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

### Set env variables
```shell
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export REGION="us-east-1"
aws ecr get-login-password | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
```
### Create the Amazon ECR repositories.
```shell
aws ecr create-repository --repository-name "corpdirectory/service"
aws ecr create-repository --repository-name "corpdirectory/frontend"
```

## Task 3: Creating the cluster
### 1. eksctl create cluster -f corp-eks-cluster.yaml
`eksctl create cluster -f corp-eks-cluster.yaml`
NOTE: This process can take 10–20 minutes to complete.
The config file was created for you, and it sets up the authentication.

### 2. View the config file.
`cat ~/.kube/config`
You can communicate with your Amazon EKS cluster with kubectl.

### 3. Retrieve all namespaces.
```shell
admin@docker-host:~/aws_containerized_coursera$ kubectl get all --all-namespaces
NAMESPACE     NAME                           READY   STATUS    RESTARTS   AGE
kube-system   pod/aws-node-2r5g8             2/2     Running   0          4m19s
kube-system   pod/aws-node-77s65             2/2     Running   0          4m32s
kube-system   pod/aws-node-nhskv             2/2     Running   0          4m25s
kube-system   pod/coredns-586b798467-mrwjz   1/1     Running   0          9m25s
kube-system   pod/coredns-586b798467-xkfkq   1/1     Running   0          9m25s
kube-system   pod/kube-proxy-d92qt           1/1     Running   0          4m32s
kube-system   pod/kube-proxy-g77lj           1/1     Running   0          4m25s
kube-system   pod/kube-proxy-k546x           1/1     Running   0          4m19s

NAMESPACE     NAME                                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                  AGE
default       service/kubernetes                  ClusterIP   10.100.0.1      <none>        443/TCP                  12m
kube-system   service/eks-extension-metrics-api   ClusterIP   10.100.17.133   <none>        443/TCP                  12m
kube-system   service/kube-dns                    ClusterIP   10.100.0.10     <none>        53/UDP,53/TCP,9153/TCP   9m25s

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
kube-system   daemonset.apps/aws-node     3         3         3       3            3           <none>          9m26s
kube-system   daemonset.apps/kube-proxy   3         3         3       3            3           <none>          9m26s

NAMESPACE     NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/coredns   2/2     2            2           9m25s

NAMESPACE     NAME                                 DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/coredns-586b798467   2         2         2       9m25s
admin@docker-host:~/aws_containerized_coursera$ 
```

### 4. Deploy your application to Kubernetes.
```shell
kubectl apply -f directory-service/kubernetes/deployment.yaml   # deployment.apps/directory-service created
kubectl apply -f directory-service/kubernetes/service.yaml      # service/directory-service created
```

### 5. Exec into a service pod.
`kubectl exec -i -t service/directory-service -- /bin/bash`