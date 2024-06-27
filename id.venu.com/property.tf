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

resource "akamai_edge_hostname" "dev-id-venu-com-edgesuite-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = "IPV6_COMPLIANCE"
  edge_hostname = "dev-id.venu.com.edgesuite.net"
}

resource "akamai_edge_hostname" "id-venu-com-edgesuite-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = "IPV6_COMPLIANCE"
  edge_hostname = "id.venu.com.edgesuite.net"
}

resource "akamai_edge_hostname" "stage-id-venu-com-edgesuite-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = "IPV6_COMPLIANCE"
  edge_hostname = "stage-id.venu.com.edgesuite.net"
}

resource "akamai_property" "id-venu-com" {
  name        = "id.venu.com"
  contract_id = var.contract_id
  group_id    = var.group_id
  product_id  = "prd_API_Accel"
  hostnames {
    cname_from             = "dev-id.venu.com"
    cname_to               = akamai_edge_hostname.dev-id-venu-com-edgesuite-net.edge_hostname
    cert_provisioning_type = "DEFAULT"
  }
  hostnames {
    cname_from             = "id.venu.com"
    cname_to               = akamai_edge_hostname.id-venu-com-edgesuite-net.edge_hostname
    cert_provisioning_type = "DEFAULT"
  }
  hostnames {
    cname_from             = "stage-id.venu.com"
    cname_to               = akamai_edge_hostname.stage-id-venu-com-edgesuite-net.edge_hostname
    cert_provisioning_type = "DEFAULT"
  }
  rule_format = "latest"
  rules       = data.akamai_property_rules_template.rules.json
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "id-venu-com-staging" {
  property_id                    = akamai_property.id-venu-com.id
  contact                        = ["jeff.grubb@fox.com", "ipogakul@akamai.com"]
  version                        = var.activate_latest_on_staging ? akamai_property.id-venu-com.latest_version : akamai_property.id-venu-com.staging_version
  network                        = "STAGING"
  note                           = "Fixing Access-Control-Allow-Methods header response"
  auto_acknowledge_rule_warnings = false
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "id-venu-com-production" {
  property_id                    = akamai_property.id-venu-com.id
  contact                        = ["jeff.grubb@fox.com", "ipogakul@akamai.com"]
  version                        = var.activate_latest_on_production ? akamai_property.id-venu-com.latest_version : akamai_property.id-venu-com.production_version
  network                        = "PRODUCTION"
  note                           = "Fixing Access-Control-Allow-Methods header response"
  auto_acknowledge_rule_warnings = false
}
