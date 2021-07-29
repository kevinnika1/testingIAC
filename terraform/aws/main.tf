provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

data "aws_ami" "main_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["dummy-server-*"]
  }
}

resource "aws_instance" "dummy-server" {
  ami = "${data.aws_ami.main_ami.image_id}"

  count = 2

  instance_type = "t2.micro"

  key_name               = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.dummy_server.id}"]

  subnet_id = "${aws_subnet.default.id}"
}

resource "aws_security_group" "dummy_server" {
  name   = "dummy-server"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = "${var.dummy_server_port}"
    to_port     = "${var.dummy_server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
