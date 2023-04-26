# README

## Setup (One time)

python3 -m venv ./venv

source ./venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt

## Invoke script locally
from python/src/
```
python3 -m awc.check_webpage
```

## Steps to deploy
```
make docker/push
```

```
cd terraform
terraform apply
```

## References:
- https://aws.amazon.com/blogs/devops/serverless-ui-testing-using-selenium-aws-lambda-aws-fargate-and-aws-developer-tools/
- https://www.vittorionardone.it/en/2020/06/04/chromium-and-selenium-in-aws-lambda
- https://docs.aws.amazon.com/lambda/latest/dg/images-create.html
- https://docs.aws.amazon.com/lambda/latest/dg/images-test.html
- https://medium.com/akava/deploying-containerized-aws-lambda-functions-with-terraform-7147b9815599