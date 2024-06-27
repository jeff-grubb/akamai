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

resource "akamai_edge_hostname" "dev-id-getxosports-com-edgesuite-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = "IPV6_COMPLIANCE"
  edge_hostname = "dev-id.getxosports.com.edgesuite.net"
}

resource "akamai_edge_hostname" "id-getxosports-com-edgesuite-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = "IPV6_COMPLIANCE"
  edge_hostname = "id.getxosports.com.edgesuite.net"
}

resource "akamai_edge_hostname" "stage-id-getxosports-com-edgesuite-net" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = "IPV6_COMPLIANCE"
  edge_hostname = "stage-id.getxosports.com.edgesuite.net"
}

resource "akamai_property" "id-getxosports-com" {
  name        = "id.getxosports.com"
  contract_id = var.contract_id
  group_id    = var.group_id
  product_id  = "prd_API_Accel"
  hostnames {
    cname_from             = "dev-id.getxosports.com"
    cname_to               = akamai_edge_hostname.dev-id-getxosports-com-edgesuite-net.edge_hostname
    cert_provisioning_type = "DEFAULT"
  }
  hostnames {
    cname_from             = "id.getxosports.com"
    cname_to               = akamai_edge_hostname.id-getxosports-com-edgesuite-net.edge_hostname
    cert_provisioning_type = "DEFAULT"
  }
  hostnames {
    cname_from             = "stage-id.getxosports.com"
    cname_to               = akamai_edge_hostname.stage-id-getxosports-com-edgesuite-net.edge_hostname
    cert_provisioning_type = "DEFAULT"
  }
  rule_format = "latest"
  rules       = data.akamai_property_rules_template.rules.json
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "id-getxosports-com-staging" {
  property_id                    = akamai_property.id-getxosports-com.id
  contact                        = ["jeff.grubb@fox.com", "aprasad@akamai.com"]
  version                        = var.activate_latest_on_staging ? akamai_property.id-getxosports-com.latest_version : akamai_property.id-getxosports-com.staging_version
  network                        = "STAGING"
  note                           = "Disable tiered distribution"
  auto_acknowledge_rule_warnings = false
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "id-getxosports-com-production" {
  property_id                    = akamai_property.id-getxosports-com.id
  contact                        = ["jeff.grubb@fox.com", "aprasad@akamai.com"]
  version                        = var.activate_latest_on_production ? akamai_property.id-getxosports-com.latest_version : akamai_property.id-getxosports-com.production_version
  network                        = "PRODUCTION"
  note                           = "Disable tiered distribution"
  auto_acknowledge_rule_warnings = false
}
