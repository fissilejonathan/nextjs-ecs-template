# make build_image UUID=$(uuidgen)

IMAGE_TAG:=$(DOCKER_REGISTRY_NAME):$(UUID)

build_image:
	docker build -t $(IMAGE_TAG) --build-arg ENVIRONMENT=$(ENVIRONMENT) .

deploy_image:
	aws ecr get-login-password --region $(REGION) | docker login --username AWS --password-stdin $(DOCKER_REGISTRY_URL)
	docker push $(DOCKER_REGISTRY_URL)/$(IMAGE_TAG)

deploy_fargate:
	echo "running deploy_fargate"

deploy: build_image deploy_image deploy_fargate