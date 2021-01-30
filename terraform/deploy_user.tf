resource "aws_iam_user" "ci_user" {
  name = "short-stuff-ci-deploy-user"
}

resource "aws_iam_user_policy" "ci_ecr_access" {
  user = aws_iam_user.ci_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "ecr:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_ecr_repository.short_stuff.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy" "ecs-fargate-deploy" {
  user = aws_iam_user.ci_user.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecs:UpdateService",
        "ecs:UpdateTaskDefinition",
        "ecs:DescribeServices",
        "ecs:DescribeTaskDefinition",
        "ecs:DescribeTasks",
        "ecs:RegisterTaskDefinition",
        "ecs:ListTasks"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY
}

