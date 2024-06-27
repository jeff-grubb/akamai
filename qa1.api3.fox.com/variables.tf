variable "edgerc_path" {
  type    = string
  default = "~/.edgerc"
}

variable "config_section" {
  type    = string
  default = "foxent"
}

variable "contract_id" {
  type    = string
  default = "ctr_3-9I38ZU"
}

variable "group_id" {
  type    = string
  default = "grp_21681"
}

variable "activate_latest_on_staging" {
  type    = bool
  default = true
}

variable "activate_latest_on_production" {
  type    = bool
  default = true
}
