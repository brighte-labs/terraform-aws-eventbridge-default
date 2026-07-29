# Migration

## EventBridge rule stack addresses

EventBridge rule stacks are keyed by rule name in this version. Consumers
upgrading from a version that used indexed `eventbus_rule_custom*` resources
should migrate existing CloudFormation stacks into the corresponding
`*_by_name` resource addresses before applying.

Use the target address that matches the module mode:

| Module mode | Old address | New address |
| --- | --- | --- |
| Custom bus, owner account access | `aws_cloudformation_stack.eventbus_rule_custom[INDEX]` | `aws_cloudformation_stack.eventbus_rule_custom_by_name["RULE_NAME"]` |
| Custom bus, organization access | `aws_cloudformation_stack.eventbus_rule_custom_org[INDEX]` | `aws_cloudformation_stack.eventbus_rule_custom_org_by_name["RULE_NAME"]` |
| Existing custom bus | `aws_cloudformation_stack.eventbus_rule_custom_existing[INDEX]` | `aws_cloudformation_stack.eventbus_rule_custom_existing_by_name["RULE_NAME"]` |

For existing stacks, use Terraform `removed` blocks with `destroy = false` for
the old indexed addresses and `import` blocks for the new keyed addresses in the
calling configuration.

Rule names in `eventbus_rules` must be unique because they are used as Terraform
`for_each` keys and CloudFormation stack names.
