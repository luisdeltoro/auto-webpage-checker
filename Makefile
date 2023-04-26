ECR_ENDPOINT := $(shell cat ecr_endpoint.var)

clean:
.PHONY: generate_version

clean:		## delete pycache, build files
	@rm -rf out
	@rm -rf __pycache__

generate_version:
	VERSION=$$(./bin/generate_version.sh); \
	echo "$$VERSION" > out/version.txt

## create Docker image with requirements
docker/build: generate_version
	VERSION=$$(cat out/version.txt); \
	echo "Building Docker image with tag: $${VERSION}"; \
	docker build -t awc-lambda:$${VERSION} .
	#docker build -t awc-lambda .

## run "src.lambda_function.lambda_handler" with docker-compose
## mapping "./tmp" and "./src" folders.
## "event.json" file is loaded and provided to lambda function as event parameter
docker/run:	docker/build
	#docker-compose run lambda src.lambda_function.lambda_handler
	docker run -p 9000:8080 awc-lambda:latest

docker/test:
	curl -XPOST 'http://localhost:9000/2015-03-31/functions/function/invocations' -d '{}'

ecr/login:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(ECR_ENDPOINT)

#ecr-create-repo:
#	aws ecr create-repository --repository-name awc-lambda --image-scanning-configuration scanOnPush=true --image-tag-mutability MUTABLE

docker/push: ecr/login docker/build
	VERSION=$$(cat out/version.txt); \
	echo "Pushing awc-lambda docker image with tag: $${VERSION}"; \
	docker tag awc-lambda:$${VERSION} $(ECR_ENDPOINT)/awc-lambda:latest
	docker push $(ECR_ENDPOINT)/awc-lambda:latest

# https://medium.com/akava/deploying-containerized-aws-lambda-functions-with-terraform-7147b9815599

### prepares layer.zip archive for AWS Lambda Layer deploy
#lambda-layer-build: clean
#	rm -f layer.zip
#	mkdir layer layer/python
#	cp -r bin layer/.
#	cd layer/bin; unzip -u ../../chromium.zip
#	pip3 install -r requirements.txt -t layer/python
#	cd layer; zip -9qr layer.zip .
#	cp layer/layer.zip .
#	rm -rf layer
#
### prepares deploy.zip archive for AWS Lambda Function deploy
#lambda-function-build: clean
#	rm -f deploy.zip
#	mkdir deploy
#	cp -r src deploy/.
#	cd deploy; zip -9qr deploy.zip .
#	cp deploy/deploy.zip .
#	rm -rf deploy
#
### create CloudFormation stack with lambda function and role.
### usage:	make BUCKET=your_bucket_name create-stack
#create-stack:
#	aws s3 cp layer.zip s3://${BUCKET}/src/SeleniumChromiumLayer.zip
#	aws s3 cp deploy.zip s3://${BUCKET}/src/ScreenshotFunction.zip
#	aws cloudformation create-stack --stack-name LambdaScreenshot --template-body file://cloud.yaml --parameters ParameterKey=BucketName,ParameterValue=${BUCKET} --capabilities CAPABILITY_IAM