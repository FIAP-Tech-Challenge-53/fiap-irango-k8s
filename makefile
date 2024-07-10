#!/bin/bash

init:
	terraform -chdir=terraform init

plan:
	terraform -chdir=terraform plan

up:
	terraform -chdir=terraform apply -auto-approve

down:
	terraform -chdir=terraform destroy -auto-approve

up.api:
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


up.api-cook:
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

up.api-payment:
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