terraform init
terraform import akamai_edge_hostname.dev-id-getxosports-com-edgesuite-net ehn_5535483,ctr_V-4WBXKS2,grp_247987
terraform import akamai_edge_hostname.id-getxosports-com-edgesuite-net ehn_5535485,ctr_V-4WBXKS2,grp_247987
terraform import akamai_edge_hostname.stage-id-getxosports-com-edgesuite-net ehn_5535484,ctr_V-4WBXKS2,grp_247987
terraform import akamai_property.id-getxosports-com prp_1022700,ctr_V-4WBXKS2,grp_247987,LATEST
terraform import akamai_property_activation.id-getxosports-com-staging prp_1022700:STAGING
terraform import akamai_property_activation.id-getxosports-com-production prp_1022700:PRODUCTION
