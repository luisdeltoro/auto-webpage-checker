ECR_ENDPOINT := $(shell cat ecr_endpoint.var)

clean:
	@rm -rf out
	@rm -rf __pycache__

create_venv:
	python3 -m venv ./venv

install_requirements: create_venv
	. ./venv/bin/activate; \
	pip install -r requirements.txt

create_out_dir:
	mkdir -p out

generate_version: create_out_dir
	VERSION=$$(./bin/generate_version.sh); \
	echo "$$VERSION" > out/version.txt

docker/build: generate_version
	VERSION=$$(cat out/version.txt); \
	echo "Building Docker image with tag: $${VERSION}"; \
	docker build -t awc-lambda:$${VERSION} .

docker/run:	docker/build
	VERSION=$$(cat out/version.txt); \
	docker run -p 9000:8080 awc-lambda:$${VERSION}

docker/test:
	curl -XPOST 'http://localhost:9000/2015-03-31/functions/function/invocations' -d '{}'

ecr/login:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(ECR_ENDPOINT)

docker/push: docker/build ecr/login
	VERSION=$$(cat out/version.txt); \
	echo "Pushing awc-lambda docker image with tag: $${VERSION}"; \
	docker tag awc-lambda:$${VERSION} $(ECR_ENDPOINT)/awc-lambda:latest
	docker push $(ECR_ENDPOINT)/awc-lambda:latest

terraform/plan:
	cd terraform; \
	terraform plan

terraform/apply:
	cd terraform; \
	terraform apply

deploy: docker/push terraform/apply