terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 6.0.0"
    }
  }
  required_version = ">= 1.0"
}

provider "akamai" {
  edgerc         = var.edgerc_path
  config_section = var.config_section
}

data "akamai_property_rules_template" "rules" {
  template_file = abspath("${path.module}/property-snippets/main.json")
}

resource "akamai_edge_hostname" "qa1-api3-fox-com-edgekey-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = "IPV4"
  edge_hostname = "qa1.api3.fox.com.edgekey.net"
}

resource "akamai_edge_hostname" "san-fox-com-edgekey-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = "IPV4"
  edge_hostname = "san.fox.com.edgekey.net"
}

resource "akamai_property" "qa1-api3-fox-com" {
  name        = "qa1.api3.fox.com"
  contract_id = var.contract_id
  group_id    = var.group_id
  product_id  = "prd_Fresca"
  hostnames {
    cname_from             = "qa-ml.fox.com"
    cname_to               = akamai_edge_hostname.qa1-api3-fox-com-edgekey-net.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  hostnames {
    cname_from             = "qa1.api3.fox.com"
    cname_to               = akamai_edge_hostname.qa1-api3-fox-com-edgekey-net.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  hostnames {
    cname_from             = "uw2-1.qa1.api3.fox.com"
    cname_to               = akamai_edge_hostname.san-fox-com-edgekey-net.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  rule_format = "latest"
  rules       = data.akamai_property_rules_template.rules.json
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "qa1-api3-fox-com-staging" {
  property_id                    = akamai_property.qa1-api3-fox-com.id
  contact                        = ["aprasad@akamai.com", "jeff.grubb@fox.com"]
  version                        = var.activate_latest_on_staging ? akamai_property.qa1-api3-fox-com.latest_version : akamai_property.qa1-api3-fox-com.staging_version
  network                        = "STAGING"
  note                           = "Fixing /v3 request method for account accountops"
  auto_acknowledge_rule_warnings = false
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "qa1-api3-fox-com-production" {
  property_id                    = akamai_property.qa1-api3-fox-com.id
  contact                        = ["aprasad@akamai.com", "jeff.grubb@fox.com"]
  version                        = var.activate_latest_on_production ? akamai_property.qa1-api3-fox-com.latest_version : akamai_property.qa1-api3-fox-com.production_version
  network                        = "PRODUCTION"
  note                           = "Fixing /v3 request method for account accountops"
  auto_acknowledge_rule_warnings = false
}
