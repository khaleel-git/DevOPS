#!/usr/bin/env bash
set -euo pipefail

### -------------------------------------------
### Global Variables
### -------------------------------------------
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

log() {
    echo -e "${GREEN}[INFO]${RESET} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${RESET} $1"
}

error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

### -------------------------------------------
### Pre-flight: Check sudo
### -------------------------------------------
if [[ $EUID -ne 0 ]]; then
    warn "It's recommended to run this script as root or with sudo."
    sleep 1
fi

### -------------------------------------------
### Update system
### -------------------------------------------
log "Updating system packages..."
sudo apt-get update -y >/dev/null

### -------------------------------------------
### Ensure unzip + curl installed
### -------------------------------------------
log "Installing required base tools: zip, unzip, curl..."
sudo apt-get install -y zip unzip curl >/dev/null

### -------------------------------------------
### Install eksctl
### -------------------------------------------
install_eksctl() {
    if command -v eksctl >/dev/null; then
        warn "eksctl already installed: $(eksctl version)"
        return
    fi

    log "Installing eksctl..."
    TMPFILE=$(mktemp)
    curl --silent --location \
        "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
        -o "$TMPFILE"

    sudo tar -xzf "$TMPFILE" -C /usr/local/bin
    rm -f "$TMPFILE"

    log "eksctl installation complete."
}

### -------------------------------------------
### Install kubectl
### -------------------------------------------
install_kubectl() {
    if command -v kubectl >/dev/null; then
        warn "kubectl already installed: $(kubectl version --client --short)"
        return
    fi

    log "Installing kubectl..."
    STABLE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

    curl -LO "https://dl.k8s.io/release/${STABLE_VERSION}/bin/linux/amd64/kubectl"
    sudo install -m 0755 kubectl /usr/local/bin/kubectl
    rm -f kubectl

    log "kubectl installation complete."
}

### -------------------------------------------
### Install AWS CLI v2
### -------------------------------------------
install_aws_cli() {
    if command -v aws >/dev/null; then
        warn "AWS CLI already installed: $(aws --version)"
        return
    fi

    log "Installing AWS CLI v2..."
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

    unzip -q awscliv2.zip
    sudo ./aws/install >/dev/null

    rm -rf aws awscliv2.zip

    log "AWS CLI installation complete."
}

### -------------------------------------------
### Execution
### -------------------------------------------
log "Starting Kubernetes + AWS CLI installation..."

install_eksctl
install_kubectl
install_aws_cli

### -------------------------------------------
### Verify all tools
### -------------------------------------------
log "Verifying installations..."

eksctl version || error "eksctl failed to install!"
kubectl version --client || error "kubectl failed!"
aws --version || error "AWS CLI failed!"

log "All tools successfully installed!"
