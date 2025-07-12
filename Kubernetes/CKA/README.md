## 📚 CKA 2025 Practice Questions & Solutions



### Q-01: Update ConfigMap with FQDN Values

**Goal:** Update a ConfigMap with internal FQDNs.

#### FQDNs to Remember

* Service: `service.namespace.svc.cluster.local`
* Headless Pod: `pod.headless.namespace.svc.cluster.local`
* IP Pod: `ip-with-dashes.namespace.pod.cluster.local`

#### Steps

```bash
kubectl get cm <name> -n <ns> -o yaml > configmap.yaml
# Edit and add FQDNs
kubectl apply -f configmap.yaml
kubectl rollout restart deployment/<name> -n <ns>
kubectl exec <pod> -- nslookup <fqdn>
```

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
```

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

### Q-03: HorizontalPodAutoscaler (HPA)

#### YAML (hpa.yaml)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: <hpa-name>
  namespace: <namespace>
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: <target-deployment>
  minReplicas: 1
  maxReplicas: 4
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 30
```

#### Apply & Verify

```bash
kubectl apply -f hpa.yaml
kubectl get hpa -n <ns>
kubectl describe hpa <name> -n <ns>
```

---

### Q-04: WordPress Resources (Direct Values)

```yaml
resources:
  requests:
    cpu: "250m"
    memory: "500Mi"
  limits:
    cpu: "300m"
    memory: "600Mi"
```

#### Steps

```bash
kubectl get deployment wordpress -n <ns> -o yaml > wordpress-deployment.yaml
# Edit containers[*].resources section
kubectl apply -f wordpress-deployment.yaml
kubectl get pods -n <ns>
```

---

### Q-05: CNI Installation (Flannel)

```bash
kubectl apply -f https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yaml

# Verify
kubectl get pods -n kube-system -l app=flannel --watch
kubectl get nodes -o wide
```

---

### Q-06: CNI Installation (Calico with NetworkPolicy)

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/custom-resources.yaml

# Verify
kubectl get pods -n calico-system --watch
kubectl get nodes -o wide
```

---

## ⚡ Additional Insights

### kubectl patch vs edit

* Use `edit` for quick interactive updates.
* Use `patch` for automation and precise JSON/YAML changes.

### Vertical Pod Autoscaler (VPA)

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: <name>
  updatePolicy:
    updateMode: "Auto"
```

### Helm Tips

```bash
helm list
helm status <release-name> -n <ns>
helm get metadata <release-name> -n <ns>
helm repo update
helm search repo <name>
```

---

## 👍 Final Words

Good luck, Khaleel! You've put in the work and covered a lot of ground. Stay calm, read each question carefully, and trust your practice. You've got this!

---

```
Author: Khaleel Ahmad  
Date: CKA 2025 Revision
```
