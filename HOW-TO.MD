# How to add user to the sftp server

## Creating keys

conf/pub-keys -> folder for public keys e.g. user2.pub
```
ssh-keygen
``` 
this will create public/private key pair for new users

On running this command it will ask for name to store the file, give the user’s name
it will then ask for passphrase, here if you want you can give a password for the private key or just leave it empty and then hit enter again

## Adding keys
Now we will create a SECRET with the public key in the k8s cluster

for this, go to the public key folder and create like this:
```
kubectl create secret -n sftp user2 –from-file=./user2.pub
```

or you can use the script provided in conf directory

## Adding more users

Open the yaml file and add entries for this user like this,
### Adding secret as volume 
`Public key of the user stoted in k8s as a secret`
```
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: sftp
spec:
    .
    .
    .
    spec:
      volumes:
      - name: user2
        secret:
          secretName: user2
```
### mounting volume to .ssh of user
`The secret from above nounted to the .ssh directory of the user`
```
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: sftp
spec:
    .
    .
    .
    spec:          
      containers:
        - name: sftp
          volumeMounts:
            - mountPath: /home/user2/.ssh/keys
              name: user2
              readOnly: true              
```
### Adding users in users.conf

"user2::1001:100:incoming,outgoing"

## Applying Changes

kubectl apply -f <deployment file name>
