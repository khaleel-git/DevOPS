Okay, I've received the new question and the associated images. Here's how I'll update your `README.md` file, incorporating Q-01 with its question, context, solution steps, and verification:

````markdown
## 📚 CKA 2025 Practice Questions & Solutions 

Click here for all [Questions](https://docs.google.com/document/d/16CwiwhEtuisL5TaIL3rR0AJQY1BOI70yVVwuOO55tJM/edit?usp=sharing)

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

4.  Finally, delete the existing Ingress resource named `web`.

-----

#### Prereqs

  * TLS Secret: `web-tls`
  * Backend Service: `nginx-service:80`
  * GatewayClass: `nginx-class`

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

```
Author: Khaleel Ahmad  
Date: CKA 2025 Revision
```