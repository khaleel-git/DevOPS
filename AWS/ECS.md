### 1. Set Up AWS CLI
Ensure the AWS CLI is installed and configured.

#### Install AWS CLI (if not already installed)
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/DEV-AWS-MO-ContainersRedux/downloads/containers-src.zip
unzip containers-src.zip -d aws_containerized_coursera
```

#### Configure AWS CLI
Run the following command to set up your AWS credentials and region:
```bash
aws configure
```
- Enter your **Access Key ID**, **Secret Access Key**, and the desired **AWS region** (e.g., `us-east-1`).

---

### 2. **Set AWS Region (Explicitly in Shell)**
You can set the AWS region as an environment variable to ensure all AWS CLI and Copilot commands use the correct region:
```bash
export AWS_REGION="us-east-1"  # Replace with your preferred AWS region
```

To make it persistent across terminal sessions, add the following line to your `~/.bashrc` or `~/.zshrc` file:
```bash
echo 'export AWS_REGION="us-east-1"' >> ~/.bashrc
```

Reload your terminal configuration:
```bash
source ~/.bashrc
```

---

### 3. **Prepare Your ECS Deployment with Copilot**

#### Install AWS Copilot CLI
If not already installed:
```bash
curl -Lo /tmp/copilot https://github.com/aws/copilot-cli/releases/latest/download/copilot-linux
chmod +x /tmp/copilot
sudo mv /tmp/copilot /usr/local/bin/copilot
```

#### Initialize Copilot for Your Application
Navigate to your application's directory:
```bash
cd /path/to/your/code
```

Run the Copilot initialization:
```bash
copilot init
```
- Follow the prompts to:
  - Name your application (e.g., `my-app`).
  - Select the type of service (e.g., "Load Balanced Web Service" for web apps).
  - Provide a service name (e.g., `frontend`).
  - Select a port (e.g., `5000` for Flask applications).
  - Create or choose an existing ECS cluster.

#### Verify the Configuration
Copilot will create the necessary configurations and AWS resources, such as ECS services, load balancers, and task definitions. Verify the files generated in the `copilot/` directory.

---

### 4. **Deploy to ECS**
Deploy the service using:
```bash
copilot deploy
```
- This command builds and pushes your Docker image to Amazon Elastic Container Registry (ECR), creates the ECS task definition, and deploys it to your ECS cluster.

---

### 5. **Optional Configuration**
- To explicitly specify a profile with credentials:
  ```bash
  copilot deploy --profile my-aws-profile
  ```
- To deploy to a specific environment:
  ```bash
  copilot deploy --env production
  ```

---

### 6. **Monitor and Manage**
After deployment, you can monitor the deployment status and resources:
```bash
copilot svc status
```

To view logs:
```bash
copilot svc logs
```

---

### Summary of AWS Parameters
- **AWS Region**: Set via `aws configure` or `export AWS_REGION="region"`.
- **Access Key and Secret Key**: Set via `aws configure`.
- **ECS Cluster**: Automatically created or specified during `copilot init`.
- **Docker Image**: Built and pushed to ECR during `copilot deploy`.


## Deploy an app to ECS
copilot init \
--app corpdirectory \
--type "Backend Service" \
--name "service" \
--dockerfile ./directory-service/Dockerfile \
--deploy


copilot svc exec --name service