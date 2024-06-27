terraform init
terraform import akamai_edge_hostname.dev-id-venu-com-edgesuite-net ehn_5608942,ctr_V-4WBXKS2,grp_247987
terraform import akamai_edge_hostname.id-venu-com-edgesuite-net ehn_5608941,ctr_V-4WBXKS2,grp_247987
terraform import akamai_edge_hostname.stage-id-venu-com-edgesuite-net ehn_5608940,ctr_V-4WBXKS2,grp_247987
terraform import akamai_property.id-venu-com prp_1054141,ctr_V-4WBXKS2,grp_247987,LATEST
terraform import akamai_property_activation.id-venu-com-staging prp_1054141:STAGING
terraform import akamai_property_activation.id-venu-com-production prp_1054141:PRODUCTION
