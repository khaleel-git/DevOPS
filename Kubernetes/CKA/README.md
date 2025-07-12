## 📚 CKA 2025 Practice Questions & Solutions 

Click here for all [Questions](https://docs.google.com/document/d/16CwiwhEtuisL5TaIL3rR0AJQY1BOI70yVVwuOO55tJM/edit?usp=sharing)

---

### Table of Contents

* [Q-01: NGINX TLSv1.3 Only Configuration](#q-01-nginx-tlsv13-only-configuration)
* [Q-02: Ingress to Gateway API Migration](#q-02-ingress-to-gateway-api-migration)
* [Q-04: Create Ingress Resource for Echo Server](#q-04-create-ingress-resource-for-echo-server)
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
    curl --tls-max 1.2 [https://web.k8s.local](https://web.k8s.local)
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
       curl [https://gateway.web.k8s.local](https://gateway.web.k8s.local)
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

### Q-04: Create Ingress Resource for Echo Server

**📝 Question:**
Create a new Ingress resource `echo` in the `echo-sound` namespace. Exposing Service `echoserver-service` on `http://example.org/echo` using Service port `8080`.

The availability of Service `echoserver-service` can be checked using the following command, which should return `200`:
`[candidate@cka2025]$ curl -o /dev/null -s -w "%{http_code}\n" http://example.org/echo`

#### Prereqs

  * Namespace: `echo-sound` (create if it doesn't exist).
  * Service: `echoserver-service` listening on port `8080` in the `echo-sound` namespace (assume it exists and routes to an echo application).
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
    curl -o /dev/null -s -w "%{http_code}\n" [http://example.org/echo](http://example.org/echo)
    ```

    *Note: If `example.org` does not resolve, you might need to add an entry to your `/etc/hosts` file pointing `example.org` to the IP address of your Ingress Controller (e.g., a NodePort IP or LoadBalancer IP).*

-----

### Q-14: Re-establish MariaDB Deployment with Persistent Storage

**📝 Question:**  
A user accidentally deleted the MariaDB Deployment in the `mariadb` namespace, which was configured with persistent storage. Your responsibility is to re-establish the Deployment while ensuring data is preserved by reusing the available PersistentVolume.

**Task:**
A PersistentVolume (PV) named `mariadb-pv` already exists and is retained for reuse. Only one PV exist.

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