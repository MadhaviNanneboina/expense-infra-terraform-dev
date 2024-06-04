locals {
  public_subnet_id = element(split(",",data.aws_ssm_parameter.public_subnet_ids.value), 0)
  private_subnet_id = element(split(",",data.aws_ssm_parameter.private_subnet_ids.value), 0)
  name1 = "${var.project_name}-${var.environment}-backend"
  name2 = "${var.project_name}-${var.environment}-frontend"
  name3 = "${var.project_name}-${var.environment}-ansible"
}