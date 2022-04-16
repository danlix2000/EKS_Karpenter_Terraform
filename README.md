# AWS EKS and Karpenter Cluster Autoscaler Terraform

Create AWS EKS Cluster & install Karpenter Cluster Autoscaler using Terraform and verify Autoscaler 

**EKS environment provisioning - Terraform [Terraform Cloud - CLI-driven workflow]**

**Terraform Setup**

Clone this Repository 

Modify terraform backend file with your Terraform cloud details
File name =  `config.remote.tfbackend`

you will find similar code as follows
```
workspaces { name = "xen-terra" }
hostname     = "app.terraform.io"
organization = "danlix-env"
```


Add below variables to terraform cloud workspace env variables

- AWS_ACCESS_KEY_ID 

- AWS_SECRET_ACCESS_KEY



add your ssh public key to `sshkey.tf` file . Then you can ssh to EKS nodes using your key

you will have to change region in variables.tf file ( Here I used us-east-1 ) 


**Run below commands to env setup**
```
terraform login # use terraform cloud API token to authenticate

terraform init -backend-config=config.remote.tfbackend

terraform validate

terraform plan

terraform apply -auto-approve
```


**Connet to your EKS cluster**
```
aws eks --region us-east-1 update-kubeconfig --name karp-stg-eks
```

**Apply karpenter provisioner**

apply karpenter_provisioner.yml from above repository

```
kubectl apply -f karpenter_provisioner.yml
```

**Verify Karpenter cluster autoscaler**
apply sample app from above repository

```
kubectl apply -f  sampleapp.yml
```

Scale up app and check new nodes will add
```
kubectl scale --replicas=40 deploy karp-test-deployment
```
Check Karpenter logs
```
kubectl logs -f -n karpenter -l app.kubernetes.io/name=karpenter -c controller
```
Verify Nodes
new node/nodes will be listed 
```
kubectl get nodes -o wide
```
Scale down app and check new node will Terminate
```
kubectl scale --replicas=1 deploy karp-test-deployment
```

Verify Nodes
```
kubectl get nodes -o wide
```

Destroy Environment 
```
terraform destroy -auto-approve 
```