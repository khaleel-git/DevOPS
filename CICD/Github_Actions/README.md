# GitHub Actions: A Comprehensive Guide

## Table of Contents
- [Introduction](#introduction)
- [Key Concepts](#key-concepts)
  - [Workflows](#workflows)
  - [Jobs](#jobs)
  - [Steps](#steps)
  - [Events](#events)
  - [Runners](#runners)
- [Creating a Workflow](#creating-a-workflow)
- [Reusing Workflows](#reusing-workflows)
- [Secrets and Environment Variables](#secrets-and-environment-variables)
- [Expressions and Contexts](#expressions-and-contexts)
- [Debugging and Best Practices](#debugging-and-best-practices)
- [Advanced Concepts](#advanced-concepts)
  - [Matrix Builds](#matrix-builds)
  - [Composite Actions](#composite-actions)
  - [Reusable Actions](#reusable-actions)
- [Setting Up a Self-Hosted Runner](#setting-up-a-self-hosted-runner)
- [Vault Secrets Management](#vault-secrets-management)
- [Real-Life Scenarios and Your Journey](#real-life-scenarios-and-your-journey)

---

## Introduction
GitHub Actions is a powerful CI/CD platform that enables you to automate your workflows directly in your GitHub repositories. It integrates seamlessly with your repositories, offering flexibility to build, test, and deploy your applications. With its flexibility and modularity, it suits tasks ranging from simple automation to complex deployment pipelines.

---

## Key Concepts

### Workflows
- **Definition**: A workflow is a YAML file that defines a set of jobs and steps to execute when triggered by an event.
- **Location**: Store workflows in the `.github/workflows` directory.
- **Example**:
```yaml
name: CI Workflow
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
```

### Jobs
- **Definition**: A job is a collection of steps that run on the same runner.
- **Parallel Execution**: Jobs run independently by default unless dependencies are defined using `needs`.

### Steps
- **Definition**: Steps are individual tasks within a job.
- **Actions or Scripts**: Steps can use pre-built actions or custom shell commands.

### Events
- **Definition**: Events are triggers that start workflows (e.g., `push`, `pull_request`, `schedule`).

### Runners
- **Definition**: A runner is a server that executes jobs in a workflow. GitHub provides hosted runners (e.g., Ubuntu, Windows, macOS), and you can also set up self-hosted runners.

---

## Creating a Workflow
1. Create a `.github/workflows` directory in your repository.
2. Add a YAML file (e.g., `ci.yml`) for your workflow.
3. Define triggers, jobs, and steps in the YAML file.
4. Commit the file to enable the workflow.

### Example: Basic Workflow
```yaml
name: Build and Test
on: push

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 16
      - run: npm install
      - run: npm test
```

---

## Reusing Workflows
Reusing workflows promotes DRY principles and simplifies maintenance.

### Example: Reusable Workflow
Reusable workflows require an `action.yml` or `action.yaml` in the directory.
```yaml
name: Deploy to Kubernetes
on:
  workflow_call:
    inputs:
      environment:
        required: true
      k8s-manifest-dir:
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Kubernetes
        run: kubectl apply -f ${{ inputs.k8s-manifest-dir }}
```
### Calling Reusable Workflow
```yaml
jobs:
  dev-deploy:
    uses: ./.github/workflows/deployment.yml
    with:
      environment: development
      k8s-manifest-dir: kubernetes/development/
```

---

## Secrets and Environment Variables
- **Secrets**: Store sensitive data securely in the repository settings.
- **Environment Variables**: Define and access variables for workflows.
- **Usage**:
```yaml
env:
  NODE_ENV: production

steps:
  - name: Use Secrets
    run: echo "DB_PASSWORD=${{ secrets.DB_PASSWORD }}"
```

---

## Expressions and Contexts
- **Expressions**: Dynamically evaluate values (e.g., `if: success()`).
- **Contexts**: Access information about the workflow (e.g., `github`, `secrets`, `env`).

---

## Debugging and Best Practices
- **Enable Debugging**: Use `ACTIONS_STEP_DEBUG` to enable detailed logs.
- **Error Handling**: Use `continue-on-error` to proceed despite errors.
- **Best Practices**:
  - Use reusable workflows.
  - Centralize secrets.
  - Avoid hardcoding sensitive information.

---

## Advanced Concepts

### Matrix Builds
- **Definition**: Run jobs with multiple configurations.
- **Example**:
```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest]
    node: [14, 16]
jobs:
  test:
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node }}
```

### Composite Actions
- **Definition**: Combine multiple steps into a single action.

### Reusable Actions
- **Definition**: Share actions across workflows and repositories.
- **Publishing**: Publish actions to GitHub Marketplace for reuse.

---

## Setting Up a Self-Hosted Runner

Self-hosted runners allow you to run workflows on your own infrastructure. This provides more control over the environment and can be cost-effective for large-scale operations.

### Steps to Set Up
1. **Add a Runner in GitHub**:
   - Navigate to your repository or organization settings.
   - Go to **Actions** > **Runners** > **New self-hosted runner**.
2. **Download the Runner Application**:
   - Follow the instructions provided to download and install the runner package for your OS.
3. **Configure the Runner**:
   - Use the provided token and commands to register your runner.
4. **Start the Runner**:
   - Run the start command to begin listening for jobs.

### Example Workflow for Self-Hosted Runner
```yaml
jobs:
  build:
    runs-on: self-hosted
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
      - name: Run Build
        run: make build
```

---

## Vault Secrets Management

Using a secrets management tool like HashiCorp Vault can add an extra layer of security to your workflows.

### Steps to Integrate Vault
1. **Set Up Vault**:
   - Install and configure HashiCorp Vault on your infrastructure.
   - Define and store your secrets.
2. **Authenticate to Vault**:
   - Use GitHub OIDC or a token-based authentication method to connect workflows to Vault.
3. **Fetch Secrets in Workflows**:
   - Use a script or a GitHub Action to query Vault for secrets.

### Example Workflow Using Vault
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Install Vault CLI
        run: |
          curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
          sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
          sudo apt-get update && sudo apt-get install vault
      - name: Fetch Secrets from Vault
        env:
          VAULT_TOKEN: ${{ secrets.VAULT_TOKEN }}
        run: |
          vault login $VAULT_TOKEN
          vault kv get secret/data/my-app
```

---

## Real-Life Scenarios and Your Journey

### Practical Scenarios
- **Integrating CI/CD**: Setting up GitHub Actions to test, build, and deploy code.
- **Modular Workflows**: Reusing workflows to reduce duplication.
- **Secrets Management**: Protecting sensitive information like API keys.

### My Journey
- **Hands-On Experience**: I started by learning basic workflow creation.
- **Building Expertise**: Progressed to mastering reusable workflows, debugging techniques, and advanced topics like matrix builds.
- **Real-World Applications**: Implemented GitHub Actions to solve real-world problems in your projects, ensuring automated and secure pipelines.
- **Challenges Overcome**: Debugged missing files like `action.yml`, learned about directory structures, and optimized workflows for efficiency.