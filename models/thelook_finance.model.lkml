connection: "default_bigquery_connection"

# 1. Include Governed Views & Explore Templates from the Central Hub
include: "//thelook-antigravity/thelook_views/**/*.view.lkml"
include: "//thelook-antigravity/explores/thelook_hub.explore.lkml"

# 2. Include Local Finance Spoke Views & Refinements
include: "/views/*.view.lkml"

# Default datagroup required by central PDTs (user_order_facts)
datagroup: thelook_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM `sampitcher-playground.the_look_ca.order_items_table` ;;
  max_cache_age: "4 hours"
}

datagroup: finance_eod_datagroup {
  sql_trigger: SELECT CURRENT_DATE() ;;
  max_cache_age: "12 hours"
}

access_grant: pii_data {
  user_attribute: can_see_pii
  allowed_values: ["Yes", "yes", "true"]
}

persist_with: finance_eod_datagroup

# 3. Refined Hub Explores with Finance Branding & Accounting Focus (Unhidden for Finance)
explore: +order_items {
  hidden: no
  label: "Finance: Revenue & Tax Accounting"
  description: "Financial performance, margin breakdown, and tax liability"
  group_label: "Finance Spoke"
}

explore: +orders {
  hidden: no
  label: "Finance: Order Audit Trail"
  description: "Reconciled order history"
  group_label: "Finance Spoke"
}

# 4. Extended Custom Departmental Explore (Extends Pattern)
explore: finance_high_value_audits {
  from: order_items_ext
  label: "Finance: High-Value Transaction Audits"
  group_label: "Finance Spoke"

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${finance_high_value_audits.user_id} ;;
  }

  join: inventory_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_items.id} = ${finance_high_value_audits.inventory_item_id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
}
