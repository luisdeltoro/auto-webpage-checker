# README

## Prerequisities
1. aws cli installed and configured with valid credentials. See: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
2. terraform installed. See: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli


## Set up
1. AWS credentials for terraform
Create a file with your AWS credential called `terraform.tfvars` under `terraform/`
Here is an example
```
aws_access_key = <AWS_ACCESS_KEY>"
aws_secret_key = "<AWS_SECRET_KEY>"
```

2. Python Virtual Environment 
Create the python virtual environment and install dependencies
```
make install_requirements
```

## Run container locally
```
make docker/run
```

## Test locally running container
```
make docker/test
```

## Deploy to AWS
```
make deploy
```

## References:
- https://aws.amazon.com/blogs/devops/serverless-ui-testing-using-selenium-aws-lambda-aws-fargate-and-aws-developer-tools/
- https://www.vittorionardone.it/en/2020/06/04/chromium-and-selenium-in-aws-lambda
- https://docs.aws.amazon.com/lambda/latest/dg/images-create.html
- https://docs.aws.amazon.com/lambda/latest/dg/images-test.html
- https://medium.com/akava/deploying-containerized-aws-lambda-functions-with-terraform-7147b9815599