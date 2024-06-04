#creating backend server
module "backend" { #this is an instance
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = local.name1

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
  #we have to convert public subnet ipaddress stringlist to list
  subnet_id   = local.private_subnet_id
  ami = data.aws_ami.ami_id.id

  tags = merge(
    var.common_tags,
    {
      Name = local.name1
    }
  )

}

#creating frontend server
module "frontend" { #this is an instance
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = local.name2

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]
  #we have to convert public subnet ipaddress stringlist to list
  subnet_id   = local.public_subnet_id
  ami = data.aws_ami.ami_id.id

  tags = merge(
    var.common_tags,
    {
      Name = local.name2
    }
  )

}
module "ansible" { #this is an instance
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = local.name3

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.ansible_sg_id.value]
  #we have to convert public subnet ipaddress stringlist to list
  subnet_id   = local.public_subnet_id
  ami = data.aws_ami.ami_id.id
  user_data = file(ansible-expense.sh)   #when ansible instance create at that time this script file also run in this server automatically

  tags = merge(
    var.common_tags,
    {
      Name = local.name3
    }
  )
  depends_on = [ module.frontend, module.backend ] #first frontend and backend server vundali congigure cheyalante
}

#creating R53 records 
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
   {
      name    = "backend"
      type    = "A"
      ttl     = 1
      records = [
        module.backend.private_ip
      ]
    },
    
    
    {
      name    = "frontend"
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.private_ip
      ]
    },
    {
      name    = "" #vishruth.online
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.public_ip
      ]
    },
  ]

  
}