ECR_ENDPOINT := $(shell cat ecr_endpoint.var)

clean:
	@rm -rf out
	@rm -rf __pycache__

venv:
	python3 -m venv ./venv

requirements: venv
	. ./venv/bin/activate; \
	pip install -r requirements.txt; \
	pip install -r dev_requirements.txt

tf/ecr/apply:
	terraform -chdir=terraform apply -target=ecr.tf

isort:
	. ./venv/bin/activate; \
	python -m isort app

black:
	. ./venv/bin/activate; \
	python -m black app

tf/fmt:
	terraform -chdir=terraform fmt

pretty: isort black tf/fmt

lint:
	. ./venv/bin/activate; \
	python -m flake8 --max-line-length=119 app

out_dir:
	mkdir -p out

version: out_dir
	VERSION=$$(./bin/generate_version.sh); \
	echo "$$VERSION" > out/version.txt

docker/build: version pretty lint
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

docker/push: tf/ecr/apply docker/build ecr/login
	VERSION=$$(cat out/version.txt); \
	echo "Pushing awc-lambda docker image with tag: $${VERSION}"; \
	docker tag awc-lambda:$${VERSION} $(ECR_ENDPOINT)/awc-lambda:latest
	docker push $(ECR_ENDPOINT)/awc-lambda:latest

tf/plan:
	terraform -chdir=terraform plan

tf/apply:
	terraform -chdir=terraform apply

deploy: docker/push terraform/apply

docker/rmi:
	if [ $$(docker image ls awc-lambda -q) ]; then docker image rm $$(docker image ls awc-lambda -q); fi

tf/destroy:
	terraform -chdir=terraform destroy

teardown: tf/destroy docker/rmi
