locals {
  rules = [
    { port = 8080, cidr_block = "0.0.0.0/0" },
    { port = 22, cidr_block = "${data.aws_vpc.selected.cidr_block}" }
  ]
}