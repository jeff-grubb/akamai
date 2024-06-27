terraform init
terraform import akamai_edge_hostname.qa1-api3-fox-com-edgekey-net ehn_5243824,ctr_3-9I38ZU,grp_21681
terraform import akamai_edge_hostname.san-fox-com-edgekey-net ehn_1466184,ctr_3-9I38ZU,grp_21681
terraform import akamai_property.qa1-api3-fox-com prp_541586,ctr_3-9I38ZU,grp_21681,LATEST
terraform import akamai_property_activation.qa1-api3-fox-com-staging prp_541586:STAGING
terraform import akamai_property_activation.qa1-api3-fox-com-production prp_541586:PRODUCTION
