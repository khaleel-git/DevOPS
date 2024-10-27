# Github Actions
1. Workflow
2. Job
3. Steps
4. Runner

![Github Actions](Github-Actions.png)

## Runner
1. Github hosted Runner (vm provided by github, new clean instance, cannot customize runners beyond selecting the type of runner eg. ubuntu, windows, macos, paid, github plans)
2. Self-hosted Runner (self environemnt, vms, multiple runner on same vm)

Why CI/CD:
Feature branch:
commit, pull request, review, approve (merged)

Continous Integration:
![Continous Integration CI](Continous-Integration-CI.png)

live testing before proceeding to production env
CI to CD (non prod/staging)

Continous Deployment/Delivery (CD):
![Continous Deployment/Delivery (CD)](continous-deployment-CD.png)

# Actions
steps:
    - uses: actions/checkout@main # @main brance, @v3.6.0 tag, @a324897907 sha

# Multi-Line commands and Executing Third Party Libraries
```yaml
name: My First Workflow

on: [push,fork]

jobs:
    first_job: 
        runs-on: ubuntu-latest
        steps:
            - name: Checkout Repo
              uses: actions/checkout@v4

            - name: List and Read Dockerfile
              run: |
                    echo "My first Github Actions Job"
                    ls -ltra
                    cat Dockerfile
```
Execute multiple jobs in Sequence using needs
use needs syntax