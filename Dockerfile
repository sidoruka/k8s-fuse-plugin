FROM debian:stretch-slim

COPY k8s-fuse-plugin-linux-amd64 /k8s-fuse-plugin
ENTRYPOINT ["/k8s-fuse-plugin"]
