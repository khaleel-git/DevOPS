## 📚 CKA 2025 Practice Questions & Solutions 

Click here for all [Questions](https://docs.google.com/document/d/16CwiwhEtuisL5TaIL3rR0AJQY1BOI70yVVwuOO55tJM/edit?usp=sharing)

---

### Table of Contents

* [Q-01: NGINX TLSv1.3 Only Configuration](#q-01-nginx-tlsv13-only-configuration)
* [Q-02: Ingress to Gateway API Migration](#q-02-ingress-to-gateway-api-migration)
* [Q-04: Create Ingress Resource for Echo Server](#q-04-create-ingress-resource-for-echo-server)
* [Q-12: Cert-Manager CRD and Subject Field Documentation](#q-12-cert-manager-crd-and-subject-field-documentation)
* [Q-13: Adjust WordPress Pod Resource Requests](#q-13-adjust-wordpress-pod-resource-requests)
* [Q-14: Re-establish MariaDB Deployment with Persistent Storage](#q-14-re-establish-mariadb-deployment-with-persistent-storage)
* [Q-15: Prepare Linux System for Kubernetes (cri-dockerd & sysctl)](#q-15-prepare-linux-system-for-kubernetes-cri-dockerd--sysctl)
* [Q-16: Fix Broken Kubeadm Cluster Migration](#q-16-fix-broken-kubeadm-cluster-migration)
* [Q-17: NetworkPolicy for Frontend-Backend Communication](#q-17-networkpolicy-for-frontend-backend-communication)

---

### Q-01: NGINX TLSv1.3 Only Configuration

**📝 Question:**  
An NGINX Deployment named `nginx-static` is running in the `nginx-static` NS. It is configured using a `CfgMap` named `nginx-config`. Update the `nginx-config` ConfigMap to allow only TLSv1.3 connections. Re-create, restart, or scale resources as necessary.

By using the command to test the changes:
`[candidate@cka2025]$ curl --tls-max 1.2 https://web.k8s.local`

As TLSv1.2 should not be allowed anymore, the command should fail.

#### Prereqs

* NGINX Deployment: `nginx-static` in namespace `nginx-static`
* ConfigMap: `nginx-config` in namespace `nginx-static`
* DNS resolution for `web.k8s.local` (e.g., via `/etc/hosts` or an Ingress/Gateway)

#### Solution Steps

1.  **Edit the `nginx-config` ConfigMap:**
    Modify the `nginx.conf` data within the ConfigMap to set `ssl_protocols TLSv1.3;`.
    
    ```bash
    kubectl edit configmap nginx-config -n nginx-static
    ```

    Locate the `ssl_protocols` line and change it from `ssl_protocols TLSv1.3 TLSv1.2;` (or similar) to:
    ```nginx
    ssl_protocols TLSv1.3; #
    ```
    
    The relevant part of the `ConfigMap` data should look like this:
    ```yaml
    apiVersion: v1
    data:
      nginx.conf: |
        events { }
        http {
          server {
            listen 443 ssl;
            ssl_certificate /etc/nginx/tls/tls.crt;
            ssl_certificate_key /etc/nginx/tls/tls.key;
            ssl_protocols TLSv1.3; # Ensure only TLSv1.3 is specified here
            location / {
              root /usr/share/nginx/html;
              index index.html;
            }
          }
        }
    kind: ConfigMap
    # ... rest of the ConfigMap metadata
    ```

2.  **Restart the `nginx-static` Deployment:**
    Changes to ConfigMaps mounted as files in pods typically require a pod restart to take effect.
    
    ```bash
    kubectl rollout restart deployment nginx-static -n nginx-static
    ```

#### Verification Steps

1.  **Check Pod Status (Optional but good practice):**
    Verify that the new pods are running after the restart.
    ```bash
    kubectl get po -n nginx-static
    ```

2.  **Test TLSv1.2 Connection:**
    This command should *fail* because TLSv1.2 is no longer allowed.
    ```bash
    curl --tls-max 1.2 https://web.k8s.local
    ```
    Expected output will show an error like "curl: (35) error:1409442E:SSL routines:ssl3_read_bytes:tlsv1 alert protocol version" or similar, indicating a TLS protocol mismatch.

---

### Q-02: Ingress to Gateway API Migration

**📝 Question:**  
Migrate an existing web application from Ingress to Gateway API.  
We must maintain **HTTPS access**.

A `GatewayClass` named `nginx` is installed in the cluster.

1.  First, create a **Gateway** named `web-gateway` with hostname `gateway.web.k8s.local` that maintains the existing **TLS** and listener configuration from the existing Ingress resource named `web`.

2.  Next, create an **HTTPRoute** named `web-route` with hostname `gateway.web.k8s.local` that maintains the existing routing rules from the current Ingress resource named `web`.

3.  You can test your Gateway API configuration with the following command:
    ```bash
       curl https://gateway.web.k8s.local
    ```

4.  Finally, delete the existing Ingress resource named `web`.

#### Prereqs

* TLS Secret: `web-tls`
* Backend Service: `nginx-service:80`
* GatewayClass: `nginx-class`

#### Gateway YAML (`web-gateway.yaml`)

```yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: web-gateway
  namespace: alpha
spec:
  gatewayClassName: nginx-class
  listeners:
    - name: https-listener
      hostname: "gateway.web.k8s.local"
      port: 443
      protocol: HTTPS
      tls:
        mode: Terminate
        certificateRefs:
          - kind: Secret
            name: web-tls
````

#### HTTPRoute YAML (`web-route.yaml`)

```yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: web-route
  namespace: alpha
spec:
  parentRefs:
    - name: web-gateway
  hostnames:
    - "gateway.web.k8s.local"
  rules:
    - matches:
        - path:
            type: PathPrefix
            value: /
      backendRefs:
        - name: nginx-service
          port: 80
```

#### Verification Steps

```bash
kubectl get gateway web-gateway -n alpha
kubectl describe gateway web-gateway -n alpha

kubectl get httproute web-route -n alpha
kubectl describe httproute web-route -n alpha
```

#### DNS Resolution (Local Host Setup)

```bash
# Edit /etc/hosts
<NODE_IP> gateway.web.k8s.local
```

#### Final Test (Curl to Gateway)

```bash
curl -k [https://gateway.web.k8s.local](https://gateway.web.k8s.local):<NodePort>
```

#### Cleanup (ONLY if test is successful)

```bash
kubectl delete ingress web -n alpha
```

-----

### Q-03: Create a HorizontalPodAutoscaler (HPA)

**📝 Question:**
Create a new HorizontalPodAutoscaler (HPA) named `apache-server` in the `autoscaled` namespace. This HPA must target the existing Deployment called `apache-server` in the `autoscaled` namespace.

Set the HPA to target for 50% CPU usage per Pod.

  * Configure hpa to have at min 1 Pod and no more than 4 Pods[max].
  * Also, we have to set the downscale stabilization window to 30 seconds.

-----

#### Prereqs

  * An existing Deployment named `apache-server` in the `autoscaled` namespace.
  * Metrics Server installed and running in the cluster (essential for HPA to collect CPU/memory metrics).

#### Solution Steps

1.  **Create the `autoscaled` namespace (if it doesn't exist):**
    This step ensures the target namespace for the HPA and Deployment exists.

    ```bash
    kubectl create namespace autoscaled
    ```

2.  **Create the HorizontalPodAutoscaler (HPA):**
    Create a YAML file (e.g., `apache-hpa.yaml`) with the HPA definition.

    ```yaml
    apiVersion: autoscaling/v2
    kind: HorizontalPodAutoscaler
    metadata:
      name: apache-server # Name of the HPA
      namespace: autoscaled # Namespace for the HPA
    spec:
      scaleTargetRef:
        apiVersion: apps/v1
        kind: Deployment
        name: apache-server # Target the 'apache-server' Deployment
      minReplicas: 1 # Minimum number of pods
      maxReplicas: 4 # Maximum number of pods
      metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: Utilization
              averageUtilization: 50 # Target 50% CPU usage
      behavior:
        scaleDown:
          stabilizationWindowSeconds: 30 # Downscale stabilization window
    ```

    Apply the HPA definition:

    ```bash
    kubectl apply -f apache-hpa.yaml
    ```

#### Verification Steps

1.  **Check HPA status:**
    Verify that the HPA has been created and is targeting the correct Deployment.

    ```bash
    kubectl get hpa -n autoscaled
    ```

    Look for `apache-server` in the output. The `TARGETS` column might initially show `<unknown>/50%` if metrics haven't been collected yet, but `MINPODS` should be `1` and `MAXPODS` should be `4`.

2.  **Describe the HPA for detailed information:**
    Check the HPA's full configuration, including `Min Replicas`, `Max Replicas`, `Metrics`, and `Behavior`.

    ```bash
    kubectl describe hpa apache-server -n autoscaled
    ```

    Confirm that `Metrics` shows `cpu utilization 50%`. Also, verify the `Downscale Stabilization Window` in the `Behavior` section is `30s`.

3.  **Monitor Deployment scaling (Optional):**
    If you apply a load to the `apache-server` Deployment, you should observe the `REPLICAS` increasing (up to 4) and then decreasing (after 30 seconds of low load) as the HPA takes effect.

    ```bash
    # To observe pod count changes:
    kubectl get deployment apache-server -n autoscaled -w
    # To observe HPA events:
    kubectl get events -n autoscaled --field-selector involvedObject.kind=HorizontalPodAutoscaler
    ```
-----
### Q-04: Create Ingress Resource for Echo Server

**📝 Question:**
Create a new Ingress resource `echo` in the `echo-sound` namespace. Exposing Service `echoserver-service` on `http://example.org/echo` using Service port `8080`.

The availability of Service `echoserver-service` can be checked using the following command, which should return `200`:
`[candidate@cka2025]$ curl -o /dev/null -s -w "%{http_code}\n" http://example.org/echo`

#### Prereqs

  * Namespace: `echo-sound` (create if it doesn't exist).
  * Service: `echoserver-service` listening on port `8080` in the `echo-sound` namespace (assume it exists and routes to an an echo application).
  * Ingress Controller: An Ingress Controller (e.g., NGINX Ingress Controller) must be installed and running in the cluster.
  * DNS: `example.org` should resolve to the Ingress Controller's IP (e.g., via `/etc/hosts` or actual DNS configuration).

#### Solution Steps

1.  **Create the `echo-sound` Namespace (if it doesn't exist):**

    ```bash
    kubectl create ns echo-sound
    ```

2.  **Create the Ingress Resource:**
    Create a file named `echo-ingress.yaml` with the following content:

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: echo
      namespace: echo-sound
    spec:
      rules:
      - host: example.org
        http:
          paths:
          - path: /echo
            pathType: Prefix
            backend:
              service:
                name: echoserver-service
                port:
                  number: 8080
    ```

    Apply the Ingress:

    ```bash
    kubectl apply -f echo-ingress.yaml
    ```

#### Verification Steps

1.  **Check Ingress Status:**
    Verify the Ingress resource is created and has an address assigned by the Ingress Controller.

    ```bash
    kubectl get ingress -n echo-sound
    ```

2.  **Test Service Availability via Ingress:**
    This command should return `200`.

    ```bash
    curl -o /dev/null -s -w "%{http_code}\n" http://example.org/echo
    ```

    *Note: If `example.org` does not resolve, you might need to add an entry to your `/etc/hosts` file pointing `example.org` to the IP address of your Ingress Controller (e.g., a NodePort IP or LoadBalancer IP).*

-----

### Q-05: Install and Configure a CNI Plugin (Flannel - Download, Edit, Apply)

**📝 Question:**
Install and configure a Container Network Interface (CNI) of your choice that meets the specified requirements. Choose one of the following CNI options:

  * Flannel (v0.26.1) using the manifest: `https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yaml`
  * Calico (v3.28.2) using the manifest: `https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml`

Ensure the selected CNI is properly installed and configured in the Kubernetes cluster.

Implicit requirements based on general CNI functionality and typical CKA expectations:

  * Let Pods communicate with each other.
  * Install from manifest files (do not use Helm).

-----

#### Prereqs

  * A Kubernetes cluster where a CNI is not yet installed or needs to be replaced.
  * `kubectl` configured to interact with the cluster.
  * Internet connectivity to fetch the manifest file.

#### Chosen CNI and Rationale

As requested, we will choose **Flannel** (v0.26.1). Flannel is a simple CNI that provides basic pod-to-pod networking, which is a fundamental requirement for a CNI. It can be installed directly from a manifest file, fulfilling the "do not use Helm" requirement.

#### Solution Steps (Flannel - Download, Edit, Apply)

1.  **Identify your Kubernetes Cluster's Pod CIDR:**
    It's crucial to first know your cluster's actual configured pod CIDR. This is typically set during `kubeadm init` via the `--pod-network-cidr` flag. You can find it by inspecting the `kubeadm-config` ConfigMap or the `kube-controller-manager` static pod manifest.

      * **Option A: From `kubeadm-config` (recommended for kubeadm clusters):**

        ```bash
        kubectl get cm kubeadm-config -n kube-system -o yaml | grep -A 5 "networking:"
        # Look for the 'podSubnet:' field under 'networking:'
        # Example output:
        #   networking:
        #     dnsDomain: cluster.local
        #     podSubnet: 192.232.233.0/18 # <-- This is your cluster's pod CIDR
        #     serviceSubnet: 10.96.0.0/12
        ```

      * **Option B: From `kube-controller-manager` manifest (if kubeadm-config isn't available or for double-checking):**
        This command needs to be run on the control plane node.

        ```bash
        grep "cluster-cidr" /etc/kubernetes/manifests/kube-controller-manager.yaml
        ```

    **Note down the exact CIDR (e.g., `192.232.233.0/18`) that your cluster is configured to use.** This is the value you will use to update the Flannel manifest.

2.  **Download the Flannel Manifest:**
    Download the `kube-flannel.yaml` manifest file to your current directory.

    ```bash
    curl -o kube-flannel.yaml https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yaml
    ```

3.  **Edit the Flannel Manifest to Update the Network CIDR:**
    Open the downloaded `kube-flannel.yaml` file in a text editor (like `vi` or `nano`):

    ```bash
    vi kube-flannel.yaml
    ```

    Search for the `kube-flannel-cfg` ConfigMap section. Within its `data` field, you will find `kube-subnet.env`. Locate the `FLANNEL_NETWORK` variable and change its value to the CIDR you identified in Step 1.

    **Original (example for `FLANNEL_NETWORK`):**

    ```yaml
    # ...
    kind: ConfigMap
    apiVersion: v1
    metadata:
      name: kube-flannel-cfg
      namespace: kube-flannel
    data:
      # ... other data ...
      kube-subnet.env: |
        FLANNEL_NETWORK=10.244.0.0/16 # <--- This is the line to modify
        FLANNEL_MTU=1450
        FLANNEL_IPMASQ=true
    ```

    **Modified (example, using `192.232.233.0/18` as the detected cluster CIDR):**

    ```yaml
    # ...
    kind: ConfigMap
    apiVersion: v1
    metadata:
      name: kube-flannel-cfg
      namespace: kube-flannel
    data:
      # ... other data ...
      kube-subnet.env: |
        FLANNEL_NETWORK=192.232.233.0/18 # <--- Updated to match your cluster's CIDR
        FLANNEL_MTU=1450
        FLANNEL_IPMASQ=true
    ```

    Save and exit the editor.

4.  **Apply the Modified Flannel Manifest:**
    Apply the `kube-flannel.yaml` file that you just modified.

    ```bash
    kubectl apply -f kube-flannel.yaml
    ```

5.  **Clean up the downloaded manifest (Optional but good practice):**

    ```bash
    rm kube-flannel.yaml
    ```

6.  **Wait for Flannel Pods to become Ready:**
    Monitor the pods in the `kube-flannel` namespace until they are all `Running` and `Ready`.

    ```bash
    kubectl get pods -n kube-flannel --watch
    # Wait until all pods show "Running" status and are ready (e.g., 1/1)
    ```

#### Verification Steps

1.  **Verify CNI Pods are Running:**
    Check the pods in the `kube-flannel` namespace. All of them should be in the `Running` state.

    ```bash
    kubectl get pods -n kube-flannel
    ```

    Expected output will show pods like `kube-flannel-daemonset-xxxx` in `Running` status.

2.  **Verify Pod-to-Pod Communication:**
    Deploy two simple pods in different namespaces (or the same) and try to `ping` or `curl` between them to confirm network connectivity.

    ```bash
    # Create a test namespace if it doesn't exist
    kubectl create namespace test-network || true

    # Deploy a busybox pod
    kubectl run busybox-1 --image=busybox:latest -n test-network --restart=Never -- sleep 3600

    # Deploy another busybox pod
    kubectl run busybox-2 --image=busybox:latest -n test-network --restart=Never -- sleep 3600

    # Wait for pods to be running
    kubectl get pods -n test-network -w

    # Get the IP address of busybox-2
    BUSYBOX2_IP=$(kubectl get pod busybox-2 -n test-network -o jsonpath='{.status.podIP}')

    # From busybox-1, ping busybox-2
    kubectl exec -it busybox-1 -n test-network -- ping -c 3 $BUSYBOX2_IP
    ```

    The `ping` command should be successful, confirming that pods can communicate with each other. Also, you can inspect the pod IPs to ensure they fall within the new CIDR range you configured for Flannel.

    ```bash
    kubectl get pods -n test-network -o wide
    ```

    Check the `IP` column. The IPs should be within your configured range (e.g., `192.232.233.0/18`).
-----

### Q-06: Install and Configure a CNI Plugin (Calico - Direct Install)

**📝 Question:**
Install and configure a Container Network Interface (CNI) of your choice that meets the specified requirements. Choose one of the following CNI options:

  * Flannel using the manifest $\\rightarrow$ `https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yaml`
  * Calico using the manifest $\\rightarrow$ `https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml`

Ensure the selected CNI is properly installed and configured in the Kubernetes cluster.
The CNI you choose must:

  * Let Pods communicate with each other
  * Support Network Policy enforcement
  * Install from manifest files (do not use Helm)

-----

#### Prereqs

  * A Kubernetes cluster where a CNI is not yet installed or needs to be replaced.
  * `kubectl` configured to interact with the cluster.
  * Internet connectivity to fetch the manifest file.

#### Chosen CNI and Rationale

The question provides two options: Flannel and Calico. We need a CNI that "Support Network Policy enforcement".

  * **Flannel:** Primarily focuses on providing basic network connectivity between pods. It does not natively support Network Policies.
  * **Calico:** Provides both network connectivity and robust Network Policy enforcement.

Therefore, **Calico** is the appropriate choice as it meets all the stated requirements, especially Network Policy enforcement.

#### Solution Steps (Calico - Direct Install)

1.  **Apply the Calico Manifest Directly:**
    Use `curl` to fetch the manifest and pipe its content directly to `kubectl apply -f -`. This avoids saving the file to disk.

    ```bash
    curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml | kubectl apply -f -
    ```

    This command will create all the necessary Kubernetes resources (Deployments, DaemonSets, RBAC, etc.) for Calico to function.

2.  **Wait for Calico Pods to become Ready:**
    It might take a few moments for all Calico components to start up and become ready. Monitor the pods in the `calico-system` (or similar, depending on Calico version) namespace until they are all `Running` and `Ready`.

    ```bash
    kubectl get pods -n calico-system --watch
    # Wait until all pods show "Running" status
    ```

#### Verification Steps

1.  **Verify CNI Pods are Running:**
    Check the pods in the `calico-system` namespace. All of them should be in the `Running` state.

    ```bash
    kubectl get pods -n calico-system
    ```

    Expected output will show pods like `calico-node-xxxx` and `calico-kube-controllers-xxxx` in `Running` status.

2.  **Verify Pod-to-Pod Communication:**
    Deploy two simple pods in different namespaces (or the same, but different nodes if possible) and try to `ping` or `curl` between them.

    ```bash
    # Create test namespace
    kubectl create namespace test-ns-1
    kubectl create namespace test-ns-2

    # Deploy busybox in test-ns-1
    kubectl run busybox-1 -n test-ns-1 --image=busybox:latest --restart=Never -- sleep 3600
    # Deploy busybox in test-ns-2
    kubectl run busybox-2 -n test-ns-2 --image=busybox:latest --restart=Never -- sleep 3600

    # Wait for pods to be running
    kubectl get pods -n test-ns-1 -w
    kubectl get pods -n test-ns-2 -w

    # Get IP of busybox-2
    BUSYBOX2_IP=$(kubectl get pod busybox-2 -n test-ns-2 -o jsonpath='{.status.podIP}')

    # From busybox-1, ping busybox-2
    kubectl exec -it busybox-1 -n test-ns-1 -- ping -c 3 $BUSYBOX2_IP
    ```

    The `ping` command should be successful, demonstrating pod-to-pod communication.

3.  **Verify Network Policy Enforcement (Conceptual):**
    To confirm Network Policy enforcement, you would typically:

      * Create a simple NetworkPolicy that denies all ingress traffic to a specific pod (e.g., `busybox-2`).
      * Attempt to `curl` or `ping` that pod from another pod. The connection should fail.
      * Then, modify or remove the NetworkPolicy to allow traffic and re-test.

    Example of a deny-all NetworkPolicy (do NOT apply this directly unless you understand its impact, it's for conceptual verification):

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      name: deny-all-ingress
      namespace: test-ns-2
    spec:
      podSelector:
        matchLabels:
          run: busybox-2 # Selects the busybox-2 pod
      policyTypes:
        - Ingress
      ingress: [] # Empty ingress rules mean no traffic is allowed
    ```

    If you apply this and `ping` `busybox-2` again from `busybox-1`, it should fail, confirming that Calico is enforcing network policies.
-----
### Q-07: Install Argo CD with Helm

**📝 Question:**
Install Argo CD in cluster:
Add the official Argo CD Helm repository with the name `argo`.
The Argo CD CRDs have already been pre-installed in the cluster.
Generate a helm template of the Argo CD Helm chart version 7.7.3 for the `argocd` NS and save to `/argo-helm.yaml`
Configure the chart to not install CRDs.
Install Argo CD using Helm with release name `argocd` using the same version as above
and configuration as used in the template 7.7.3.
Install it in the `argocd` ns and configure it to not install CRDs.
You do not need to configure access to the Argo CD server UI.

-----

#### Prereqs

  * Helm installed and configured.
  * Basic understanding of Helm commands and Kubernetes namespaces.
  * The `argocd` namespace is expected to exist, or you might need to create it.

#### Solution Steps

1.  **Add the official Argo CD Helm repository:**

    ```bash
    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update
    ```

2.  **Generate a Helm template of the Argo CD chart (version 7.7.3) and save it:**
    The key here is to specify `--version 7.7.3` and `--namespace argocd`, and `--no-hooks` to prevent pre-install hooks from running during template generation if they involve CRDs (though the question states CRDs are pre-installed). The `--set installCRDs=false` flag is crucial.

    ```bash
    helm template argocd argo/argo-cd --version 7.7.3 --namespace argocd --no-hooks --set crds.install=false > /argo-helm.yaml
    ```

    *Note: The `--no-hooks` flag ensures that Helm's templating process doesn't include any hook resources that might unexpectedly attempt to manage CRDs during the template generation, although the primary control is `installCRDs=false`.*

3.  **Install Argo CD using Helm with the specified version and configuration:**
    This step performs the actual installation. We'll use the same flags as the template generation for consistency and to ensure CRDs are not installed.

    ```bash
    kubectl create namespace argocd  # Create namespace if it doesn't exist
    helm install argocd argo/argo-cd --version 7.7.3 --namespace argocd --set crds.install=false
    ```

#### Verification Steps

1.  **Verify Helm release status:**
    Check if the `argocd` release is successfully deployed.

    ```bash
    helm list -n argocd
    ```

    You should see `argocd` listed with a `STATUS` of `deployed`.

2.  **Verify Pods are running in the `argocd` namespace:**
    Check the status of the pods to ensure Argo CD components are running.

    ```bash
    kubectl get pods -n argocd
    ```

    All pods should eventually reach `Running` or `Completed` status.

3.  **Inspect the generated template file (Optional):**
    You can check the content of `/argo-helm.yaml` to ensure it doesn't contain CRD definitions.

    ```bash
    cat /argo-helm.yaml | grep -i "crd"
    # This should return very few, if any, lines related to creating CRDs, mainly in comments or non-install sections.
    ```
-----

### Q-08: Create and Apply PriorityClass (Inline Patch)

**📝 Question:**
Create a new PriorityClass named `high-priority` for user-workloads with a value that is one less than the highest existing user-defined priority class value.
Patch the existing Deployment `busybox-logger` running in the `priority` namespace to use the `high-priority` priority class.
Ensure that the `busybox-logger` Deployment rolls out successfully with the new priority class set.
It is expected that Pods from other Deployments running in the `priority` namespace are evicted.
Do not modify other Deployments running in the `priority` namespace.
Failure to do so may result in a reduced score.

-----

#### Prereqs

  * An existing user-defined PriorityClass (you'll need to determine its highest value). Let's assume you've identified the highest user-defined priority class has a value, for example, `1000000`.
  * An existing Deployment named `busybox-logger` in the `priority` namespace.
  * Other Deployments/Pods in the `priority` namespace that can be evicted.

#### Solution Steps

1.  **Find the highest existing user-defined PriorityClass value:**
    First, inspect existing PriorityClasses to determine the highest user-defined value. System PriorityClasses usually start with `system-`. We are interested in user-defined ones.

    ```bash
    kubectl get priorityclass
    ```

    Look at the `VALUE` column. For example, if you see `custom-high-value` with `VALUE: 1000000`, then "one less than the highest" would be `999999`.

    Let's assume the highest user-defined value is `1000000`.

2.  **Create the `high-priority` PriorityClass:**
    *Note: Creating a new resource like a PriorityClass cannot be done with `kubectl patch`. `patch` is used to modify *existing* resources. Therefore, we use `kubectl apply` for this step.*

    Create the PriorityClass directly using `kubectl apply` with an inline YAML string:

    ```bash
    kubectl apply -f - <<EOF
    apiVersion: scheduling.k8s.io/v1
    kind: PriorityClass
    metadata:
      name: high-priority
    value: 999999 # One less than the highest user-defined priority value found
    globalDefault: false
    description: "This priority class should be used for high-priority user workloads."
    EOF
    ```

3.  **Patch the `busybox-logger` Deployment (Inline Patch):**
    Use `kubectl patch deployment` with an inline strategic merge patch to add the `priorityClassName` to the `spec.template.spec` section of the `busybox-logger` Deployment.

    ```bash
    kubectl patch deployment busybox-logger -n priority -p '{"spec":{"template":{"spec:{"priorityClassName":"high-priority"}}}}'
    ```

-----

#### Verification Steps

1.  **Verify the `high-priority` PriorityClass is created:**
    Check that the PriorityClass exists and has the correct value.

    ```bash
    kubectl get priorityclass high-priority
    ```

    Ensure `VALUE` is `999999`.

2.  **Check `busybox-logger` Deployment rollout status:**
    Confirm that the Deployment successfully rolls out new pods that incorporate the PriorityClass.

    ```bash
    kubectl rollout status deployment busybox-logger -n priority
    ```

3.  **Verify Pods use the new PriorityClass and observe evictions:**
    Describe a pod from the `busybox-logger` Deployment to confirm it's using `high-priority`. Observe if other pods in the `priority` namespace are evicted or enter a pending state due to resource preemption.

    ```bash
    kubectl get pods -n priority
    # You should see new busybox-logger pods running.

    # Describe one of the busybox-logger pods to confirm the priorityClass
    kubectl describe pod <busybox-logger-pod-name> -n priority
    # Look for 'Priority Class Name: high-priority'

    # Check for evicted pods or pods in pending state
    kubectl get events -n priority | grep Evicted
    # Or simply watch pods to see if others are terminated and potentially new ones get scheduled
    kubectl get pods -n priority --watch
    ```

-----
### Q-09: Expose Frontend Deployment via NodePort Service

**📝 Question:**
Reconfigure the existing Deployment `front-end` in namespace `sp-culator` to expose port `80/tcp` of the existing container `nginx`.
Create a new Service named `front-end-svc` exposing the container port `80/tcp`.
Configure the new Service to also expose the individual pods via a `NodePort`.

-----

#### Prereqs

  * An existing Deployment named `front-end` in the `sp-culator` namespace.
  * The main container in the `front-end` Deployment is named `nginx` and listens on port `80/tcp`.

#### Solution Steps

1.  **Edit the `front-end` Deployment to expose container port 80:**
    This step ensures the `nginx` container within the `front-end` Deployment has `containerPort: 80` explicitly defined, making it discoverable by the Service.

    ```bash
    kubectl edit deployment front-end -n sp-culator
    ```

    Locate the `containers` section, find the `nginx` container, and add or ensure the `ports` section is present:

    ```yaml
    # ... (existing Deployment YAML)
    spec:
      template:
        spec:
          containers:
            - name: nginx # Make sure this is the correct container name
              image: nginx:latest # Keep original image
              ports: # Add this section if not present
                - containerPort: 80 # Expose port 80 of the nginx container
                  protocol: TCP
    # ... (rest of the Deployment YAML)
    ```

    Save and exit the editor. The Deployment will roll out new pods with this configuration.

2.  **Create the `front-end-svc` Service:**
    Create a YAML file (e.g., `front-end-svc.yaml`) for the Service. This Service will select pods with the appropriate label (e.g., `app: front-end` or whatever label the `front-end` Deployment uses in its `selector.matchLabels` and `template.metadata.labels`), expose port 80, and be of type `NodePort`.

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: front-end-svc
      namespace: sp-culator
    spec:
      selector:
        app: front-end # IMPORTANT: Use the actual label from your 'front-end' deployment's pods
      ports:
        - protocol: TCP
          port: 80        # Service port
          targetPort: 80  # Container port
          name: http      # Optional: Name the port
      type: NodePort      # Expose the service via NodePort
    ```

    Apply the Service:

    ```bash
    kubectl apply -f front-end-svc.yaml
    ```

-----

#### Verification Steps

1.  **Check Service status:**
    Verify that the `front-end-svc` Service has been created and has a NodePort assigned.

    ```bash
    kubectl get svc -n sp-culator
    ```

    You should see `front-end-svc` with a `TYPE` of `NodePort` and a port mapping like `80:3XXXX/TCP`. Note down the NodePort (e.g., `30080`).

2.  **Verify Endpoint association:**
    Ensure the Service has active endpoints (i.e., it's connected to the `front-end` pods).

    ```bash
    kubectl get endpoints front-end-svc -n sp-culator
    ```

    You should see IP addresses listed under `ENDPOINTS`.

3.  **Test access via NodePort (Optional but recommended for full verification):**
    From outside the cluster (or from another node), you can test access to the `front-end` application using any Node's IP address and the assigned NodePort.

    ```bash
    # Replace <NODE_IP> with the IP address of one of your cluster nodes.
    # Replace <NODE_PORT> with the actual NodePort allocated to front-end-svc (e.g., 30080).
    curl http://<NODE_IP>:<NODE_PORT>
    ```

    This command should return the NGINX default welcome page or the content served by your `front-end` application.
-----

### Q-10: Create and Set Default StorageClass

**📝 Question:**

1.  Create a new StorageClass named `low-latency` that uses the existing provisioner `rancher.io/local-path`.
2.  Set the `VolumeBindingMode` to `WaitForFirstConsumer`. (Mandatory or the score will be reduced)
3.  Make the newly created StorageClass (`low-latency`) the default StorageClass in the cluster.
4.  DO NOT modify any existing Deployments or PersistentVolumeClaims. (If modified, the score will be reduced)

-----

#### Prereqs

  * An existing StorageClass provisioner: `rancher.io/local-path`.

#### Solution Steps

1.  **Create the `low-latency` StorageClass:**
    Create a YAML file (e.g., `low-latency-sc.yaml`) with the following content. This defines the new StorageClass, specifies its provisioner, and sets the `VolumeBindingMode`.

    ```yaml
    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
      name: low-latency
      annotations:
        storageclass.kubernetes.io/is-default-class: "true" # This makes it the default
    provisioner: rancher.io/local-path
    volumeBindingMode: WaitForFirstConsumer
    reclaimPolicy: Delete # Common default, adjust if a different policy is required by unstated constraints
    ```

    Apply the StorageClass:

    ```bash
    kubectl apply -f low-latency-sc.yaml
    ```

2.  **Set `low-latency` as the default StorageClass:**
    This is achieved by adding the `storageclass.kubernetes.io/is-default-class: "true"` annotation under the `metadata` section of the StorageClass, as shown in the YAML above. If there was an existing default StorageClass, you would first need to remove this annotation from it by editing it:

    ```bash
    # If another StorageClass is currently default, first edit it to remove the default annotation:
    # kubectl edit storageclass <current-default-storageclass-name>
    # Remove or change 'storageclass.kubernetes.io/is-default-class: "true"' to "false"
    ```

    Since the new StorageClass is applied with this annotation set to "true", it will become the default.

#### Verification Steps

1.  **Verify the `low-latency` StorageClass is created and is default:**
    Check the list of StorageClasses. The `low-latency` StorageClass should be marked as `(default)`.

    ```bash
    kubectl get sc
    ```

    Expected output will show `low-latency` with `(default)` next to its name. Example:

    ```
    NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
    low-latency (default) rancher.io/local-path   Delete          WaitForFirstConsumer   false                  <X>s
    ```

2.  **Verify `VolumeBindingMode`:**
    Describe the `low-latency` StorageClass to confirm the `VolumeBindingMode` is set correctly.

    ```bash
    kubectl describe sc low-latency
    ```

    Look for `VolumeBindingMode: WaitForFirstConsumer` in the output.
-----
### Q-11: Logging Integration with Sidecar Container

**📝 Question:**
A legacy app needs to be integrated into the Kubernetes built-in logging architecture (i.e. `kubectl logs`). Adding a streaming co-located container is a good and common way to accomplish this requirement.

Task
Update the existing Deployment `synergy-deployment`, adding a co-located container named `sidecar` using the `busybox:stable` image to the existing Pod. The new co-located container has to run the following command:
`/bin/sh -c "tail -n+1 -f /var/log/synergy-deployment.log"`
Use a Volume mounted at `/var/log` to make the log file `synergy-deployment.log` available to the co located container.
Do not modify the specification of the existing container other than adding the required volume.
Hint: Use a shared volume to expose the log file between the main application container and the sidecar.

-----

#### Prereqs

  * An existing Deployment named `synergy-deployment`.
  * The main container in `synergy-deployment` is assumed to be writing logs to `/var/log/synergy-deployment.log`.

#### Solution Steps

1.  **Edit the `synergy-deployment` Deployment:**
    Use `kubectl edit deployment synergy-deployment` to modify the Deployment definition.

    ```bash
    kubectl edit deployment synergy-deployment
    ```

2.  **Add the `sidecar` container and shared volume configuration:**
    Locate the `spec.template.spec` section of your Deployment. You will need to add:

      * A new container definition under `spec.template.spec.containers` for the `sidecar`.
      * A volume definition under `spec.template.spec.volumes`.
      * `volumeMounts` in both the existing container and the new `sidecar` container, referencing the shared volume.

    Your Deployment YAML should be modified to include these sections (adjust indentation as necessary):

    ```yaml
    # ... (existing Deployment YAML)
    spec:
      template:
        spec:
          # Add the volume definition here
          volumes:
            - name: log-volume # Name of the shared volume
              emptyDir: {}    # An emptyDir volume is suitable for shared ephemeral storage

          containers:
            # Your existing container (e.g., 'synergy-app' or whatever its name is)
            - name: <your-main-app-container-name> # IMPORTANT: Replace with the actual name of your existing container
              image: <your-main-app-image>         # IMPORTANT: Keep its original image
              command: ["/bin/sh", "-c", "while true; do date >> /var/log/synergy-deployment.log; sleep 5; done"]
              # Add the volumeMount for the existing container
              volumeMounts:
                - name: log-volume
                  mountPath: /var/log/ # This path should match where the main app writes its logs

            # Add the new sidecar container
            - name: sidecar
              image: busybox:stable
              command: ["/bin/sh", "-c", "tail -n+1 -f /var/log/synergy-deployment.log"]
              volumeMounts:
                - name: log-volume
                  mountPath: /var/log/ # Mount the same volume for the sidecar
    # ... (rest of the Deployment YAML)
    ```

    After saving the changes in the editor, Kubernetes will automatically update and roll out the new pods.

-----

#### Verification Steps

1.  **Check Deployment rollout status:**
    Verify that the Deployment is rolling out and new pods are becoming ready.

    ```bash
    kubectl rollout status deployment synergy-deployment
    ```

2.  **Check Pods status:**
    Ensure the new pods with the sidecar container are running.

    ```bash
    kubectl get pods -l app=<your-synergy-app-label> # Use the appropriate label for your deployment
    ```

3.  **Verify sidecar container logs:**
    Access the logs of the `sidecar` container within one of the new pods. You should see it streaming the log content. Replace `<pod-name>` with the actual name of a `synergy-deployment` pod.

    ```bash
    kubectl logs <pod-name> -c sidecar
    ```

    This command should show output from `synergy-deployment.log`, confirming the sidecar is correctly tailing the log file.

4.  **Inspect Pod YAML (Optional):**
    To confirm the configuration was applied correctly, you can describe a new pod and check its containers and volumes.

    ```bash
    kubectl describe pod <pod-name>
    ```

    Look under `Containers` for `sidecar` and ensure its `Command` and `Volume Mounts` are correct. Also, look under `Volumes` for `log-volume`.
-----

### Q-12: Cert-Manager CRD and Subject Field Documentation

**📝 Question:**
Verify the `cert-manager` application which has been deployed in the cluster.

Create a list of all `cert-manager` Custom Resource Definitions (CRDs) and save it to `~/resources.yaml`.
make sure `kubectl`'s default output format and use `kubectl` to list CRD's.
Do not set an output format.
Failure to do so will result in a reduced score.

Using `kubectl`, extract the documentation for the `subject` specification field of the `Certificate` Custom Resource and save it to `~/subject.yaml`.
You may use any output format that `kubectl` supports.

-----

#### Prereqs

  * `cert-manager` deployed in the cluster.
  * `kubectl` configured with access to the cluster.

-----

#### Solution Steps

1.  **List `cert-manager` CRDs and save to `~/resources.yaml`:**
    To list all CRDs and filter for `cert-manager` related ones (often identified by their group `cert-manager.io` or `acme.cert-manager.io`), then save them in the default output format.

    ```bash
    kubectl get crds | grep -i "cert-manager.io" >  ~/resources.yaml  
    # OR
    kubectl get crds | grep -i "cert-manager" | awk '{print 1$}' | xargs -I{} kubectl get crd {} -o yaml >> ~/resources.yaml  
    ```

2.  **Extract documentation for `Certificate.spec.subject` and save to `~/subject.yaml`:**
    This requires using `kubectl explain`.

    ```bash
    kubectl explain certificate.spec.subject > ~/subject.yaml
    ```

-----

### Q-13: Adjust WordPress Pod Resource Requests

**📝 Question:**
A WordPress application with 3 replicas in the `relative-fawn` namespace consists of: `cpu 1 memory 2015360ki`.

Adjust all Pod resource requests as follows:

  * Divide node resources evenly across all 3 pods.
  * Give each Pod a fair share of CPU and memory.
  * Add enough overhead to keep the node stable.
  * Use the exact same requests for both containers and init containers.
  * You are not required to change any resource limits.

It may help to temporarily scale the WordPress Deployment to 0 replicas while updating the resource requests.

After updates, confirm:

  * WordPress keeps 3 replicas.
  * All Pods are running and ready.

-----

#### Prereqs

  * WordPress Deployment in the `relative-fawn` namespace with 3 replicas.
  * Node capacity: CPU 1 core, Memory 2015360ki.
  * An understanding of resource requests and limits in Kubernetes.

#### Calculation Breakdown

  * **Reserve Overhead:** Let's reserve about 15% for node/system overhead:

      * CPU overhead: $1 \\text{ core} \\times 0.15 = 0.15 \\text{ cores}$
      * Memory overhead: $2015360 \\text{Ki} \\times 0.15 = 302304 \\text{Ki} \\approx 300000 \\text{Ki}$

  * **Usable for Pods:**

      * CPU: $1 - 0.15 = 0.85 \\text{ cores}$
      * Memory: $2015360 \\text{Ki} - 300000 \\text{Ki} = 1715360 \\text{Ki}$

  * **Divide by 3 Pods:**

      * CPU per Pod: $0.85 \\text{ cores} / 3 \\approx 0.283 \\text{ cores} \\rightarrow \\text{round to } 250\\text{m}$ (conservative & stable)
      * Memory per Pod: $1715360 \\text{Ki} / 3 \\approx 571786 \\text{Ki} \\rightarrow \\text{round to } 570000\\text{Ki}$

#### Solution Steps

1.  **Temporarily scale down the WordPress Deployment (Optional but Recommended):**
    This helps prevent disruptions during resource update and ensures new pods pick up the changes cleanly.

    ```bash
    kubectl scale deployment wordpress -n relative-fawn --replicas=0
    ```

2.  **Edit the WordPress Deployment:**
    Modify the Deployment to add `resources.requests` for both containers and any init containers.

    ```bash
    kubectl edit deployment wordpress -n relative-fawn
    ```

    Add the `resources` section under `spec.template.spec.containers` and `spec.template.spec.initContainers` (if any).

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: wordpress
      namespace: relative-fawn
    spec:
      template:
        spec:
          containers:
          - name: wordpress-container # Replace with actual container name
            image: wordpress:latest # Use your actual image
            resources:
              requests:
                cpu: "250m"
                memory: "570000Ki"
          # If there are initContainers, add the same resources section here:
          # initContainers:
          # - name: init-wordpress # Replace with actual init container name
          #   image: busybox # Use your actual image
          #   resources:
          #     requests:
          #       cpu: "250m"
          #       memory: "570000Ki"
    ```

3.  **Scale up the WordPress Deployment to 3 replicas:**

    ```bash
    kubectl scale deployment wordpress -n relative-fawn --replicas=3
    ```

#### Verification Steps

1.  **Confirm WordPress has 3 replicas:**

    ```bash
    kubectl get deploy wordpress -n relative-fawn
    ```

    Ensure `READY` column shows `3/3`.

2.  **Verify all Pods are running and ready:**

    ```bash
    kubectl get pods -n relative-fawn
    ```

    All pods should be in `Running` status with `READY` column showing `1/1` (or `X/X` if multiple containers).

3.  **Inspect Pods to confirm resource requests:**
    Describe one of the WordPress pods and check the `Requests` section.

    ```bash
    kubectl describe pod <wordpress-pod-name> -n relative-fawn
    ```

    Look for:

    ```
      Requests:
        cpu:        250m
        memory:     570000Ki
    ```

-----

### Q-14: Re-establish MariaDB Deployment with Persistent Storage

**📝 Question:**  
A user accidentally deleted the MariaDB Deployment in the `mariadb` namespace, which was configured with persistent storage. Your responsibility is to re-establish the Deployment while ensuring data is preserved by reusing the available PersistentVolume.

**Task:**
A PersistentVolume (PV) named `mariadb-pv` already exists and is retained for reuse. only one pv exist.

1.  Create a **PersistentVolumeClaim (PVC)** named `mariadb` in the `mariadb` NS with the spec: `Accessmode: ReadWriteOnce` and `Storage: 250Mi`.

2.  Edit the MariaDB Deployment file located at `~/mariadb-deploy.yaml` to use the PVC created in the previous step.

3.  Apply the updated Deployment file to the cluster.

4.  Ensure the MariaDB Deployment is running and Stable.

-----

#### Prereqs

  * Existing PersistentVolume: `mariadb-pv` (ensure it exists and its `reclaimPolicy` allows reuse, typically `Retain` for this scenario).
      * **`mariadb-pv` YAML for reference:**
        ```yaml
        apiVersion: v1
        kind: PersistentVolume
        metadata:
          name: mariadb-pv
        spec:
          storageClassName: local-path
          capacity:
            storage: 250Mi
          accessModes:
            - ReadWriteOnce
          persistentVolumeReclaimPolicy: Retain # Important for data preservation
          hostPath:
            path: "/mnt/data/mariadb" # Example host path
        ```
  * MariaDB Deployment file: `~/mariadb-deploy.yaml` (needs to be created or modified)
  * Namespace: `mariadb` (create if it doesn't exist)

-----

#### Solution Steps

1.  **Create the `mariadb` Namespace (if it doesn't exist):**

    ```bash
    kubectl create ns mariadb
    ```

2.  **Create the PersistentVolumeClaim (PVC):**
    Create a file named `mariadb-pvc.yaml` (or similar) with the following content:

    ```yaml
    # mariadb-pvc.yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: mariadb
      namespace: mariadb
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 250Mi
      volumeName: mariadb-pv # Explicitly bind to the existing PV
    ```

    Apply the PVC:

    ```bash
    kubectl apply -f mariadb-pvc.yaml
    ```

    Verify it's `Bound`:

    ```bash
    kubectl get pvc -n mariadb
    ```

3.  **Prepare the MariaDB Deployment File (`~/mariadb-deploy.yaml`):**
    Create or ensure your `~/mariadb-deploy.yaml` file exists with the MariaDB Deployment definition. It should mount the PVC. An example structure:

    ```yaml
    # ~/mariadb-deploy.yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: mariadb-deployment
      namespace: mariadb
      labels:
        app: mariadb
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: mariadb
      template:
        metadata:
          labels:
            app: mariadb
        spec:
          containers:
            - name: mariadb
              image: mariadb:10.5 # Use an appropriate image version
              env:
                - name: MYSQL_ROOT_PASSWORD
                  value: your_secure_password # Replace with a real password or secret reference
              ports:
                - containerPort: 3306
              volumeMounts:
                - name: mariadb-persistent-storage
                  mountPath: /var/lib/mysql # Default data directory for MariaDB
          volumes:
            - name: mariadb-persistent-storage
              persistentVolumeClaim:
                claimName: mariadb # Reference the PVC created above
    ```

4.  **Update the Deployment (Choose ONE of the methods below):**

    **Method A: Edit the Deployment YAML file directly and re-apply**
    This is the primary method for re-establishing a deleted Deployment.

    ```bash
    # Make sure you've modified ~/mariadb-deploy.yaml as shown in step 3
    kubectl apply -f ~/mariadb-deploy.yaml
    ```

    **Method B: Patch an existing Deployment (for modifying an already deployed resource)**
    *This method is for updating an existing Deployment, not for re-creating one that was deleted. If the Deployment was deleted, use Method A.*

    To add/update a volume and its mount, you can use a strategic merge patch. This example assumes `mariadb-deployment` already exists and you want to ensure it has the `mariadb-persistent-storage` volume and mount.

    ```bash
    kubectl patch deployment mariadb-deployment -n mariadb --patch '
    spec:
      template:
        spec:
          volumes:
            - name: mariadb-persistent-storage
              persistentVolumeClaim:
                claimName: mariadb
          containers:
            - name: mariadb
              volumeMounts:
                - name: mariadb-persistent-storage
                  mountPath: /var/lib/mysql
    '
    ```

    *Note: The `patch` command's exact YAML structure depends on whether you are adding new elements to an array, modifying existing ones, or replacing them. For arrays like `volumes` and `volumeMounts`, if the `name` field uniquely identifies an entry, strategic merge patch will try to merge based on that name. If the elements are truly new, they will be appended.*

-----

#### Verification Steps

1.  **Check PVC Status:**
    Ensure the PVC is `Bound` to the PV.

    ```bash
    kubectl get pvc -n mariadb
    ```

2.  **Check Deployment Status:**
    Verify the MariaDB Deployment is running and has the correct number of ready replicas.

    ```bash
    kubectl get deploy -n mariadb
    ```

3.  **Check Pod Status:**
    Ensure the MariaDB pod is `Running`.

    ```bash
    kubectl get po -n mariadb
    ```

4.  **Verify Volume Mount (Optional but good practice):**
    Describe the pod to ensure the volume is correctly mounted.

    ```bash
    kubectl describe po -l app=mariadb -n mariadb
    ```

    Look for `Volume Mounts` and `Volumes` sections.

-----

### Q-15: Prepare Linux System for Kubernetes (cri-dockerd & sysctl)

**📝 Question:**
Prepare a Linux system for Kubernetes. Docker is already installed, but you need to configure it for `kubeadm`.

**Task:**
Complete these tasks to prepare the system for Kubernetes:

  * **Set up cri-dockerd:**
      * Install the Debian package `~/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb`
      * Debian packages are installed using `dpkg`.
      * Enable and start the `cri-dockerd` service
  * **Configure these system parameters (sysctl):**
      * `Set net.bridge.bridge-nf-call-iptables to 1`
      * `Set net.ipv6.conf.all.forwarding to 1`
      * `Set net.ipv4.ip_forward to 1`
      * `Set net.netfilter.nf_conntrack_max to 131072`

-----

#### Prereqs

  * A Linux system (e.g., Ubuntu Jammy) with Docker already installed.
  * The `cri-dockerd` Debian package (`cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb`) located in the home directory (`~`).
  * Root/sudo access on the system.

#### Solution Steps

1.  **Install `cri-dockerd` Debian package:**
    Navigate to your home directory (if not already there) and install the Debian package using `dpkg`.

    ```bash
    cd ~
    sudo dpkg -i cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb
    ```

2.  **Enable and Start `cri-dockerd` service:**
    After installation, ensure the `cri-dockerd` service is enabled to start on boot and is currently running.

    ```bash
    sudo systemctl enable cri-docker.service
    sudo systemctl enable --now cri-docker.socket # Enable and start the socket
    sudo systemctl start cri-docker.service
    ```

3.  **Configure `sysctl` parameters:**
    These parameters are crucial for Kubernetes networking (e.g., Pod-to-Pod communication and Service routing) and need to persist across reboots.

    Create a configuration file (e.g., `k8s.conf`) in `/etc/sysctl.d/` and add the specified parameters.

    ```bash
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-iptables = 1
    net.ipv6.conf.all.forwarding = 1
    net.ipv4.ip_forward = 1
    net.netfilter.nf_conntrack_max = 131072
    EOF
    ```

4.  **Apply `sysctl` parameters:**
    Apply the changes immediately without requiring a system reboot.

    ```bash
    sudo sysctl --system
    ```

#### Verification Steps

1.  **Verify `cri-dockerd` service status:**
    Check if `cri-dockerd` service is active and running.

    ```bash
    sudo systemctl status cri-docker.service
    sudo systemctl status cri-docker.socket
    ```

    Both should show `active (running)`.

2.  **Verify `sysctl` parameters:**
    Confirm that each parameter has been set correctly.

    ```bash
    sysctl net.bridge.bridge-nf-call-iptables
    sysctl net.ipv6.conf.all.forwarding
    sysctl net.ipv4.ip_forward
    sysctl net.netfilter.nf_conntrack_max
    ```

    Expected output for each should be `... = 1` or `... = 131072`.

-----

### Q-16: Fix Broken Kubeadm Cluster Migration

**📝 Question:**  
A `kubeadm` provisioned cluster was migrated to a new machine. Requires configuration changes to run successfully.

**Task:**
We need to fix a **single-node cluster** that got broken during machine migration.
Identify the broken cluster **components** and investigate what caused to break those components.
The decommissioned cluster used an **external etcd server**.
Next, fix the configuration of all **broken cluster components**.
Ensure to **restart** all necessary services and components for changes to take effect.
Finally, ensure the cluster, single node and all pods are Ready.

#### Clues / Initial State

  * `kubectl get po` shows "The connection to the server 172.30.1.2:6443 was refused - did you specify the right host or port?"
  * `ls /etc/kubernetes/manifests/` shows `etcd.yaml kube-apiserver.yaml kube-controller-manager.yaml kube-scheduler.yaml`
  * `kube-apiserver.yaml` has `--etcd-servers=https://128.0.0.1:2379` (IP address `128.0.0.1` in the kube-api server file, suggesting this might be incorrect).

#### Common Kubernetes Component Ports

  * **kube-apiserver:** 6443 (default secure port)
  * **kubelet:** 10250 (default HTTPS port for API), 10255 (read-only HTTP port, deprecated in newer versions), 10248 (healthz endpoint)
  * **kube-scheduler:** 10259 (HTTPS port, for metrics/health)
  * **kube-controller-manager:** 10257 (HTTPS port, for metrics/health)
  * **etcd:** 2379 (client port), 2380 (peer port)
      * **To validate/test etcd health (e.g., for external etcd):**
        ```bash
        curl -k https://<ETCD_SERVER_IP>:2379/health
        # You might need to add --cacert, --cert, --key for secure clusters
        ```

#### Solution Steps

1.  **Identify the Problem:**
    The error "connection refused" to the API server indicates the `kube-apiserver` is not running or not accessible at the specified address/port. Since the cluster uses an external etcd, a common issue during migration is that the API server's etcd endpoint is still pointing to the old (or incorrect) etcd server IP. The `kube-apiserver.yaml` showing `etcd-servers=https://128.0.0.1:2379` while the API server's advertise address is `172.30.1.2` strongly suggests an etcd connectivity issue. The `128.0.0.1` IP is likely the broken part of the configuration.

2.  **Edit `kube-apiserver.yaml`:**
    Modify the `kube-apiserver.yaml` manifest to correct the `--etcd-servers` address. This needs to point to the correct IP address of the *new* external etcd server.

    ```bash
    vi /etc/kubernetes/manifests/kube-apiserver.yaml
    ```

    Change the line:

    ```
    - --etcd-servers=[https://128.0.0.1:2379](https://128.0.0.1:2379) #
    ```

    To the correct IP of your external etcd server. For example, if the new etcd server IP is `172.30.1.2` (matching the advertise address of the API server itself, assuming it's on the same host or a reachable IP):

    ```
    - --etcd-servers=[https://172.30.1.2:2379](https://172.30.1.2:2379)
    ```

    *(Note: Replace `172.30.1.2` with the actual IP address of the external etcd server in the new environment if it's different).*

3.  **Restart Kubelet:**
    Since the Kubernetes control plane components (like kube-apiserver) are often run as static pods managed by Kubelet, restarting the `kubelet` service will force it to re-read the static pod manifests and restart the API server with the updated configuration.

    ```bash
    sudo systemctl restart kubelet
    ```

#### Verification Steps

1.  **Check Kubelet Status:**

    ```bash
    sudo systemctl status kubelet
    ```

    Ensure it's running without errors.

2.  **Check Control Plane Pods:**
    Wait a few moments for the static pods to restart. Then, verify that the control plane pods (especially `kube-apiserver`) are running.

    ```bash
    kubectl get po -n kube-system
    ```

    You should see `kube-apiserver-*`, `kube-controller-manager-*`, and `kube-scheduler-*` pods in a `Running` state.

3.  **Check Node Status:**
    Verify that the node itself is `Ready`.

    ```bash
    kubectl get nodes
    ```

4.  **Check Cluster Health:**
    Ensure all components are healthy.

    ```bash
    kubectl cluster-info
    kubectl get --raw='/readyz?verbose'
    ```

5.  **List All Pods:**
    Finally, ensure all pods across the cluster are in a Ready state.

    ```bash
    kubectl get pods --all-namespaces
    ```

-----

### Q-17: NetworkPolicy for Frontend-Backend Communication

**📝 Question:**  
We have `frontend` and `backend` Deployments in separate NS (`frontend` and `backend`). They need to communicate.

**Task:**
Analyze: Inspect the frontend and backend Deployments to understand their communication requirements.
Apply: From the NetworkPolicy YAML files in the `~/netpol` folder, choose one to apply. It must:

  * Allow communication between `frontend` and `backend`.
  * Be as restrictive as possible (least permissive).
  * Do not delete or change the existing "deny-all" netpol's.
  * Failure to follow these rules may result in a score reduction or zero.

-----

#### Prereqs

  * Namespaces: `frontend` and `backend` (assume they exist)
  * Deployments: `frontend` pods in `frontend` NS, `backend` pods in `backend` NS (assume they exist and have `app: frontend` and `app: backend` labels respectively).
  * NetworkPolicy files located in `~/netpol/`:
      * [`netpol-1.yaml`](https://www.google.com/search?q=./netpol-1.yaml)
      * [`netpol-2.yaml`](https://www.google.com/search?q=./netpol-2.yaml)
      * [`netpol-3.yaml`](https://www.google.com/search?q=./netpol-3.yaml)

-----

#### Analysis of NetworkPolicies:

  * **`netpol-1.yaml` (N1 - `allow-all-from-frontend-to-backend`)**:

      * Targets `app: backend` pods in `backend` namespace.
      * Allows ingress from *any* pod in the `frontend` namespace (selected by `kubernetes.io/metadata.name: frontend`).
      * Allows traffic on TCP port 80.
      * *Permissive:* Allows any pod from `frontend` NS to connect.

  * **`netpol-2.yaml` (N2 - `allow-frontend-to-backend`)**:

      * Targets `app: backend` pods in `backend` namespace.
      * Allows ingress from pods in the `frontend` namespace *AND specifically* with the label `app: frontend` (selected by `namespaceSelector` and `podSelector`).
      * Allows traffic on TCP port 80.
      * *Most Restrictive (Least Permissive):* Narrows down the source pods to only those with `app: frontend` label within the `frontend` namespace. This is more restrictive than `netpol-1.yaml`.

  * **`netpol-3.yaml` (N3 - `allow-nothing`)**:

      * Targets `app: backend` pods in `backend` namespace.
      * Has `ingress: []` (empty ingress rules), effectively denying all ingress traffic to the targeted pods.
      * *Too Restrictive:* This would prevent communication.

**Conclusion:** `netpol-2.yaml` is the correct policy to apply as it allows communication while being the most restrictive among the given options by specifying both namespace and pod labels for the source.

-----

#### Solution Steps

1.  **Apply the correct NetworkPolicy:**
    Based on the analysis, `netpol-2.yaml` is the most restrictive policy that allows communication.
    ```bash
    kubectl apply -f ./netpol-2.yaml
    ```

-----

#### Verification Steps

1.  **Check NetworkPolicy Status:**
    Verify the NetworkPolicy has been created.

    ```bash
    kubectl get netpol -n backend
    kubectl describe netpol allow-frontend-to-backend -n backend
    ```

2.  **Test Communication:**
    From a pod in the `frontend` namespace (specifically one with `app: frontend` label if applicable), attempt to `curl` the `backend` service (assuming a service exposes the backend deployment).

    ```bash
    # Assuming you have a frontend pod named 'frontend-pod-xxx' and a backend service 'backend-service'
    kubectl exec -it <frontend-pod-name> -n frontend -- curl -s -m 5 backend-service.backend.svc.cluster.local:80
    ```

    The command should successfully return a response from the backend, indicating communication is allowed. If it times out or gets a "connection refused" error, the policy might not be correctly applied or there are other underlying issues.

-----

```
Author: Khaleel Ahmad  
Date: CKA 2025 Revision
```