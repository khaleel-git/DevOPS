## 📚 CKA 2025 Practice Questions & Solutions 

Click here for all [Questions](https://docs.google.com/document/d/16CwiwhEtuisL5TaIL3rR0AJQY1BOI70yVVwuOO55tJM/edit?usp=sharing)

---

### Table of Contents

* [Q-01: NGINX TLSv1.3 Only Configuration](#q-01-nginx-tlsv13-only-configuration)
* [Q-02: Ingress to Gateway API Migration](#q-02-ingress-to-gateway-api-migration)
* [Q-16: Fix Broken Kubeadm Cluster Migration](#q-16-fix-broken-kubeadm-cluster-migration)

---

### Q-01: NGINX TLSv1.3 Only Configuration

**📝 Question:**  
An NGINX Deployment named `nginx-static` is running in the `nginx-static` NS. It is configured using a `CfgMap` named `nginx-config`. Update the `nginx-config` ConfigMap to allow only TLSv1.3 connections. Re-create, restart, or scale resources as necessary.

By using the command to test the changes:
`[candidate@cka2025]$ curl --tls-max 1.2 https://web.k8s.local`

As TLSv1.2 should not be allowed anymore, the command should fail.

---
#### Prereqs

* NGINX Deployment: `nginx-static` in namespace `nginx-static`
* ConfigMap: `nginx-config` in namespace `nginx-static`
* DNS resolution for `web.k8s.local` (e.g., via `/etc/hosts` or an Ingress/Gateway)

---

#### Solution Steps

1.  **Edit the `nginx-config` ConfigMap:**
    Modify the `nginx.conf` data within the ConfigMap to set `ssl_protocols TLSv1.3;`.
    
    ```bash
    kubectl edit configmap nginx-config -n nginx-static
    ```

    Locate the `ssl_protocols` line and change it from `ssl_protocols TLSv1.3 TLSv1.2;` (or similar) to:
    ```nginx
    ssl_protocols TLSv1.3;
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

---

#### Verification Steps

1.  **Check Pod Status (Optional but good practice):**
    Verify that the new pods are running after the restart.
    ```bash
    kubectl get po -n nginx-static
    ```

2.  **Test TLSv1.2 Connection:**
    This command should *fail* because TLSv1.2 is no longer allowed.
    ```bash
    curl --tls-max 1.2 [https://web.k8s.local](https://web.k8s.local)
    ```
    Expected output will show an error like "curl: (35) error:1409442E:SSL routines:ssl3_read_bytes:tlsv1 alert protocol version" or similar, indicating a TLS protocol mismatch.

---

### Q-02: Ingress to Gateway API Migration

**📝 Question:**  
Migrate an existing web application from Ingress to Gateway API.  
We must maintain **HTTPS access**.

A `GatewayClass` named `nginx` is installed in the cluster.

1. First, create a **Gateway** named `web-gateway` with hostname `gateway.web.k8s.local` that maintains the existing **TLS** and listener configuration from the existing Ingress resource named `web`.

2. Next, create an **HTTPRoute** named `web-route` with hostname `gateway.web.k8s.local` that maintains the existing routing rules from the current Ingress resource named `web`.

3. You can test your Gateway API configuration with the following command:
```bash
   curl [https://gateway.web.k8s.local](https://gateway.web.k8s.local)
````

4.   Finally, delete the existing Ingress resource named `web`.

-----

#### Prereqs

  \* TLS Secret: `web-tls`
  \* Backend Service: `nginx-service:80`
  \* GatewayClass: `nginx-class`

-----

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
```

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

-----

#### Clues / Initial State

  \* `kubectl get po` shows "The connection to the server 172.30.1.2:6443 was refused - did you specify the right host or port?"
  \* `ls /etc/kubernetes/manifests/` shows `etcd.yaml kube-apiserver.yaml kube-controller-manager.yaml kube-scheduler.yaml`
  \* `kube-apiserver.yaml` has `--etcd-servers=https://128.0.0.1:2379` (IP address `128.0.0.1` in the kube-api server file, suggesting this might be incorrect).

-----

#### Common Kubernetes Component Ports

  \* **kube-apiserver:** 6443 (default secure port)
  \* **kubelet:** 10250 (default HTTPS port for API), 10255 (read-only HTTP port, deprecated in newer versions), 10248 (healthz endpoint)
  \* **kube-scheduler:** 10259 (HTTPS port, for metrics/health)
  \* **kube-controller-manager:** 10257 (HTTPS port, for metrics/health)
  \* **etcd:** 2379 (client port), 2380 (peer port)

-----

#### Solution Steps

1.  **Identify the Problem:**
        The error "connection refused" to the API server indicates the `kube-apiserver` is not running or not accessible at the specified address/port. Since the cluster uses an external etcd, a common issue during migration is that the API server's etcd endpoint is still pointing to the old (or incorrect) etcd server IP. The `kube-apiserver.yaml` showing `etcd-servers=https://128.0.0.1:2379` while the API server's advertise address is `172.30.1.2` strongly suggests an etcd connectivity issue. The `128.0.0.1` IP is likely the broken part of the configuration.

2.  **Edit `kube-apiserver.yaml`:**
        Modify the `kube-apiserver.yaml` manifest to correct the `--etcd-servers` address. This needs to point to the correct IP address of the *new* external etcd server.

    ` bash     vi /etc/kubernetes/manifests/kube-apiserver.yaml      `

    Change the line:

    `    - --etcd-servers=[https://128.0.0.1:2379](https://128.0.0.1:2379)    `

    To the correct IP of your external etcd server. For example, if the new etcd server IP is `172.30.1.2` (matching the advertise address of the API server itself, assuming it's on the same host or a reachable IP):

    `    - --etcd-servers=[https://172.30.1.2:2379](https://172.30.1.2:2379)    `

    *(Note: Replace `172.30.1.2` with the actual IP address of the external etcd server in the new environment if it's different).*

3.  **Restart Kubelet:**
        Since the Kubernetes control plane components (like kube-apiserver) are often run as static pods managed by Kubelet, restarting the `kubelet` service will force it to re-read the static pod manifests and restart the API server with the updated configuration.

    ` bash     sudo systemctl restart kubelet      `

-----

#### Verification Steps

1.  **Check Kubelet Status:**

    ` bash     sudo systemctl status kubelet      `

    Ensure it's running without errors.

2.  **Check Control Plane Pods:**
        Wait a few moments for the static pods to restart. Then, verify that the control plane pods (especially `kube-apiserver`) are running.

    ` bash     kubectl get po -n kube-system      `

    You should see `kube-apiserver-*`, `kube-controller-manager-*`, and `kube-scheduler-*` pods in a `Running` state.

3.  **Check Node Status:**
        Verify that the node itself is `Ready`.

    ` bash     kubectl get nodes      `

4.  **Check Cluster Health:**
        Ensure all components are healthy.

    ` bash     kubectl cluster-info     kubectl get --raw='/readyz?verbose'      `

5.  **List All Pods:**
        Finally, ensure all pods across the cluster are in a Ready state.

    ` bash     kubectl get pods --all-namespaces      `

-----

```
Author: Khaleel Ahmad  
Date: CKA 2025 Revision
```