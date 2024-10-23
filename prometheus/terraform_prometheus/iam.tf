#Create aws_iam_role resource

resource "aws_iam_role" "prometheus_aws_iam_role" {
  name = "prometheus_aws_iam_role"

  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": "ec2.amazonaws.com"
       },
       "Effect": "Allow",
       "Sid": ""
     }
   ]
 }
 EOF
}

#Create aws_iam_instance_profile resource

resource "aws_iam_instance_profile" "prometheus_iam_instance_profile" {
  name = "prometheus_iam_instance_profile"
  role = aws_iam_role.prometheus_aws_iam_role.name
}

#Create aws_iam_role_policy resource

resource "aws_iam_role_policy" "prometheus_iam_role_policy" {
  name = "prometheus_iam_role_policy"
  role = aws_iam_role.prometheus_aws_iam_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:Describe*",
            "Resource": "*"
        }
    ]
}
 EOF
}
