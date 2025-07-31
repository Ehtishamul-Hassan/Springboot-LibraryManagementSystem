# Use existing IAM role if create_ssm_role is false
data "aws_iam_role" "existing_ssm_role" {
  count = var.create_ssm_role ? 0 : 1
  name  = "ec2-ssm-role"
}

resource "aws_iam_role" "ssm_role" {
  count = var.create_ssm_role ? 1 : 0
  name  = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  count      = var.create_ssm_role ? 1 : 0
  role       = aws_iam_role.ssm_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Use existing IAM instance profile if role exists
data "aws_iam_instance_profile" "existing_profile" {
  count = var.create_ssm_role ? 0 : 1
  name  = "ec2-ssm-profile"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  count = var.create_ssm_role ? 1 : 0
  name  = "ec2-ssm-profile"
  role  = aws_iam_role.ssm_role[0].name
}

# Output correct profile name for EC2 use
output "iam_instance_profile_name" {
  value = var.create_ssm_role ? aws_iam_instance_profile.ssm_profile[0].name : data.aws_iam_instance_profile.existing_profile[0].name
}
