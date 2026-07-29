# https://docs.aws.amazon.com/eventbridge/latest/userguide/event-types.html
locals {
  eventbus_rules_by_name = {
    for rule in var.eventbus_rules : rule => rule
  }

  create_custom_eventbus_rules     = !var.custom_eb_exist && var.required_custom_bus && !var.enable_org_access
  create_custom_org_eventbus_rules = !var.custom_eb_exist && var.enable_org_access
  manage_existing_eventbus_rules   = var.custom_eb_exist
}

resource "aws_cloudformation_stack" "eventbus_rule_custom_by_name" {
  for_each = local.create_custom_eventbus_rules ? local.eventbus_rules_by_name : {}

  depends_on = [aws_cloudformation_stack.eventbus, aws_cloudformation_stack.eventbus_policy]
  name       = "eb-rules-${each.key}"
  parameters = {
    ConfigurationEBNameParam     = "${var.bus_name}"
    ConfigurationEBRuleNameParam = lookup(var.eventbus_event_pattern[each.key], "rulename")
    DescriptionParam             = lookup(var.eventbus_event_pattern[each.key], "description")
    EventPatternState            = var.eventbus_rule_state
    EventRuleTargetArn           = lookup(var.eventbus_event_pattern[each.key], "target")
    EventRuleTargetID            = lookup(var.eventbus_event_pattern[each.key], "id")
  }
  template_body = lookup(var.eventbus_event_pattern[each.key], "file")
}

resource "aws_cloudformation_stack" "eventbus_rule_custom_org_by_name" {
  for_each = local.create_custom_org_eventbus_rules ? local.eventbus_rules_by_name : {}

  depends_on = [aws_cloudformation_stack.eventbus, aws_cloudformation_stack.eventbus_policy]
  name       = "eb-rules-${each.key}"
  parameters = {
    ConfigurationEBNameParam     = "${var.bus_name}"
    ConfigurationEBRuleNameParam = lookup(var.eventbus_event_pattern[each.key], "rulename")
    DescriptionParam             = lookup(var.eventbus_event_pattern[each.key], "description")
    EventPatternState            = var.eventbus_rule_state
    EventRuleTargetArn           = lookup(var.eventbus_event_pattern[each.key], "target")
    EventRuleTargetID            = lookup(var.eventbus_event_pattern[each.key], "id")
  }
  template_body = lookup(var.eventbus_event_pattern[each.key], "file")
}

resource "aws_cloudformation_stack" "eventbus_rule_custom_existing_by_name" {
  for_each = local.manage_existing_eventbus_rules ? local.eventbus_rules_by_name : {}

  name = "eb-rules-${each.key}"
  parameters = {
    ConfigurationEBNameParam     = "${var.bus_name}"
    ConfigurationEBRuleNameParam = lookup(var.eventbus_event_pattern[each.key], "rulename")
    DescriptionParam             = lookup(var.eventbus_event_pattern[each.key], "description")
    EventPatternState            = var.eventbus_rule_state
    EventRuleTargetArn           = lookup(var.eventbus_event_pattern[each.key], "target")
    EventRuleTargetID            = lookup(var.eventbus_event_pattern[each.key], "id")
  }
  template_body = lookup(var.eventbus_event_pattern[each.key], "file")
}
