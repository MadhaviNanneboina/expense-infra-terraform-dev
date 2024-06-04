variable "project_name" {
    default = "expense"
  
}
variable "environment" {
    default = "dev"
  
}
variable "common_tags" {
    default = {
        Environment = "dev"
        Project_name = "expense"
        Terraform = "true"

    }
  
}
