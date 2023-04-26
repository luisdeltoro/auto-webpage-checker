resource "aws_cloudwatch_event_rule" "awc_lambda_trigger" {
  event_bus_name      = "default"
  is_enabled          = "true"
  name                = "awc_lambda-trigger"
  schedule_expression = "cron(0 * * * ? *)" # Every hour
}

resource "aws_cloudwatch_event_target" "awc_lambda" {
  arn  = aws_lambda_function.awc.arn
  rule = aws_cloudwatch_event_rule.awc_lambda_trigger.name
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_awc_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.awc.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.awc_lambda_trigger.arn
}