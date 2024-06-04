module "db" {
    source = "../../terraform-expense-securitygroup-develop"
    project_name = var.project_name
    environment = var.environment
    sg_discription = "SG for my sql instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "db"
}
module "backend" {
    source = "../../terraform-expense-securitygroup-develop"
    project_name = var.project_name
    environment = var.environment
    sg_discription = "SG for backend instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "backend"
}
module "frontend" {
    source = "../../terraform-expense-securitygroup-develop"
    project_name = var.project_name
    environment = var.environment
    sg_discription = "SG for frontend instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "frontend"
}
module "bastion" {
    source = "../../terraform-expense-securitygroup-develop"
    project_name = var.project_name
    environment = var.environment
    sg_discription = "SG for bastion instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "bastion"
}
module "ansible" {
    source = "../../terraform-expense-securitygroup-develop"
    project_name = var.project_name
    environment = var.environment
    sg_discription = "SG for ansible instances"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "ansible"
}
###adding rules
##allowing traffic from backend to db server
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id  #which server we are getting traffic
  security_group_id = module.db.sg_id     #destination server sgid
}
##allowing traffic from bastion to db server
resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id  #which server we are getting traffic
  security_group_id = module.db.sg_id     #destination server sgid
}
##allowing traffic from frontend to backend server
resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id  #which server we are getting traffic
  security_group_id = module.backend.sg_id     #destination server sgid
}
##allowing traffic from bastion to backend server
resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id  #which server we are getting traffic
  security_group_id = module.backend.sg_id     #destination server sgid
}
##allowing traffic from ansible to backend server
resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id  #which server we are getting traffic
  security_group_id = module.backend.sg_id     #destination server sgid
}
##allowing traffic from internet to frontend server
resource "aws_security_group_rule" "forntend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks =  ["0.0.0.0/0"] #which server we are getting traffic
  security_group_id = module.frontend.sg_id     #destination server sgid
}
##allowing traffic from bastion to frontend server
resource "aws_security_group_rule" "forntend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
 source_security_group_id = module.bastion.sg_id#which server we are getting traffic
  security_group_id = module.frontend.sg_id     #destination server sgid
}
##allowing traffic from ansible to frontend server
resource "aws_security_group_rule" "forntend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
 source_security_group_id = module.ansible.sg_id#which server we are getting traffic
  security_group_id = module.frontend.sg_id     #destination server sgid
}
##allowing traffic from internet to bastion server
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks =  ["0.0.0.0/0"] #which server we are getting traffic
  security_group_id = module.bastion.sg_id     #destination server sgid
}
##allowing traffic from internet to ansible server
resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks =  ["0.0.0.0/0"] #which server we are getting traffic
  security_group_id = module.ansible.sg_id     #destination server sgid
}