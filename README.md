# SFTP Server
SFTP Server designed to run on a k8s cluster
This is based upon [atmoz/sftp](https://github.com/atmoz/sftp) project.


# Setup Instructions
## Dependancies
For testing, you will need to have Minikube and Docker installed.

## Configuration
You can configure SFTP user accounts by adjusting what's in `etc/sftp/users.conf` and `etc/sftp.d/mount_user_directories.sh`.

When adding a new user, add a new line into `etc/sftp/users.conf`:
```
username:password:uid:gid:directory
```
Where `uid` is a number (e.g. 1003) and `gid` is a number (e.g. 1003).

:warning: User passwords are committed to this repo as a demo. Not the best to commit them in practice.


## Development Setup for Testing
Follow these steps to run this locally with `minikube`.

### 1. Start minikube:
```
minikube start
```

### 2. Setup Secrets and Config Mappings
Then, you can run these commands to put these files on the cluster as secrets:
```
kubectl create secret generic users --from-file=users.conf=./etc/sftp/users.conf
kubectl create secret -n sftp user1 –from-file=./user1.pub
```
* **users** - Code for maintaining users credentials for SFTP access
* **public keys** - public Key for sftp users

###  Creating secrets for Public keys 
```
kubectl create secret -n sftp user1 –from-file=./user1.pub
```
Or you can create multiple secrets using the script create_keys.sh in the conf directory
```
./create_keys.sh create <dir name>
./create_keys.sh delete <dir name>
./create_keys.sh create ./conf/pub-keys
```    

### 3. Deploy the SFTP server to Kubernetes:
```
kubectl apply -f ./yaml
```
### 4. Get the test IP and port:
```
minikube service sftp --url
```
This will give you the IP and NodePort port.

:information_source: We use NodePort 30022 for SFTP.


### To Do
- [ ] Add Helm chart

### 7. Confirm you can SFTP using the usernames and password you setup in `etc/sftp*` with `sftp` utility:
```
$ sftp -i ./key  -P 30022 myUser@10.142.0.2
$ sftp -P 30022 username@192.168.99.100
username@192.168.99.100's password:
sftp> pwd
/directory
```