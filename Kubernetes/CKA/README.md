## 📚 CKA 2025 Practice Questions & Solutions 

Click here for all [Questions](https://docs.google.com/document/d/16CwiwhEtuisL5TaIL3rR0AJQY1BOI70yVVwuOO55tJM/edit?usp=sharing)

---

### Q-02: Ingress to Gateway API Migration

**📝 Question (from image):**  
Migrate an existing web application from Ingress to Gateway API.  
We must maintain **HTTPS access**.

A `GatewayClass` named `nginx` is installed in the cluster.

1. First, create a **Gateway** named `web-gateway` with hostname `gateway.web.k8s.local` that maintains the existing **TLS** and listener configuration from the existing Ingress resource named `web`.

2. Next, create an **HTTPRoute** named `web-route` with hostname `gateway.web.k8s.local` that maintains the existing routing rules from the current Ingress resource named `web`.

3. You can test your Gateway API configuration with the following command:
```bash
   curl https://gateway.web.k8s.local
```

4. Finally, delete the existing Ingress resource named `web`.

---
#### Prereqs

* TLS Secret: `web-tls`
* Backend Service: `nginx-service:80`
* GatewayClass: `nginx-class`

---

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
curl -k https://gateway.web.k8s.local:<NodePort>
```

#### Cleanup (ONLY if test is successful)

```bash
kubectl delete ingress web -n alpha
```

---

```
Author: Khaleel Ahmad  
Date: CKA 2025 Revision
```