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
