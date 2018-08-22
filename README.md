# AWS ECR Module  [![Build Status](https://travis-ci.org/doingcloudright/terraform-aws-ecr-lifecycle-policy-rule.svg?branch=master)](https://travis-ci.org/doingcloudright/terraform-aws-ecr-lifecycle-policy-rule)

This module simplifies the creation of an ECR life cycle rule. And can be used in combination with <a href="https://registry.terraform.io/modules/doingcloudright/ecr-cross-account/aws/">doingcloudright/ecr-cross-account/aws</a>. NB: Badly created ECR Lifecycle rules can cause great harm, it's important to review the created lifecycle rules.

Rules can be made for all available tag statuses [ tagged, untagged, any ], in combination with all count types [ imageCountMoreThan, sinceImagePushed ]. The default output
has a rule_priority $${rule_priority} which can be interpreted by a data "template_file" in a different module. If needed the rule_priority can be overridden.

## Examples

### Rotate after 30 images exist for ["test","uat","prod"]

```
module "ecr_lifecycle_rule_tagged_image_count_30" {
  source = "doingcloudright/ecr-lifecycle-policy-rule/aws"

  tag_status = "tagged"
  count_type = "imageCountMoreThan"
  prefixes  = ["test","uat","prod"]
  count_number = 30
}

output "ecr_lifecycle_rule_tagged_image_count_30" {
  value = "${module.ecr_lifecycle_rule_tagged_image_count_30.policy_rule}"
}
```

### Rotate images after 90 days since image pushed for ["test","uat","prod"]
```
module "ecr_lifecycle_rule_tagged_90_days_since_image_pushed" {
  source = "doingcloudright/ecr-lifecycle-policy-rule/aws"

  tag_status = "tagged"
  count_type = "sinceImagePushed"
  count_number = 40
  prefixes  = ["test","uat","prod"]
}

output "ecr_lifecycle_rule_tagged_90_days_since_image_pushed" {
  value = "${module.ecr_lifecycle_rule_tagged_90_days_since_image_pushed.policy_rule}"
}
```

### Rotate images after 7 images exist for any
```
module "ecr_lifecycle_rule_any_7_images" {
  source = "doingcloudright/ecr-lifecycle-policy-rule/aws"

  tag_status = "any"
  count_type = "imageCountMoreThan"
  count_number = "7"
}

output "ecr_lifecycle_rule_any_7_images" {
  value = "${module.ecr_lifecycle_rule_any_7_images.policy_rule}"
}
```

### Rotate images after 100 days since image pushed for untagged images
```
module "ecr_lifecycle_rule_untagged_100_days_since_image_pushed" {
  source = "doingcloudright/ecr-lifecycle-policy-rule/aws"

  tag_status = "untagged"
  count_type = "sinceImagePushed"
  count_number = "100"
}

output "ecr_lifecycle_rule_untagged_100_days_since_image_pushed" {
  value = "${module.ecr_lifecycle_rule_untagged_100_days_since_image_pushed.policy_rule}"
}
```
