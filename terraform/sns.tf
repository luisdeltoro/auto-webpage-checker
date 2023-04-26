








resource "aws_sns_topic" "awc-main" {
  name = "awc-main-topic"
}

resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.awc-main.arn

  policy = data.aws_iam_policy_document.allow_awc_lambda_to_publish_to_awc_main_sns_topic.json
}

data "aws_iam_policy_document" "allow_awc_lambda_to_publish_to_awc_main_sns_topic" {
  policy_id = "__default_policy_ID"

  statement {
    sid = "AllowLambdaToPublish"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [
      "sns:Publish",
    ]
    resources = [
      aws_sns_topic.awc-main.arn,
    ]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values = [aws_lambda_function.awc.arn,]
    }
  }
}






#data "aws_caller_identity" "current" {}
#
#resource "aws_sns_topic" "awc-main" {
#  name = "awc-main-topic"
#
#  policy = jsonencode({
#    Version = "2008-10-17",
#    Id = "__default_policy_ID",
#    Statement = [
#      {
#        Sid = "__default_statement_ID",
#        Effect = "Allow",
#        Principal = {
#          AWS = "*"
#        },
#        Action = [
#          "SNS:GetTopicAttributes",
#          "SNS:SetTopicAttributes",
#          "SNS:AddPermission",
#          "SNS:RemovePermission",
#          "SNS:DeleteTopic",
#          "SNS:Subscribe",
#          "SNS:ListSubscriptionsByTopic",
#          "SNS:Publish"
#        ],
#        Resource = "*",
#        Condition = {
#          StringEquals = {
#            "AWS:SourceOwner": "${data.aws_caller_identity.current.account_id}"
#          }
#        }
#      },
#      {
#        Sid = "AllowLambdaToPublish",
#        Effect = "Allow",
#        Principal = {
#          Service = "lambda.amazonaws.com"
#        },
#        Action = "sns:Publish",
#        Resource = "*",
#        Condition = {
#          ArnEquals = {
#            "aws:SourceArn": aws_lambda_function.awc.arn
#          }
#        }
#      }
#    ]
#  })
#}
