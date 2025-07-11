## Build

### Install Go
```
cd /usr/local
wget https://go.dev/dl/go1.24.5.linux-amd64.tar.gz
tar -zxvf go1.24.5.linux-amd64.tar.gz
rm -f go1.24.5.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
```

### Build Docker
```
cd /tmp
git clone https://github.com/sidoruka/k8s-fuse-plugin
cd k8s-fuse-plugin
TARGET=amd64 GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o k8s-fuse-plugin-linux-amd64
docker build . -t quay.io/lifescience/cloud-pipeline:k8s-fuse-plugin-0.17
docker push quay.io/lifescience/cloud-pipeline:k8s-fuse-plugin-0.17
```

### Install
```
kubectl label no <node_name> CP_ENABLE_FUSE_DEVICE=true
git clone https://github.com/sidoruka/k8s-fuse-plugin
kubectl apply -f k8s-fuse-plugin/manifests/k8s-fuse-plugin.yml
```

### Example pod
```
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: fuse-pod
spec:
  restartPolicy: Never
  containers:
    - name: cuda-container
      image: rockylinux:8.7
      command: ["sleep", "infinity"]
      resources:
        limits:
          nvidia.com/gpu: 1
          device/fuse: 1
      securityContext:
        capabilities:
          add: ["SYS_ADMIN"]
  tolerations:
  - key: nvidia.com/gpu
    operator: Exists
    effect: NoSchedule
EOF
```
