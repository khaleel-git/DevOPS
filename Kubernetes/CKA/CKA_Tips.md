## 📊 General CKA Exam Tips & Best Practices

### kubectl Aliases

* While `k` is often aliased to `kubectl` in exam environments, prefer `kubectl` in scripts to avoid conflicts.

### Namespaces (`-n <namespace>`)

* Always double-check the specified namespace in the question. Misuse leads to zero marks.

### Declarative Management

```bash
kubectl apply -f <file.yaml>            # Apply resources
kubectl get <resource> -o yaml > file.yaml  # Export resource YAML
kubectl edit <resource>/<name>          # Quick edit on the fly
```

### Verification is CRITICAL

```bash
kubectl get <resource> -n <namespace>        # Quick check
kubectl describe <resource>/<name> -n <namespace>  # Deep dive with events
kubectl logs <pod-name> -n <namespace>       # View logs
kubectl exec -it <pod-name> -n <namespace> -- <cmd>  # Debug inside pod
```

### Pod Restarts

```bash
kubectl rollout restart deployment/<name> -n <namespace>
kubectl rollout status deployment/<name> -n <namespace>
```

### Other Tips

* Avoid `--force` unless instructed
* Time management: Read the full question, prioritize, move on if blocked

---