module "bastion" { #this is an instance
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = local.name

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  #we have to convert public subnet ipaddress stringlist to list
  subnet_id   = local.public_subnet_id
  ami = data.aws_ami.ami_id.id

  tags = merge(
    var.common_tags,
    {
      Name = local.name
    }
  )

}

