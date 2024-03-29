provider "aws" {
  region = var.aws_region
}

resource "aws_docdb_cluster" "example" {
  cluster_identifier  = var.docdb_cluster_identifier
  engine              = var.docdb_engine
  master_username     = var.docdb_master_username
  master_password     = var.docdb_master_password
  skip_final_snapshot = true
}

resource "aws_docdb_cluster_instance" "example_instance" {
  count              = 1
  identifier         = "my-docdb-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.example.id
  instance_class     = var.docdb_instance_class
}

resource "aws_sns_topic" "docdb_alarm_sns_topic" {
  name = "docdb-alarm-sns-topic"
}

resource "aws_iam_role" "cloudwatch_action_role" {
  name = "CloudWatchActionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_sns_publish" {
  name        = "CloudWatchSNSPublish"
  description = "Allow CloudWatch Alarms to publish to SNS topics"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "sns:Publish",
        Effect   = "Allow",
        Resource = aws_sns_topic.docdb_alarm_sns_topic.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_sns_publish_attachment" {
  role       = aws_iam_role.cloudwatch_action_role.name
  policy_arn = aws_iam_policy.cloudwatch_sns_publish.arn
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "docdb-cpu-utilization-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/DocDB"
  period              = "60"
  statistic           = "Average"
  threshold           = var.cpu_utilization_threshold
  alarm_description   = "Alarm when CPU Utilization exceeds 80%"
  dimensions = {
    DBClusterIdentifier = aws_docdb_cluster.example.cluster_identifier
  }
  actions_enabled = true
  alarm_actions = [aws_sns_topic.docdb_alarm_sns_topic.arn]
}