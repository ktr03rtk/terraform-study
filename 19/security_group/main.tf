variable "allow_ssh" {
  type = bool
}

variable "allow_ssh_name" {}

resource "aws_security_group" "example" {
  name = var.allow_ssh_name
}

resource "aws_security_group_rule" "egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.example.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress" {
  count = var.allow_ssh ? 1 : 0

  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.example.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

output "allow_ssh_rule_id" {
  value = join("", aws_security_group_rule.ingress[*].id)
}

