resource "aws_cloudwatch_event_bus" "messenger" {
  name              = "moogsoft-alerts"
  event_source_name = "aws"
}
