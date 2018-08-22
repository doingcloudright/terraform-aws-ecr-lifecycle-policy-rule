locals {
  # Validate that the tagstatus is either [ tagged , untagged , any ]
  validate_tag_status = "${lookup(var.allowed_tag_status,var.tag_status)}"

  # Validate that the count_type is either [ imageCountMoreThan , sinceImagePushed ]
  validate_count_type = "${lookup(var.allowed_count_types,var.count_type)}"

  # We cannot on/and off tagPrefixList and countUnit hence we need to create 4 different data structures with
  # 4 different template files.

  # policy rule template for
  # countType imageCountMoreThan
  # tag_status tagged
  policy_based_on_imageCountMoreThan_for_tag_status_tagged {
    rulePriority = "$${rule_priority}"
    description  = "Rotate images after amount of: $${count_number} is reached for prefix $${prefix}"

    selection = {
      tagStatus     = "tagged"
      tagPrefixList = ["$${prefix}"]
      countType     = "imageCountMoreThan"
      countNumber   = "$${count_number}"
    }

    action = {
      type = "expire"
    }
  }
  # policy rule template for
  # countType imageCountMoreThan
  # tag_status untagged or any
  policy_based_on_imageCountMoreThan_for_tag_status_untagged_or_any {
    for_tag_status_untagged_or_any = {
      rulePriority = "$${rule_priority}"
      description  = "Rotate images after amount of: $${count_number} is reached for $${tag_status} images"

      selection = {
        tagStatus   = "$${tag_status}"
        countType   = "imageCountMoreThan"
        countNumber = "$${count_number}"
      }

      action = {
        type = "expire"
      }
    }
  }
  # policy rule template for
  # countType sinceImagePushed
  # tag_status tagged
  policy_based_on_sinceImagePushed_for_tag_status_tagged {
    rulePriority = "$${rule_priority}"
    description  = "Rotate images after amount of: $${count_number} days since image pushed, is reached for prefix $${prefix}"

    selection = {
      tagStatus     = "tagged"
      tagPrefixList = ["$${prefix}"]
      countType     = "sinceImagePushed"
      countUnit     = "days"
      countNumber   = "$${count_number}"
    }

    action = {
      type = "expire"
    }
  }
  # policy rule template for
  # countType sinceImagePushed
  # tag_status untagged or any
  policy_based_on_sinceImagePushed_for_tag_status_untagged_or_any = {
    rulePriority = "$${rule_priority}"
    description  = "Rotate images after amount of: $${count_number} days since image pushed, is reached for $${tag_status} images"

    selection = {
      tagStatus   = "$${tag_status}"
      countNumber = "$${count_number}"
      countType   = "sinceImagePushed"
      countUnit   = "days"
    }

    action = {
      type = "expire"
    }
  }
}

# template_file for 
# countType imageCountMoreThan
# tag_status tagged
data "template_file" "lifecycle_policy_imageCountMoreThan_tagged" {
  count = "${var.create && var.count_type == "imageCountMoreThan" && var.tag_status == "tagged" ? 1 : 0 }"

  template = "${jsonencode(local.policy_based_on_imageCountMoreThan_for_tag_status_tagged)}"

  vars {
    rule_priority = "${var.rule_priority}"
    prefix        = "${join("\",\"",var.prefixes)}"

    count_number = "${var.count_number}"
  }
}

# template_file for 
# countType imageCountMoreThan
# tag_status untagged or any
data "template_file" "lifecycle_policy_imageCountMoreThan_untagged_or_any" {
  count = "${var.create && var.count_type == "imageCountMoreThan" && var.tag_status != "tagged" ? 1 : 0 }"

  template = "${jsonencode(local.policy_based_on_imageCountMoreThan_for_tag_status_untagged_or_any)}"

  vars {
    rule_priority = "${var.rule_priority}"
    tag_status    = "${var.tag_status}"

    count_number = "${var.count_number}"
  }
}

# template_file for 
# countType sinceImagePushed
# tag_status tagged
data "template_file" "lifecycle_policy_sinceImagePushed_tagged" {
  count = "${var.create && var.count_type == "sinceImagePushed" && var.tag_status == "tagged" ? 1 : 0}"

  template = "${jsonencode(local.policy_based_on_sinceImagePushed_for_tag_status_tagged)}"

  vars {
    rule_priority = "${var.rule_priority}"
    prefix        = "${join("\",\"",var.prefixes)}"

    # If there is no count defined in the map var.prefixes_pecific_max_count, we take the var.count_number
    count_number = "${var.count_number}"
  }
}

# template_file for 
# countType sinceImagePushed
# tag_status untagged or any
data "template_file" "lifecycle_policy_sinceImagePushed_untagged_or_any" {
  count = "${var.create && var.count_type == "sinceImagePushed" && var.tag_status != "tagged" ? 1 : 0 }"

  template = "${jsonencode(local.policy_based_on_sinceImagePushed_for_tag_status_untagged_or_any)}"

  vars {
    rule_priority = "${var.rule_priority}"
    tag_status    = "${var.tag_status}"

    # If there is no count defined in the map var.prefixes_pecific_max_count, we take the var.count_number
    count_number = "${var.count_number}"
  }
}
