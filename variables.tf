variable "create" {
  description = "create defines if resources need to be created true/false"
  default     = true
}

variable "rule_priority" {
  description = "The Priority of the rule, when not given the default priority:replace:this it will be replaced by $${rule_priority} for later template_file interpretation"
  default     = "priority:replace:this"
}

variable "count_type" {
  description = "The ECR lifecycle image count, [ imageCountMoreThan , sinceImagePushed ]"
}

variable "allowed_count_types" {
  description = "Lookup map to validate the count_type"

  default = {
    imageCountMoreThan = "imageCountMoreThan"
    sinceImagePushed   = "sinceImagePushed"
  }
}

variable "tag_status" {
  description = "The tag status of the image for which we create the lifecycle [ tagged, untagged, any ]"
}

variable "allowed_tag_status" {
  description = "Lookup map to validate the count_type"

  default = {
    tagged   = "tagged"
    untagged = "untagged"
    any      = "any"
  }
}

variable "prefixes" {
  description = "prefixes define which prefixes need to have lifecycle rules applied"
  default     = []
}

variable "count_number" {
  # count_number sets the default rotation in either imageCountMoreThan or days sinceImagePushed
  default = 90
}
