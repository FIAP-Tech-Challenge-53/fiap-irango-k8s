# Fiap iRango K8s
![terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![aws](https://img.shields.io/badge/Amazon_AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![eks](https://img.shields.io/badge/Amazon_EKS-FF9900?style=for-the-badge&logo=amazoneks&logoColor=white)
![kubernetes](https://shields.io/badge/Kubernetes-326CE5?logo=Kubernetes&logoColor=FFF&style=flat-square)

## Architecture Diagram:
![Architecture diagram](./docs/fiap-irango-k8s.png)
## Cluster Diagram:
![Cluster diagram](./docs/fiap-irango-k8s-cluster.png)

## Dependencies
- [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
- [Kubernetes](https://kubernetes.io/)
- Make
  - [Windows](https://gnuwin32.sourceforge.net/packages/make.htm)
  - Linux:
  ```bash
  sudo apt update
  sudo apt install make
  ```

## Instructions to run
Before all, you need set AWS credentials and Application ENVs using:
```bash
export AWS_ACCESS_KEY_ID=xxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxx

# Docker image of fiap-irango-api service
export IMAGE_URI=xxxxxx

# Docker image of fiap-irango-payment-api service
export IMAGE_URI_PAYMENT=xxxxxx

# Docker image of fiap-irango-cook-api service
export IMAGE_URI_COOK=xxxxxx

export IMAGE_URI_COOK=matob/irango-api:latest

export SENTRY_DSN=xxxxxx
export DB_HOSTNAME=xxxxxx
export DB_USERNAME=xxxxxx
export DB_PASSWORD=xxxxxx
export REDIS_HOSTNAME=xxxxxx
```
Or configure it in windows environments.

### Using make
```bash
# To init terraform
make init

# To run terraform plan
make plan

# To apply changes
make up

# To deploy API pods
make up.api

# To deploy API cook pods
make up.api-cook

# To deploy API payment pods
make up.api-payment
```

To destroy resources:
```bash
make down
```

### Without make
```bash
# To init terraform
terraform -chdir=terraform init

# To run terraform plan
terraform -chdir=terraform plan

# To apply changes
terraform -chdir=terraform apply -auto-approve

# To deploy API pods
aws eks update-kubeconfig --name fiap-irango-k8s-cluster --region us-east-1
envsubst < ./.k8s/api/template-secrets.yml > .k8s/api/secrets.yml
envsubst < ./.k8s/api/template-migration.yml > .k8s/api/migration.yml
envsubst < ./.k8s/api/template-deployment.yml > .k8s/api/deployment.yml
kubectl apply -f .k8s/api/namespace.yml
kubectl apply -f .k8s/api/secrets.yml
kubectl apply -f .k8s/api/configmap.yml
kubectl apply -f .k8s/api/migration.yml
kubectl apply -f .k8s/api/deployment.yml
kubectl apply -f .k8s/api/service.yml
kubectl apply -f .k8s/api/hpa.yml


# To deploy API Cook pods
aws eks update-kubeconfig --name fiap-irango-k8s-cluster --region us-east-1
envsubst < ./.k8s/cook/template-secrets.yml > .k8s/cook/secrets.yml
envsubst < ./.k8s/cook/template-migration.yml > .k8s/cook/migration.yml
envsubst < ./.k8s/cook/template-deployment.yml > .k8s/cook/deployment.yml
kubectl apply -f .k8s/cook/namespace.yml
kubectl apply -f .k8s/cook/secrets.yml
kubectl apply -f .k8s/cook/configmap.yml
kubectl apply -f .k8s/cook/migration.yml
kubectl apply -f .k8s/cook/deployment.yml
kubectl apply -f .k8s/cook/service.yml
kubectl apply -f .k8s/cook/hpa.yml


# To deploy API Payment pods
aws eks update-kubeconfig --name fiap-irango-k8s-cluster --region us-east-1
envsubst < ./.k8s/payment/template-secrets.yml > .k8s/payment/secrets.yml
envsubst < ./.k8s/payment/template-migration.yml > .k8s/payment/migration.yml
envsubst < ./.k8s/payment/template-deployment.yml > .k8s/payment/deployment.yml
kubectl apply -f .k8s/payment/namespace.yml
kubectl apply -f .k8s/payment/secrets.yml
kubectl apply -f .k8s/payment/configmap.yml
kubectl apply -f .k8s/payment/migration.yml
kubectl apply -f .k8s/payment/deployment.yml
kubectl apply -f .k8s/payment/service.yml
kubectl apply -f .k8s/payment/hpa.yml
```

To destroy resources:
```bash
terraform -chdir=terraform destroy -auto-approve
```


sudo k3s kubectl apply -f .k8s/cook/namespace.yml
sudo k3s kubectl apply -f .k8s/cook/secrets.yml
sudo k3s kubectl apply -f .k8s/cook/configmap.yml
sudo k3s kubectl apply -f .k8s/cook/migration.yml
sudo k3s kubectl apply -f .k8s/cook/deployment.yml
sudo k3s kubectl apply -f .k8s/cook/service.yml
sudo k3s kubectl apply -f .k8s/cook/hpa.yml