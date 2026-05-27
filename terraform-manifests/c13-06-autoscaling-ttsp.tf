# INFO: Target Tracking Scaling Policies
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy

# INFO: TTS - Scaling Policy-1: Based on CPU Utilization

resource "aws_autoscaling_policy" "avg_cpu_policy_greater_than_xx" {
  name                      = "${local.name}-avg-cpu-policy-greater-than-xx"
  policy_type               = "TargetTrackingScaling" # NOTE: Default "SimpleScaling."
  estimated_instance_warmup = 120

  autoscaling_group_name = aws_autoscaling_group.my_asg.id

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0 # NOTE: CPU Utilization above 50%

  }
}

/*

# INFO: TTS - Scaling Policy-2: Based on ALB Target Requests

resource "aws_autoscaling_policy" "alb_target_requests_greater_than_yy" {
  depends_on = [ aws_autoscaling_group.my_asg ] # NOTE: Ensure ASG is created before this policy due to API errors during initiatal apply.
  name        = "${local.name}-alb-target-requests-greater-than-yy"
  policy_type = "TargetTrackingScaling" # NOTE: Default "SimpleScaling."

  autoscaling_group_name = aws_autoscaling_group.my_asg.id
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_lb.application_load_balancer.arn_suffix}/${aws_lb_target_group.private_target_group_80_app1.arn_suffix}"
    }

    target_value = 10.0 # NOTE: Number of requests > 10 completed per target in an Application Load Balancer target group.
  }
}

*/

/*
# INFO: TTS - Scaling Policy-3: Different scaling policies for scaling out and scaling in
# ! TO BE TESTED

resource "aws_autoscaling_policy" "scale_up" {
  name                    = "${local.name}-scale-up"
  policy_type             = "StepScaling"
  autoscaling_group_name  = aws_autoscaling_group.my_asg.id
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = 1
  }
}

resource "aws_autoscaling_policy" "scale_down" {
  name                    = "${local.name}-scale-down"
  policy_type             = "StepScaling"
  autoscaling_group_name  = aws_autoscaling_group.my_asg.id
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 600

  step_adjustment {
    metric_interval_upper_bound = 0
    scaling_adjustment          = -1
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name                = "${local.name}-cpu-high"
  namespace                 = "AWS/EC2"
  metric_name               = "CPUUtilization"
  statistic                 = "Average"
  period                    = 60
  evaluation_periods        = 5   # 300 seconds
  threshold                 = 70
  comparison_operator       = "GreaterThanThreshold"
  alarm_actions             = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name                = "${local.name}-cpu-low"
  namespace                 = "AWS/EC2"
  metric_name               = "CPUUtilization"
  statistic                 = "Average"
  period                    = 60
  evaluation_periods        = 10  # 600 seconds
  threshold                 = 30
  comparison_operator       = "LessThanThreshold"
  alarm_actions             = [aws_autoscaling_policy.scale_down.arn]
}

*/