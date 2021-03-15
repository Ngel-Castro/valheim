resource "aws_iam_instance_profile" "valheimServerProfile" {
  name = "valheimServerProfile"
  role = aws_iam_role.valheimServerRole.name
}


resource "aws_eip" "eipValheimServer" {
  vpc = true

  instance                  = aws_instance.valheimServer.id
  associate_with_private_ip = "10.0.2.12"
  depends_on                = [aws_internet_gateway.IGW]


  tags = {
    Name    = "myProject"
    Project = "myProject"
  }
}

resource "aws_instance" "valheimServer" {
  ami           = "ami-038f1ca1bd58a5790" # us-east-1
  instance_type = "t3.medium"
  private_ip = "10.0.2.12"
  subnet_id  = aws_subnet.servers_1.id
  iam_instance_profile = aws_iam_instance_profile.valheimServerProfile.name
  key_name = "valheimKey" # Create your Own Key here
  security_groups = [ aws_security_group.ValheimTraffic.id ]
  user_data = file("../devops/instance/prep-instance")
  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
    delete_on_termination = "true"
  }

  tags = {
    Name    = "valheimServer"
    Project = "myProject"
  }
}