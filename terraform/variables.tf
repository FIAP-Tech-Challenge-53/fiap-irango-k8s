# Task Definition
variable "work_node_api_min_size" {
  default = 1
}

variable "work_node_api_max_size" {
  default = 3
}

variable "work_node_api_desired_size" {
  default = 2
}

variable "work_node_api_instance_type" {
  default = "t3.medium"
}
