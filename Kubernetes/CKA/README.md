Here is your cleaned-up and focused `README.md` containing **only the Gateway API migration question**, while preserving the header and the doc link:

````markdown
## 📚 CKA 2025 Practice Questions & Solutions

[Questions](https://docs.google.com/document/d/16CwiwhEtuisL5TaIL3rR0AJQY1BOI70yVVwuOO55tJM/edit?usp=sharing)

---

### Q-02: Ingress to Gateway API Migration

**Goal:** Migrate from Ingress to Gateway API

#### Prereqs

* TLS Secret: `web-tls`
* Backend Service: `nginx-service:80`
* GatewayClass: `nginx-class`

#### Gateway YAML (web-gateway.yaml)

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

#### HTTPRoute YAML (web-route.yaml)

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

#### Verification

```bash
kubectl get gateway web-gateway -n alpha
kubectl describe httproute web-route -n alpha
```

#### DNS Resolution

```bash
# Map in /etc/hosts:
<NODE_IP> gateway.web.k8s.local

# Test:
curl -k https://gateway.web.k8s.local:<NodePort>
```

```bash
kubectl delete ingress web -n alpha  # ONLY if above test passes
```

---

```
Author: Khaleel Ahmad  
Date: CKA 2025 Revision
```