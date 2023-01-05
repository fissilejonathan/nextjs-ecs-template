ECRRegistryUrl = $(shell jq '.ECRRegistryUrl' parameters.json)
Region = us-east-1

build_image:
	$(eval RegistryImageTag := $(ECRRegistryUrl):$(ImageTag))
	docker build -t $(RegistryImageTag) .

deploy_image:
	aws ecr get-login-password --region $(Region) | docker login --username AWS --password-stdin $(ECRRegistryUrl)
	$(eval RegistryImageTag := $(ECRRegistryUrl):$(ImageTag))
	docker push $(RegistryImageTag)

ParameterOverrides = $(shell jq -r 'to_entries[] | "\(.key)=\(.value)"' parameters.json | tr '\n' ' ')

deploy_fargate:
	sam deploy \
		--template-file template.yaml \
		--parameter-overrides $(ParameterOverrides) ImageTag=$(ImageTag) \
		--stack-name "nextjs-ecs" \
		--resolve-s3 \
		--region $(Region) \
		--capabilities "CAPABILITY_NAMED_IAM" \
		--debug \
		--no-fail-on-empty-changeset