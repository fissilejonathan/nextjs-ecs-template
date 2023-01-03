# Example on how to execute: make build_image UUID=$(uuidgen)

build_image:
	echo $(UUID)
	$(eval REGISTRY_IMAGE_TAG := $(ECR_REGISTRY_URL)/$(ECR_REGISTRY_NAME):$(UUID))
	docker build -t $(REGISTRY_IMAGE_TAG) --build-arg ENVIRONMENT=$(ENVIRONMENT) .

deploy_image:
	aws sts assume-role --role-arn $(AWS_ACCOUNT_ROLE_FOR_ECR) --role-session-name ECRSession
	aws ecr get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(ECR_REGISTRY_URL)
	$(eval REGISTRY_IMAGE_TAG := $(ECR_REGISTRY_URL)/$(ECR_REGISTRY_NAME):$(UUID))
	docker push $(REGISTRY_IMAGE_TAG)

deploy_fargate:
	echo "running deploy_fargate"
