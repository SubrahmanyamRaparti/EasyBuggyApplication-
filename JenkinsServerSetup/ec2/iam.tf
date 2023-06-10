data "template_file" "template_file" {
  template = file("templates/JenkinsAccessPolicy.json")
  vars = {
    account_id = data.aws_caller_identity.current.account_id
    region     = data.aws_region.current.name
    ecr_name   = module.aws_ecr_repository.name
  }
}

resource "aws_iam_policy" "aws_iam_policy" {
  name        = "JenkinsServerAccessPolicy"
  path        = "/"
  description = "Access for Jenkins Server"
  policy      = data.template_file.template_file.rendered
}

resource "aws_iam_role" "aws_iam_role" {
  name               = "JenkinsServerAccessRole"
  assume_role_policy = file("templates/JenkinsAssumepolicy.json")

  tags = {
    "Server name" = "Jenkins"
  }
}

resource "aws_iam_role_policy_attachment" "aws_iam_role_policy_attachment" {
  role       = aws_iam_role.aws_iam_role.name
  policy_arn = aws_iam_policy.aws_iam_policy.arn
}

resource "aws_iam_instance_profile" "aws_iam_instance_profile" {
  name = "jenkins-server-instance-profile"
  role = aws_iam_role.aws_iam_role.name
}