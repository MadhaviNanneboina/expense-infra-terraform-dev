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
variable "zone_name" {
    default = "vishruth.online"
  
}