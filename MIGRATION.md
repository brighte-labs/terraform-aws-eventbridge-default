# Migration

## EventBridge rule stack addresses

EventBridge rule stacks are keyed by rule name in this version. Consumers
upgrading from a version that used indexed `eventbus_rule_custom*` resources
should migrate existing CloudFormation stacks into the corresponding
`*_by_name` resource addresses before applying.

For existing stacks, use Terraform `removed` blocks with `destroy = false` for
the old indexed addresses and `import` blocks for the new keyed addresses in the
calling configuration.
