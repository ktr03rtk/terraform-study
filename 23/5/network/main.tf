resource "aws_vpc" "staging" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Environment = "Staging"
  }
}

resource "aws_subnet" "public_staging" {
  cidr_block = "192.168.0.0/24"
  vpc_id     = aws_vpc.staging.id

  tags = {
    Environment   = "Staging"
    Accessibility = "Public"
  }
}
