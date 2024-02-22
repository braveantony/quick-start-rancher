# Quick-start-rancher

## Download Repo
```
git clone https://github.com/braveantony/quick-start-rancher.git && \
cd quick-start-rancher/ && \
chmod +x ./*.sh
```

## Deploy Rancher v2.8.2 with Podman
```
./podman-install-rancher.sh
```

### ssh into kube-kadm
```
ssh bigred@172.22.1.11 -p 22100
```

### Import Talos Kubernetes Cluster into Rancher

```
./add-cluster.sh
```
