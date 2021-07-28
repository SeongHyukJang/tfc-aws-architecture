resource "aws_cloudwatch_log_group" "log_group_message" {
    name = "messages"
    retention_in_days = 1

    tags = {
        Name = "70491-to-S3"
    }
}

resource "aws_cloudwatch_log_group" "log_group_secure" {
    name = "secure"
    retention_in_days = 1


    tags = {
        Name = "70491-to-S3"
    }
}

resource "aws_cloudwatch_event_rule" "cloudwatch_rule_log" {
    name = "70491-rule"
    description = "put log to s3"

    schedule_expression = "rate(1 minute)"
    role_arn = "arn:aws:lambda:ap-northeast-2:533616270150:function:70491-lambda"
    is_enabled = true

    tags = {
        Name = "70491-rule"
    }
}