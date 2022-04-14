# If no priority is set, the default value for priority priority:replace:this will be replaced with $${rule_priority} for later 
# template interpolation
output "policy_rule" {
  description = "ECR Policy Rule"

  value = "${replace(
		 replace(element(concat(
             data.template_file.lifecycle_policy_imageCountMoreThan_tagged.*.rendered,
             data.template_file.lifecycle_policy_imageCountMoreThan_untagged_or_any.*.rendered,
             data.template_file.lifecycle_policy_sinceImagePushed_tagged.*.rendered,
             data.template_file.lifecycle_policy_sinceImagePushed_untagged_or_any.*.rendered,
             [""]
			      ),0),
			 "/\"(true|false|[[:digit:]]+)\"/", "$1"
		), "string:", ""
	      )}"
}
