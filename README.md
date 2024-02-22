# Quick-start-rancher

## 1. ssh 連線至 tkadm

## 2. Download Repo
```
git clone https://github.com/braveantony/quick-start-rancher.git && \
cd quick-start-rancher/ && \
chmod +x ./*.sh
```

## 3. Deploy Rancher v2.8.2 with Podman
```
./podman-install-rancher.sh
```

### 4. ssh kube-kadm
```
ssh bigred@172.22.1.11 -p 22100
```

### 5. Import Talos Kubernetes Cluster into Rancher
```
# Define API Token
API_TOKEN="token-dnxp9:dmls9wcdb7gv4pw5hc9ck5ghp8jp6n4fsnxjrsd49797ddnwl92bmj"

curl -s "https://raw.githubusercontent.com/braveantony/quick-start-rancher/main/add-cluster.sh" | bash -s "$API_TOKEN"
```
