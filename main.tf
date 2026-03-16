locals {
  matching_env_keys = [
    for x in keys(local.env_mapping) : x
    if anytrue([
      for env in local.env_mapping[x] : can(regex(env, lower(var.environment)))
    ])
  ]

  tags = {
    tier               = var.tier
    application        = var.application != "" ? var.application : "unknown"
    dataclassification = var.data_classification
    automation         = jsonencode(var.automation)
    type               = var.type
    note               = var.note
  }
  global_tags = {
    platform          = var.platform
    domain            = var.domain
    creator           = var.creator
    expiresAfter      = var.expiration_date
    owner             = var.owner
    criticality       = var.criticality
    costcentre        = var.costcentre
    businessArea      = var.business_area
    environment       = var.environment
    crime_environment = length(local.matching_env_keys) == 1 ? local.matching_env_keys[0] : "unknown"
    project           = var.project
    tier              = var.tier
  }
  global_dynamic_tags = {
    created_time  = var.tag_created_time
    created_by    = var.tag_created_by
    builtFrom     = var.tag_git_url
    builtbranch   = var.tag_git_branch
    last_apply    = var.tag_last_apply
    last_apply_by = var.tag_last_apply_by
    timestamp     = var.timestamp != null ? var.timestamp : formatdate("DDMMYY", timestamp())
  }
  locations = {
    uks = "uksouth"
    ukw = "ukwest"
  }
  prefixes = {
    api_connection          = "apic"
    api_management_services = "apim"
    app_registration        = "spn"
    app_service_plan        = "plan"
    application_gateway     = "agw"
  }
  global_azure_location                  = "uksouth"
  global_azure_read_replication_location = "ukwest"
  prefix_default_route                   = "0.0.0.0/0"
  env = {
    environment_short_name_lower          = "mdv"
    environment_mgmt_lower                = "mdv"
    environment_dns_third_octet           = "88"
    environment_realm                     = "CPP.NONLIVE"
    environment_domain                    = "cpp.nonlive"
    environment_platform                  = "nlv"
    environment_adds_account              = "domainjoin"
    environment_jenkins_app_id            = "1a0172bd-5e9d-4017-aab3-0756c7dbd7cf"
    environment_admin_group_id            = "c1c0dad5-6923-4ab4-a5c4-360e5e2a7971"
    environment_oms_rg                    = "RG-MDV-INT-01"
    environment_oms_name                  = "oms-cpp-nonlive"
    environment_storage_account_repl_type = "GRS"
    tier_short_name_lower                 = "int"
    environment_dns_resolvers             = []
  }
  env_mapping = {
    management-layer = ["mgmt", "management", "mdv", "mpd"]
    production       = ["ptl", "prod", "prod-int", "prx", "prd", "live"]
    development      = ["dev", "preview"]
    staging          = ["ldata", "stg", "aat", "nle", "nonprod", "nonprodi", "prp", "preprod", "nonlive"]
    testing          = ["test", "perftest", "sit", "nft", "ste"]
    sandbox          = ["sandbox", "sbox", "ptlsbox", "sbox-int", "lab"]
    demo             = ["demo"]
    ithc             = ["ithc"]
  }
  azure = {
    resource_group_name       = "RG-${upper(local.env.environment_short_name_lower)}-${upper(local.env.tier_short_name_lower)}-01"
    app_backup_rg             = "RG-${upper(local.env.environment_short_name_lower)}-BACKUP-${upper(local.env.tier_short_name_lower)}"
    default_vm_size           = "Standard_DS1_v2"
    default_kali_vm_size      = "Standard_DS2_v2"
    standard_vm_size          = "Standard_D4s_v3"
    latest_cimaster_vm_size   = "Standard_E4as_v4"
    cimaster_vm_size          = "Standard_E8s_v3"
    default_db_vm_size        = "Standard_E8s_v3"
    premium_disk              = "Premium_LRS"
    standard_disk             = "Standard_LRS"
    storage_account           = "sa${local.env.environment_short_name_lower}${local.env.tier_short_name_lower}01"
    storage_account_repl_type = "${local.env.environment_storage_account_repl_type}"
    storage_container         = "sa${local.env.environment_short_name_lower}${local.env.tier_short_name_lower}01-container"
    storage_container_images  = "sa${local.env.environment_short_name_lower}${local.env.tier_short_name_lower}01-container-images"
    storage_container_NFS     = "sa${local.env.environment_short_name_lower}${local.env.tier_short_name_lower}01-nfs"
    tfstate_storage_account   = "sa${local.env.environment_mgmt_lower}shared01"
    tfstate_storage_container = "sa${local.env.environment_mgmt_lower}shared01-container-tfstates"
    scripts_storage_account   = "sa${local.env.environment_mgmt_lower}shared01"
    scripts_storage_container = "sa${local.env.environment_mgmt_lower}shared01-container-scripts"
    domainjoin_user           = "${local.env.environment_adds_account}"
    realm                     = "${local.env.environment_realm}"
    redis_cache_elk_name      = "${local.identifiers.redis_cache}-${upper(local.env.environment_short_name_lower)}-${upper(local.env.tier_short_name_lower)}-ELK"
    domain                    = "${local.env.environment_domain}"
    mgmt_tier                 = "${local.env.environment_mgmt_lower}"
    patching_tag              = "${var.environment_patching_tag}"
  }
  identifiers = {
    application_gateway        = "GW"
    application_security_group = "AG"
    availability_set           = "AS"
    encryption_key             = "EK"
    eventhub                   = "EH"
    eventhub_auth_rule         = "ER"
    eventhub_namespace         = "EN"
    key_vault                  = "KV"
    load_balancer              = "LB"
    nic                        = "NI"
    postgresql                 = "PS"
    redis_cache                = "RC"
    resource_group             = "RG"
    resource_lock              = "RL"
    subnet                     = "SN"
    udr                        = "UR"
    vip                        = "IP"
    virtual_machine            = "VM"
    vnet                       = "VN"
    vnet_gateway               = "VG"
    local_net_gateway          = "LNG"
  }
  environments = {
    dmo                    = "DMO"
    ste                    = "STE"
    dev                    = "DEV"
    management_development = "MDV"
    management_production  = "MPD"
    nft                    = "NFT"
    nle                    = "NLE"
    lve                    = "LVE"
    prd                    = "PRD"
    prp                    = "PRP"
    prx                    = "PRX"
    sit                    = "SIT"
  }
  external_ntp_sources = {
    npl_source_1 = "139.143.5.30"
    npl_source_2 = "139.143.5.31"
    leo_source_1 = "188.39.213.7"
    leo_source_2 = "85.199.214.102"
  }
  sh_office_ips = {
    range_1 = "167.98.162.96/28"
    range_2 = "62.6.59.98"
    range_3 = "5.148.40.98"
    # range_4 = "167.98.162.96/28"
  }
  dom1_ips = {
    range_1 = "157.203.177.19"
    range_2 = "157.203.177.190"
    range_3 = "195.59.75.0/24"
    range_4 = "194.33.192.0/25"
    range_5 = "194.33.196.0/25"
    range_6 = "194.33.193.0/25"
    range_7 = "194.33.197.0/25"
    range_8 = "51.149.249.0/27"
    range_9 = "51.149.249.32/27"
  }
  cgi_aem_ips = {
    range_1 = "163.164.232.146"
    range_2 = "163.164.232.147"
    range_3 = "185.157.224.136/29"
    range_4 = "185.157.225.136/29"
  }
  lv-vnet-scheme = {
    address_space_vnet                   = "10.200.0.0/16"
    address_prefix-subnet-ci             = "10.200.48.0/27"
    address_prefix-subnet-prp-cislave    = "10.201.64.0/24"
    address_prefix-subnet-prd-cislave    = "10.202.64.0/24"
    address_prefix-subnet-yumrepo        = "10.200.48.64/27"
    address_prefix-subnet-artrepo        = "10.200.48.192/27"
    address_prefix-subnet-prpbae-cislave = "10.203.62.0/24"
  }
  nlv-vnet-scheme = {
    address_space_vnet = "10.88.0.0/14"
  }
  nle-ccp-vnet-scheme = {
    address_space_vnet = "10.93.0.0/20"
  }
  mdv-dmz-vnet-scheme = {
    address_space_vnet               = "10.88.112.0/20"
    address_prefix-subnet-adminvpn   = "10.88.112.0/27"
    address_prefix-subnet-dmzjumpl   = "10.88.112.32/27"
    address_prefix-subnet-publishing = "10.88.112.64/27"
    address_prefix-subnet-ngf        = "10.88.112.96/27"
    address_prefix-subnet-dmzntp     = "10.88.112.128/27"
    address_prefix-subnet-vpnusers   = "10.88.124.0/22"
    address_prefix-subnet-vpnusers1  = "10.88.120.0/22"
    address_prefix-subnet-vpnusers2  = "10.88.116.0/22"
    address_prefix-subnet-bastion    = "10.88.114.0/24"
  }
  mdv-int-vnet-scheme = {
    address_space_vnet                 = "10.88.128.0/20"
    address_prefix-subnet-ci           = "10.88.128.0/27"
    address_prefix-subnet-jumpl        = "10.88.128.32/27"
    address_prefix-subnet-yumrepo      = "10.88.128.64/27"
    address_prefix-subnet-secret       = "10.88.128.96/27"
    address_prefix-subnet-crev         = "10.88.128.192/27"
    address_prefix-subnet-artrepo      = "10.88.129.0/27"
    address_prefix-subnet-adds-gateway = "10.88.129.32/27"
    address_prefix-subnet-secretbe     = "10.88.129.64/27"
    address_prefix-subnet-sonarqube    = "10.88.129.96/27"
    address_prefix-subnet-ntp          = "10.88.129.128/27"
    address_prefix-subnet-monitoring   = "10.88.129.160/27"
    address_prefix-subnet-clamavmir    = "10.88.129.224/27"
    address_prefix-subnet-wafcc        = "10.88.130.0/27"
    address_prefix-subnet-vul-scan-cc  = "10.88.130.32/28"
    address_prefix-subnet-secretbe2    = "10.88.128.128/28"
    address_prefix-subnet-appgw2       = "10.88.132.0/27"
    address_prefix-subnet-pg-pem       = "10.88.132.32/28"
    address_prefix-subnet-appgw0       = "10.88.132.64/27"
    address_prefix-subnet-zabbix       = "10.88.133.0/27"
    address_prefix-subnet-elk          = "10.88.133.32/27"
    address_prefix-subnet-rc-elk       = "10.88.133.64/29"
    address_prefix_subnet_dynatrace    = "10.88.133.96/28"
    address_prefix-subnet-ngf-cc       = "10.88.135.0/29"
    address_prefix-subnet-appgw1       = "10.88.132.96/27"
    address_prefix-subnet-mgtprx       = "10.88.130.128/27"
  }
  mdv-imz-vnet-scheme = {
    address_space_vnet               = "10.88.144.0/20"
    address_prefix-subnet-ftps-inner = "10.88.144.32/29"
    address_prefix-subnet-ngf        = "10.88.156.0/28"

    address_prefix-subnet-cgi-darts = "10.72.1.0/24"

    address_prefix-subnet-cms-proxy = "10.88.145.0/29"
    address_prefix-subnet-darts-waf = "10.88.145.8/29"
    address_prefix-subnet-libra-ftp = "10.88.145.16/29"
    address_prefix-subnet-xhbit-ftp = "10.88.145.32/29"
    address_prefix-subnet-psnp-ftp  = "10.88.145.40/29"

    address_prefix-subnet-outbound-proxy = "10.88.155.24/29"

    address_prefix-imz-waf = "10.88.145.12"

    address_prefix-subnet-azure-vpn-gateways = "10.88.155.32/29"
    address_prefix-subnet-azure-vpn-cgi      = "172.28.165.0/24"
    address_prefix-subnet-azure-vpn-psn      = "10.25.255.66/32"
    address_prefix-azure-vpn-cgi_gateway     = "163.164.232.146"
    address_prefix-azure-vpn-psn_gateway     = "51.231.160.172"
    address_prefix-azure-leg-cgi_gateway     = "185.230.152.73"
    address_prefix-subnet-azure-leg-cgi      = "169.254.1.0/30"
    address_prefix-azure-leg-cgi_gateway-dr  = "185.230.154.73"
    address_prefix-subnet-azure-leg-cgi-dr   = "169.254.4.0/30"
    address_prefix-leg-cgi-bgp-peering       = "198.51.100.1"
    address_prefix-leg-cgi-dr-bgp-peering    = "198.51.100.2"

    address_prefix-azure-vpn-gateway-ark-c = "185.157.225.131"
    address_prefix-subnet-azure-vpn-ark-c  = "10.2.80.64/28"

    address_prefix-azure-vpn-gateway-ark-f = "185.157.224.131"
    address_prefix-subnet-azure-vpn-ark-f  = "10.3.80.64/28"
  }
  mdv-sbz-vnet-scheme = {
    address_space_vnet                = "10.88.160.0/20"
    address_prefix-subnet-cislave     = "10.88.160.0/27"
    address_prefix-subnet-alfresco    = "10.88.160.32/27"
    address_prefix-subnet-alfrescodb  = "10.88.160.64/27"
    address_prefix-subnet-owasp       = "10.88.160.96/27"
    address_prefix-subnet-ado-cislave = "10.88.161.0/24"
  }
  mdv-sbz2-vnet-scheme = {
    address_space_vnet           = "10.88.176.0/24"
    address_prefix-subnet-bld-vm = "10.88.176.0/29"
    address_prefix-subnet-kau    = "10.88.176.8/29"
  }
  mdv-ste-vnet-scheme = {
    address_space_vnet               = "10.88.176.0/24"
    address_prefix-subnet-webserver  = "10.88.176.0/27"
    address_prefix-subnet-alfresco   = "10.88.176.32/27"
    address_prefix-subnet-wildfly    = "10.88.176.64/27"
    address_prefix-subnet-artemis    = "10.88.176.96/27"
    address_prefix-subnet-alfrescodb = "10.88.176.160/27"
    address_prefix-subnet-contextdb  = "10.88.176.192/27"
    address_prefix-subnet-docmosis   = "10.88.176.224/27"
  }
  mpd-dmz-vnet-scheme = {
    address_space_vnet                    = "10.200.32.0/20"
    address_prefix-subnet-adminvpn        = "10.200.32.0/27"
    address_prefix-subnet-dmzjumpl        = "10.200.32.32/27"
    address_prefix-subnet-publishing      = "10.200.32.64/27"
    address_prefix-subnet-vpnusers        = "10.200.62.0/23"
    address_prefix-subnet-vpnusers1       = "10.200.36.0/22"
    address_prefix-subnet-vpnusers2       = "10.200.40.0/22"
    address_prefix-subnet-ngf             = "10.200.32.96/27"
    address_prefix-subnet-dmzntp          = "10.200.32.128/27"
    address_prefix-subnet-dmz-vul-scanner = "10.200.33.0/29"
    address_prefix-subnet-rc-elk          = "10.200.33.8/29"
    address_prefix-subnet-bastion         = "10.200.34.0/24"
  }
  mpd-int-vnet-scheme = {
    address_space_vnet                = "10.200.48.0/20"
    address_prefix-subnet-ci          = "10.200.48.0/27"
    address_prefix-subnet-jumpl       = "10.200.48.32/27"
    address_prefix-subnet-yumrepo     = "10.200.48.64/27"
    address_prefix-subnet-secret      = "10.200.48.96/27"
    address_prefix-subnet-artrepo     = "10.200.48.192/27"
    address_prefix-subnet-secretbe    = "10.200.49.64/27"
    address_prefix-subnet-ntp         = "10.200.49.128/27"
    address_prefix-subnet-kali        = "10.200.49.192/27"
    address_prefix-subnet-migvpn      = "10.200.60.0/29"
    address_prefix-subnet-clamavmir   = "10.200.49.224/27"
    address_prefix-subnet-vul-scan-cc = "10.200.60.16/28"
    address_prefix-subnet-baeci       = "10.203.62.0/24"
    address_prefix-subnet-wafcc       = "10.200.63.0/28"
    address_prefix-subnet-zabbix      = "10.200.50.0/27"
    address_prefix-subnet-appgw2      = "10.200.50.32/27"
    address_prefix-subnet-appgw3      = "10.200.50.64/27"
    address_prefix-subnet-elk         = "10.200.50.96/27"
    address_prefix-subnet-rc-elk      = "10.200.50.128/29"
    address_prefix-subnet-elkcache    = "10.200.50.136/29"
    address_prefix_subnet_dynatrace   = "10.200.50.160/28"
    address_prefix-subnet-pg-pem      = "10.200.50.192/28"
    address_prefix-subnet-ngf-cc      = "10.200.63.16/29"
    address_prefix-subnet-appgw1      = "10.200.50.224/27"
    address_prefix-subnet-mgtprx      = "10.200.48.128/27"
    address_prefix-subnet-ado-ci      = "10.200.51.128/25"
  }
  mpd-imz-vnet-scheme = {
    address_space_vnet               = "10.200.64.0/20"
    address_prefix-subnet-ftps-inner = "10.200.64.32/27"
    address_prefix-subnet-ngf        = "10.200.76.0/28"

    address_prefix-subnet-vpn-cms   = "10.200.75.0/29"
    address_prefix-subnet-vpn-darts = "10.200.75.8/29"
    address_prefix-subnet-vpn-libra = "10.200.75.16/29"

    address_prefix-subnet-cms-proxy = "10.200.65.0/29"
    address_prefix-subnet-darts-waf = "10.200.65.8/29"
    address_prefix-subnet-libra-ftp = "10.200.65.16/29"
    address_prefix-subnet-xhbit-ftp = "10.200.65.32/29"
    address_prefix-subnet-psnp-ftp  = "10.200.65.40/29"

    address_prefix-subnet-inbound-proxy  = "10.200.66.8/29"
    address_prefix-subnet-outbound-proxy = "10.200.75.24/29"

    address_prefix-subnet-azure-vpn-gateways = "10.200.65.160/29"
    address_prefix-azure-vpn-cgi_gateway     = "163.164.232.110"
    address_prefix-subnet-azure-vpn-cgi      = "10.2.80.64/28"
    /*
 *  I am sure we can delete those entries ...
 *  address_prefix-subnet-azure-vpn-cgi      = "172.28.165.0/24"
 */

    address_prefix-azure-vpn-gateway-ark-c = "185.157.225.131"
    address_prefix-subnet-azure-vpn-ark-c  = "10.2.80.64/28"

    address_prefix-azure-vpn-gateway-ark-f = "185.157.224.131"
    address_prefix-subnet-azure-vpn-ark-f  = "10.3.80.64/28"

    address_prefix-azure-leg-cgi_gateway           = "185.230.152.73"
    address_prefix-azure-leg-cgi_gateway-dr        = "185.230.154.73"
    address_prefix-subnet-azure-libra-cgi          = "10.100.198.0/27"
    address_prefix-subnet-azure-libra-cgi_outbound = "10.100.197.0/24"

    address_prefix-leg-cgi-bgp-peering    = "198.51.100.5"
    address_prefix-leg-cgi-bgp-peering-dr = "198.51.100.6"

    address_prefix-subnet-imz-vul-scanner = "10.200.66.0/29"
  }
  nlv-app-conf-vnet-scheme = {
    address_space_vnet                           = "10.93.0.0/20"
    address_prefix-subnet-CCP0101-Feature-Toggle = "10.93.1.0/27"
  }
  lve-app-conf-vnet-scheme = {
    address_space_vnet                           = "10.204.0.0/20"
    address_prefix-subnet-CCP0101-Feature-Toggle = "10.204.1.0/27"
  }
  ste-vnet-scheme = {
    address_space_vnet               = "10.87.0.0/16"
    address_prefix-subnet-ops        = "10.87.0.0/24"
    address_prefix-subnet-ccm-web    = "10.87.10.0/23"
    address_prefix-subnet-ccm-app    = "10.87.12.0/23"
    address_prefix-subnet-ccm-dat    = "10.87.14.0/23"
    address_prefix-subnet-wfm-gtw-01 = "10.87.20.0/27"
    address_prefix-subnet-wfm-app-01 = "10.87.20.32/27"

    # PAAS stuff
    address_prefix-subnet-rc-laa1    = "10.87.127.240/28"
    address_prefix-subnet-rc-common  = "10.87.127.224/28"
    address_prefix-subnet-laa1       = "10.87.127.208/28"
    address_prefix-subnet-sd-common  = "10.87.127.192/28"
    address_prefix-subnet-csfl       = "10.87.127.160/28"
    address_prefix-subnet-blks       = "10.87.127.144/28"
    address_prefix-subnet-laa        = "10.87.127.128/28"
    address_prefix-subnet-scsl       = "10.87.127.112/28"
    address_prefix-subnet-sa-common  = "10.87.127.104/29"
    address_prefix-subnet-kv-common  = "10.87.127.96/29"
    address_prefix-subnet-blks-1     = "10.87.127.88/29"
    address_prefix-subnet-notifyatt  = "10.87.127.64/28"
    address_prefix-subnet-rc-common1 = "10.87.127.0/28" # temp fix to provision the correct common RC

    # Funcation Apps
    # az network vnet subnet list --resource-group RG-STE-INT-01 --vnet-name VN-STE-INT-01 --query "[?delegations[?serviceName=='Microsoft.Web/serverFarms']].{Name:name, Delegated:delegations[0].serviceName, CIDR:addressPrefix}" -o json | jq -r 'map({("address_prefix-subnet-" + (.Name | sub("sn-ste-"; "") | sub("fa-ste-"; "") | sub("SN-STE-"; ""))): .CIDR}) | add | to_entries | .[] | "\(.key) = \"\(.value)\""'
    address_prefix-subnet-casefilter             = "10.87.1.16/28"
    address_prefix-subnet-ccm-scsl               = "10.87.1.48/28"
    address_prefix-subnet-ccp0102-courtreg       = "10.87.1.128/28"
    address_prefix-subnet-sandlspike             = "10.87.4.208/28"
    address_prefix-subnet-deletenow              = "10.87.4.224/28"
    address_prefix-subnet-scan-processor         = "10.87.1.0/28"
    address_prefix-subnet-ccp0102-scsl           = "10.87.40.48/28"
    address_prefix-subnet-ccp0103-casefilter     = "10.87.41.16/28"
    address_prefix-subnet-ccp0103-notifyatt      = "10.87.41.32/28"
    address_prefix-subnet-ccp0103-scsl           = "10.87.41.48/28"
    address_prefix-subnet-ccp0103-legalaidagency = "10.87.41.64/28"
    address_prefix-subnet-rc-ccp0102             = "10.87.42.0/28"
    address_prefix-subnet-ccp0104-legalaidagency = "10.87.41.80/28"
    address_prefix-subnet-laa                    = "10.87.1.32/28"
    address_prefix-subnet-ccp0103-bulkscan       = "10.87.41.0/28"
    address_prefix-subnet-ccp0101-bulkscan       = "10.87.1.64/27"
    address_prefix-subnet-CCP0101-FA-FTOGGLE     = "10.87.128.0/24"
    address_prefix-subnet-CCP0101-FA-UTILITYAPPS = "10.87.44.0/27"
    address_prefix-subnet-ccp0101-notifyatt      = "10.87.127.64/28"
    address_prefix-subnet-ccp0101-legalaid       = "10.87.50.0/28"
    address_prefix-subnet-ccp0101-nowsce         = "10.87.50.16/28"
    address_prefix-subnet-ccp0101-prisoncourtreg = "10.87.50.32/28"
    address_prefix-subnet-ccp0101-courtreg       = "10.87.50.48/28"
    address_prefix-subnet-ccp0101-informantreg   = "10.87.50.64/28"
    address_prefix-subnet-ccp0101-courtorders    = "10.87.50.80/28"
    address_prefix-subnet-ccp0101-hmpps          = "10.87.50.96/28"
    address_prefix-subnet-ccp0102-legalaid       = "10.87.50.112/28"
    address_prefix-subnet-ccp0102-prisoncourtreg = "10.87.50.192/28"
    address_prefix-subnet-ccp0103-courtorders    = "10.87.50.224/28"
    address_prefix-subnet-ccp0103-courtreg       = "10.87.51.0/28"
    address_prefix-subnet-ccp0103-informantreg   = "10.87.51.16/28"
    address_prefix-subnet-ccp0103-legalaid       = "10.87.51.32/28"
    address_prefix-subnet-ccp0103-nowsce         = "10.87.51.48/28"
    address_prefix-subnet-ccp0103-prisoncourtreg = "10.87.51.64/28"
    address_prefix-subnet-ccp0104-courtorders    = "10.87.51.96/28"
    address_prefix-subnet-ccp0104-courtreg       = "10.87.51.112/28"
    address_prefix-subnet-ccp0104-informantreg   = "10.87.51.128/28"
    address_prefix-subnet-ccp0104-legalaid       = "10.87.51.144/28"
    address_prefix-subnet-ccp0104-nowsce         = "10.87.51.160/28"
    address_prefix-subnet-ccp0104-prisoncourtreg = "10.87.51.176/28"
    address_prefix-subnet-ccp0105-courtorders    = "10.87.51.208/28"
    address_prefix-subnet-ccp0105-courtreg       = "10.87.51.224/28"
    address_prefix-subnet-ccp0105-informantreg   = "10.87.52.0/28"
    address_prefix-subnet-ccp0105-legalaid       = "10.87.52.16/28"
    address_prefix-subnet-ccp0105-nowsce         = "10.87.52.32/28"
    address_prefix-subnet-ccp0105-prisoncourtreg = "10.87.52.48/28"
    address_prefix-subnet-ccp0106-courtorders    = "10.87.52.80/28"
    address_prefix-subnet-ccp0106-courtreg       = "10.87.52.96/28"
    address_prefix-subnet-ccp0106-informantreg   = "10.87.52.112/28"
    address_prefix-subnet-ccp0106-legalaid       = "10.87.52.128/28"
    address_prefix-subnet-ccp0106-nowsce         = "10.87.52.144/28"
    address_prefix-subnet-ccp0106-prisoncourtreg = "10.87.52.160/28"
    address_prefix-subnet-ccp0107-courtorders    = "10.87.52.192/28"
    address_prefix-subnet-ccp0107-courtreg       = "10.87.52.208/28"
    address_prefix-subnet-ccp0107-informantreg   = "10.87.52.224/28"
    address_prefix-subnet-ccp0107-legalaid       = "10.87.53.0/28"
    address_prefix-subnet-ccp0107-nowsce         = "10.87.53.16/28"
    address_prefix-subnet-ccp0107-prisoncourtreg = "10.87.53.32/28"
    address_prefix-subnet-ccp0108-nowsce         = "10.87.53.128/28"
    address_prefix-subnet-ccp0108-legalaid       = "10.87.53.112/28"
    address_prefix-subnet-ccp0108-informantreg   = "10.87.53.96/28"
    address_prefix-subnet-ccp0108-courtreg       = "10.87.53.80/28"
    address_prefix-subnet-ccp0108-courtorders    = "10.87.53.64/28"
    address_prefix-subnet-ccp0108-prisoncourtreg = "10.87.53.144/28"
    address_prefix-subnet-ccp0109-courtorders    = "10.87.53.176/28"
    address_prefix-subnet-ccp0109-courtreg       = "10.87.53.192/28"
    address_prefix-subnet-ccp0109-informantreg   = "10.87.53.208/28"
    address_prefix-subnet-ccp0109-legalaid       = "10.87.53.224/28"
    address_prefix-subnet-ccp0109-nowsce         = "10.87.54.0/28"
    address_prefix-subnet-ccp0109-prisoncourtreg = "10.87.54.16/28"
    address_prefix-subnet-ccp0102-hmpps          = "10.87.50.208/28"
    address_prefix-subnet-ccp0103-hmpps          = "10.87.51.80/28"
    address_prefix-subnet-ccp0104-hmpps          = "10.87.51.192/28"
    address_prefix-subnet-ccp0106-hmpps          = "10.87.52.176/28"
    address_prefix-subnet-ccp0105-hmpps          = "10.87.52.64/28"
    address_prefix-subnet-ccp0107-hmpps          = "10.87.53.48/28"
    address_prefix-subnet-ccp0108-hmpps          = "10.87.53.160/28"
    address_prefix-subnet-ccp0109-hmpps          = "10.87.54.32/28"
    address_prefix-subnet-ccp0110-courtorders    = "10.87.54.48/28"
    address_prefix-subnet-ccp0110-courtreg       = "10.87.54.64/28"
    address_prefix-subnet-ccp0110-informantreg   = "10.87.54.80/28"
    address_prefix-subnet-ccp0110-legalaid       = "10.87.54.96/28"
    address_prefix-subnet-ccp0110-nowsce         = "10.87.54.112/28"
    address_prefix-subnet-ccp0110-prisoncourtreg = "10.87.54.128/28"
    address_prefix-subnet-ccp0110-hmpps          = "10.87.54.144/28"
    address_prefix-subnet-ccp0102-nowsce         = "10.87.50.160/27"
    address_prefix-subnet-ccp0102-nowsce2        = "10.87.50.128/27"
    address_prefix-subnet-rc-ccm-01              = "10.87.122.0/28"
    address_prefix-subnet-ccp0107-nowsce-complex = "10.87.54.192/28"
    address_prefix-subnet-ccp0109-nowsce-complex = "10.87.54.160/28"
    address_prefix-subnet-ccp0106-nowsce-complex = "10.87.54.208/28"
    address_prefix-subnet-ccp0105-nowsce-complex = "10.87.54.224/28"
    address_prefix-subnet-ccp0104-nowsce-complex = "10.87.54.240/28"
    address_prefix-subnet-ccp0103-nowsce-complex = "10.87.55.0/28"
    address_prefix-subnet-ccp0102-nowsce-complex = "10.87.55.16/28"
    address_prefix-subnet-ccp0101-nowsce-complex = "10.87.55.32/28"
    address_prefix-subnet-ccp0110-nowsce-complex = "10.87.55.64/28"
    address_prefix-subnet-ccp0108-nowsce-complex = "10.87.54.176/28"
    address_prefix-subnet-ccp0104-bulkscan       = "10.87.55.80/28"
    address_prefix-subnet-ccp0111-nowsce-complex = "10.87.55.96/28"
    address_prefix-subnet-ccp0111-courtorders    = "10.87.55.112/28"
    address_prefix-subnet-ccp0111-prisoncourtreg = "10.87.55.128/28"
    address_prefix-subnet-ccp0111-courtreg       = "10.87.55.144/28"
    address_prefix-subnet-ccp0111-informantreg   = "10.87.55.160/28"
    address_prefix-subnet-ccp0111-legalaid       = "10.87.55.176/28"
    address_prefix-subnet-ccp0112-nowsce-complex = "10.87.55.192/26"
    address_prefix-subnet-ccp0112-courtreg       = "10.87.56.0/26"
    address_prefix-subnet-ccp0113-nowsce-complex = "10.87.56.64/26"
    address_prefix-subnet-ccp0113-courtreg       = "10.87.56.128/26"
    address_prefix-subnet-ccp0114-nowsce-complex = "10.87.56.192/26"
    address_prefix-subnet-ccp0114-courtreg       = "10.87.57.0/26"
    address_prefix-subnet-ccp0115-nowsce-complex = "10.87.57.64/26"
    address_prefix-subnet-ccp0115-courtreg       = "10.87.57.128/26"
    address_prefix-subnet-ccp0101-dlrm           = "10.87.57.192/27"
    address_prefix-subnet-ccp0115-nowsce         = "10.87.7.0/27"
    address_prefix-subnet-ccp0111-hearingres     = "10.87.57.224/27"
    address_prefix-subnet-ccp0111-hearingres2    = "10.87.58.0/27"
    address_prefix-subnet-ccp0116-nowsce-complex = "10.87.58.32/27"
    address_prefix-subnet-ccp0116-courtreg       = "10.87.58.64/27"
    address_prefix-subnet-ccp0117-nowsce-complex = "10.87.58.96/27"
    address_prefix-subnet-ccp0117-courtreg       = "10.87.58.128/27"
    address_prefix-subnet-ccp0118-nowsce-complex = "10.87.58.160/27"
    address_prefix-subnet-ccp0118-courtreg       = "10.87.58.192/27"
    address_prefix-subnet-ccp0119-nowsce-complex = "10.87.58.224/27"
    address_prefix-subnet-ccp0119-courtreg       = "10.87.59.0/27"
    address_prefix-subnet-ccp0120-nowsce-complex = "10.87.59.32/27"
    address_prefix-subnet-ccp0120-courtreg       = "10.87.59.64/27"
    address_prefix-subnet-ccp0121-nowsce-complex = "10.87.59.96/27"
    address_prefix-subnet-ccp0121-courtreg       = "10.87.59.128/27"
  }

  dev-ccm-vnet-scheme = {
    address_space_vnet        = "10.89.64.0/18"
    address_space_vnet_w      = "10.150.0.0/16"
    address_prefix-subnet-ops = "10.89.64.0/24"

    address_prefix-subnet-web-01     = "10.89.65.0/27"
    address_prefix-subnet-app-01     = "10.89.78.0/26"
    address_prefix-subnet-data-01    = "10.89.65.64/27"
    address_prefix-subnet-wfm-gtw-01 = "10.89.65.96/27"
    address_prefix-subnet-wfm-app-01 = "10.89.65.128/27"

    address_prefix-subnet-web-02  = "10.89.66.0/26"
    address_prefix-subnet-app-02  = "10.89.66.64/26"
    address_prefix-subnet-data-02 = "10.89.66.128/26"

    address_prefix-subnet-web-03  = "10.89.67.0/26"
    address_prefix-subnet-app-03  = "10.89.67.64/26"
    address_prefix-subnet-data-03 = "10.89.67.128/26"

    address_prefix-subnet-web-04  = "10.89.68.0/26"
    address_prefix-subnet-app-04  = "10.89.68.64/26"
    address_prefix-subnet-data-04 = "10.89.68.128/26"

    address_prefix-subnet-web-05  = "10.89.69.0/26"
    address_prefix-subnet-app-05  = "10.89.69.64/26"
    address_prefix-subnet-data-05 = "10.89.69.128/26"

    address_prefix-subnet-web-06  = "10.89.71.0/26"
    address_prefix-subnet-app-06  = "10.89.71.64/26"
    address_prefix-subnet-data-06 = "10.89.71.128/26"

    address_prefix-subnet-web-07  = "10.89.72.0/26"
    address_prefix-subnet-app-07  = "10.89.72.64/26"
    address_prefix-subnet-data-07 = "10.89.72.128/26"

    address_prefix-subnet-web-08  = "10.89.73.0/26"
    address_prefix-subnet-app-08  = "10.89.73.64/26"
    address_prefix-subnet-data-08 = "10.89.73.128/26"

    address_prefix-subnet-web-09  = "10.89.74.0/26"
    address_prefix-subnet-app-09  = "10.89.74.64/26"
    address_prefix-subnet-data-09 = "10.89.74.128/26"

    address_prefix-subnet-web-10  = "10.89.80.0/24"
    address_prefix-subnet-app-10  = "10.89.81.0/24"
    address_prefix-subnet-data-10 = "10.89.82.0/24"

    address_prefix-subnet-web-11  = "10.89.83.0/24"
    address_prefix-subnet-app-11  = "10.89.84.0/24"
    address_prefix-subnet-data-11 = "10.89.85.0/24"

    address_prefix-subnet-web-12  = "10.89.86.0/24"
    address_prefix-subnet-app-12  = "10.89.87.0/24"
    address_prefix-subnet-data-12 = "10.89.88.0/24"

    address_prefix-subnet-web-13  = "10.89.89.0/24"
    address_prefix-subnet-app-13  = "10.89.90.0/24"
    address_prefix-subnet-data-13 = "10.89.91.0/24"

    address_prefix-subnet-web-14  = "10.89.92.0/24"
    address_prefix-subnet-app-14  = "10.89.93.0/24"
    address_prefix-subnet-data-14 = "10.89.94.0/24"

    address_prefix-subnet-web-15  = "10.89.95.0/24"
    address_prefix-subnet-app-15  = "10.89.96.0/24"
    address_prefix-subnet-data-15 = "10.89.97.0/24"

    address_prefix-subnet-web-16  = "10.89.98.0/24"
    address_prefix-subnet-app-16  = "10.89.99.0/24"
    address_prefix-subnet-data-16 = "10.89.100.0/24"

    address_prefix-subnet-web-17  = "10.89.101.0/24"
    address_prefix-subnet-app-17  = "10.89.102.0/24"
    address_prefix-subnet-data-17 = "10.89.103.0/24"

    address_prefix-subnet-web-18  = "10.89.104.0/24"
    address_prefix-subnet-app-18  = "10.89.105.0/24"
    address_prefix-subnet-data-18 = "10.89.106.0/24"

    address_prefix-subnet-web-19  = "10.89.107.0/24"
    address_prefix-subnet-app-19  = "10.89.108.0/24"
    address_prefix-subnet-data-19 = "10.89.109.0/24"

    address_prefix-subnet-web-20  = "10.89.110.0/24"
    address_prefix-subnet-app-20  = "10.89.111.0/24"
    address_prefix-subnet-data-20 = "10.89.112.0/24"

    address_prefix-subnet-web-21  = "10.89.113.0/24"
    address_prefix-subnet-app-21  = "10.89.114.0/24"
    address_prefix-subnet-data-21 = "10.89.115.0/24"



    #   This Subnet is never used so commented out and overlapping with DEV10
    #   address_prefix-subnet-int-kali = "10.89.80.64/27"

    address_prefix-subnet-rc-common = "10.89.127.224/28"

    address_prefix-subnet-apim-appgw = "10.89.127.248/29"
    address_prefix-subnet-apim-app   = "10.89.127.240/29"

    address_space_vnet_dmz         = "10.89.192.0/19"
    address_prefix-subnet-waf      = "10.89.192.0/27"
    address_prefix-subnet-dmz-kali = "10.89.192.32/29"

    # Funcation Apps
    # az network vnet subnet list --resource-group RG-DEV-CORE-01 --vnet-name VN-DEV-INT-01 --query "[?delegations[?serviceName=='Microsoft.Web/serverFarms']].{Name:name, Delegated:delegations[0].serviceName, CIDR:addressPrefix}" -o json | jq -r 'map({("address_prefix-subnet-" + (.Name | sub("sn-dev-"; "") | sub("fa-dev-"; "") | sub("SN-DEV-"; "") | sub("fn-dev-"; ""))): .CIDR}) | add | to_entries | .[] | "\(.key) = \"\(.value)\""'
    address_prefix-subnet-ccp0103-casefilter     = "10.89.127.208/28"
    address_prefix-subnet-ccp0103-notifyatt      = "10.89.127.32/28"
    address_prefix-subnet-ccp0101-scsl           = "10.89.127.176/28"
    address_prefix-subnet-sd-dev-ccp01           = "10.89.127.192/28"
    address_prefix-subnet-CCP0102-FA-SCSL        = "10.89.118.128/27"
    address_prefix-subnet-CCP0102-FA-NATT        = "10.89.118.32/27"
    address_prefix-subnet-CCP0102-FA-CSFL        = "10.89.118.64/27"
    address_prefix-subnet-CCP0102-FA-BKSN        = "10.89.118.96/27"
    address_prefix-subnet-DOC-CCM-09             = "10.89.65.96/27"
    address_prefix-subnet-DOC-CCM-HEARING-09     = "10.89.65.160/27"
    address_prefix-subnet-DOC-CCM-LISTING-09     = "10.89.65.128/27"
    address_prefix-subnet-ccp0101-notifyatt      = "10.89.127.64/28"
    address_prefix-subnet-ccp0101-legalaid       = "10.89.124.0/28"
    address_prefix-subnet-ccp0101-nowsce         = "10.89.124.16/28"
    address_prefix-subnet-ccp0101-prisoncourtreg = "10.89.124.32/28"
    address_prefix-subnet-ccp0101-courtreg       = "10.89.124.48/28"
    address_prefix-subnet-ccp0101-informantreg   = "10.89.124.64/28"
    address_prefix-subnet-ccp0101-courtorders    = "10.89.124.80/28"
    address_prefix-subnet-ccp0102-courtorders    = "10.89.124.112/28"
    address_prefix-subnet-ccp0102-courtreg       = "10.89.124.128/28"
    address_prefix-subnet-ccp0102-informantreg   = "10.89.124.144/28"
    address_prefix-subnet-ccp0102-legalaid       = "10.89.124.160/28"
    address_prefix-subnet-ccp0102-nowsce         = "10.89.124.176/28"
    address_prefix-subnet-ccp0102-prisoncourtreg = "10.89.124.192/28"
    address_prefix-subnet-ccp0101-hmpps          = "10.89.124.96/28"
    address_prefix-subnet-ccp0102-hmpps          = "10.89.124.208/28"
    address_prefix-subnet-cpp-004-casefilter     = "10.89.70.96/27"
    address_prefix-subnet-ccp-nowsce             = "10.89.125.0/26"
    address_prefix-subnet-ccp0103-nowsce         = "10.89.116.16/28"
    address_prefix-subnet-ccp0101-nowsce-complex = "10.89.116.32/28"
    address_prefix-subnet-ccp0102-nowsce-complex = "10.89.116.48/28"
    address_prefix-subnet-ccp0103-nowsce-complex = "10.89.116.0/28"
    address_prefix-subnet-common-fas             = "10.89.116.128/28"
    address_prefix-subnet-ccp0103-hearingres     = "10.89.119.64/26"
    address_prefix-subnet-ccp0106-nowsce         = "10.89.126.16/28"
    address_prefix-subnet-ccp0105-nowsce         = "10.89.125.64/28"
    address_prefix-subnet-ccp0105-nowsce-complex = "10.89.125.80/28"
    address_prefix-subnet-ccp0105-legalaid       = "10.89.125.96/28"
    address_prefix-subnet-ccp0105-prisoncourtreg = "10.89.125.112/28"
    address_prefix-subnet-ccp0105-courtreg       = "10.89.125.128/28"
    address_prefix-subnet-ccp0105-informantreg   = "10.89.125.144/28"
    address_prefix-subnet-ccp0105-courtorders    = "10.89.125.160/28"
    address_prefix-subnet-ccp0105-hmpps          = "10.89.125.176/28"
    address_prefix-subnet-ccp0105-bulkscan       = "10.89.65.32/28"
    address_prefix-subnet-ccp0101-bulkscan       = "10.89.126.0/28"
  }
  ste-fn-app-subnets = [
    local.ste-vnet-scheme.address_prefix-subnet-casefilter,
    local.ste-vnet-scheme.address_prefix-subnet-ccm-scsl,
    local.ste-vnet-scheme.address_prefix-subnet-sandlspike,
    local.ste-vnet-scheme.address_prefix-subnet-deletenow,
    local.ste-vnet-scheme.address_prefix-subnet-scan-processor,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0102-scsl,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-casefilter,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-notifyatt,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-scsl,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-legalaidagency,
    local.ste-vnet-scheme.address_prefix-subnet-rc-ccp0102,
    local.ste-vnet-scheme.address_prefix-subnet-laa,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-bulkscan,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0101-bulkscan,
    local.ste-vnet-scheme.address_prefix-subnet-CCP0101-FA-FTOGGLE,
    local.ste-vnet-scheme.address_prefix-subnet-CCP0101-FA-UTILITYAPPS,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0101-notifyatt,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0101-legalaid,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0101-nowsce,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0101-prisoncourtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0101-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0101-informantreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0101-courtorders,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0101-hmpps,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0101-dlrm,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0102-legalaid,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0102-prisoncourtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0102-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-courtorders,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-informantreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-legalaid,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-nowsce,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-prisoncourtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0104-courtorders,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0104-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0104-informantreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0104-legalaid,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0104-nowsce,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0104-prisoncourtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0104-legalaidagency,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0105-courtorders,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0105-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0105-informantreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0105-legalaid,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0105-nowsce,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0105-prisoncourtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0106-courtorders,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0106-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0106-informantreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0106-legalaid,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0106-nowsce,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0106-prisoncourtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0107-courtorders,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0107-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0107-informantreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0107-legalaid,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0107-nowsce,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0107-prisoncourtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0108-nowsce,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0108-legalaid,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0108-informantreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0108-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0108-courtorders,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0108-prisoncourtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0109-courtorders,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0109-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0109-informantreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0109-legalaid,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0109-nowsce,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0109-prisoncourtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0102-hmpps,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-hmpps,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0104-hmpps,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0106-hmpps,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0105-hmpps,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0107-hmpps,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0108-hmpps,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0109-hmpps,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0110-courtorders,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0110-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0110-informantreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0110-legalaid,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0110-nowsce,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0110-prisoncourtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0110-hmpps,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0102-nowsce,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0102-nowsce2,
    local.ste-vnet-scheme.address_prefix-subnet-rc-ccm-01,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0107-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0109-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0106-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0105-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0104-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0103-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0102-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0101-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0110-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0108-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0104-bulkscan,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0111-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0111-courtorders,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0111-prisoncourtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0111-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0111-informantreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0111-legalaid,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0111-hearingres,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0111-hearingres2,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0112-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0112-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0113-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0113-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0114-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0114-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0115-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0115-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0115-nowsce,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0116-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0116-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0117-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0117-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0118-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0118-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0119-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0119-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0120-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0120-courtreg,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0121-nowsce-complex,
    local.ste-vnet-scheme.address_prefix-subnet-ccp0121-courtreg,
  ]
  dev-fn-app-subnets = [
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0103-casefilter,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0103-notifyatt,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0101-scsl,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-sd-dev-ccp01,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-CCP0102-FA-SCSL,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-CCP0102-FA-NATT,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-CCP0102-FA-CSFL,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-CCP0102-FA-BKSN,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-DOC-CCM-09,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-DOC-CCM-HEARING-09,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-DOC-CCM-LISTING-09,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0101-notifyatt,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0101-legalaid,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0101-nowsce,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0101-prisoncourtreg,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0101-courtreg,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0101-informantreg,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0101-courtorders,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0102-courtorders,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0102-courtreg,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0102-informantreg,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0102-legalaid,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0102-nowsce,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0102-prisoncourtreg,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0101-hmpps,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0102-hmpps,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-cpp-004-casefilter,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp-nowsce,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0103-nowsce,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0101-nowsce-complex,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0102-nowsce-complex,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0103-nowsce-complex,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-common-fas,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0103-hearingres,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0106-nowsce,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0105-nowsce,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0105-nowsce-complex,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0105-legalaid,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0105-prisoncourtreg,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0105-courtreg,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0105-informantreg,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0105-courtorders,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0105-hmpps,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0105-bulkscan,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-ccp0101-bulkscan,

  ]
  dev-ccm-app-subnets = [
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-01,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-02,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-03,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-04,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-05,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-06,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-07,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-08,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-09,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-10,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-11,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-12,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-13,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-14,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-15,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-16,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-17,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-18,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-19,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-20,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-app-21,
  ]
  dev-ccm-web-subnets = [
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-01,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-02,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-03,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-04,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-05,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-06,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-07,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-08,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-09,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-10,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-11,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-12,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-13,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-14,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-15,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-16,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-17,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-18,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-19,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-20,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-web-21,
  ]
  dev-ccm-data-subnets = [
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-01,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-02,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-03,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-04,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-05,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-06,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-07,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-08,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-09,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-10,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-11,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-12,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-13,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-14,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-15,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-16,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-17,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-18,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-19,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-20,
    local.dev-ccm-vnet-scheme.address_prefix-subnet-data-21,
  ]
  sit-ccm-vnet-scheme = {
    address_space_vnet        = "10.90.64.0/18"
    address_prefix-subnet-ops = "10.90.64.0/24"

    address_prefix-subnet-web-01       = "10.90.65.0/27"
    address_prefix-subnet-app-01       = "10.90.65.32/27"
    address_prefix-subnet-app-audit-01 = "10.90.65.96/27"
    address_prefix-subnet-data-01      = "10.90.65.64/27"

    address_prefix-subnet-web-02  = "10.90.66.0/27"
    address_prefix-subnet-app-02  = "10.90.66.32/27"
    address_prefix-subnet-data-02 = "10.90.66.64/27"

    address_prefix-subnet-int-kali = "10.90.80.64/29"

    address_prefix-subnet-rc-common = "10.90.127.224/28"

    address_prefix-subnet-apim-appgw = "10.90.127.248/29"
    address_prefix-subnet-apim-app   = "10.90.127.240/29"

    address_space_vnet_dmz         = "10.90.192.0/19"
    address_prefix-subnet-waf      = "10.90.192.0/27"
    address_prefix-subnet-dmz-kali = "10.90.192.32/29"

    # Funcation Apps
    # az network vnet subnet list --resource-group RG-SIT-CORE-01 --vnet-name VN-SIT-INT-01 --query "[?delegations[?serviceName=='Microsoft.Web/serverFarms']].{Name:name, Delegated:delegations[0].serviceName, CIDR:addressPrefix}" -o json | jq -r 'map({("address_prefix-subnet-" + (.Name | sub("sn-sit-"; "") | sub("fa-sit-"; "") | sub("SN-SIT-"; "") | sub("fn-sit-"; ""))): .CIDR}) | add | to_entries | .[] | "\(.key) = \"\(.value)\""'
    address_prefix-subnet-ccp0101-bulkscan       = "10.90.126.0/28"
    address_prefix-subnet-ccp0101-casefilter     = "10.90.126.32/28"
    address_prefix-subnet-ccp0101-scsl           = "10.90.126.48/28"
    address_prefix-subnet-ccp0101-notifyatt      = "10.90.127.128/28"
    address_prefix-subnet-ccp0101-courtorders    = "10.90.124.0/28"
    address_prefix-subnet-ccp0101-courtreg       = "10.90.124.16/28"
    address_prefix-subnet-ccp0101-informantreg   = "10.90.124.32/28"
    address_prefix-subnet-ccp0101-legalaid       = "10.90.124.48/28"
    address_prefix-subnet-ccp0101-prisoncourtreg = "10.90.124.80/28"
    address_prefix-subnet-ccp0101-hmpps          = "10.90.124.96/28"
    address_prefix-subnet-ccp0101-nowsce-complex = "10.90.124.160/27"
    address_prefix-subnet-ccp0101-nowsce         = "10.90.124.128/27"
  }
  sit-ccm-app-subnets = [
    local.sit-ccm-vnet-scheme.address_prefix-subnet-app-01,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-app-02,
  ]
  sit-ccm-web-subnets = [
    local.sit-ccm-vnet-scheme.address_prefix-subnet-web-01,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-web-02,
  ]
  sit-ccm-data-subnets = [
    local.sit-ccm-vnet-scheme.address_prefix-subnet-data-01,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-data-02,
  ]
  sit-fn-app-subnets = [
    local.sit-ccm-vnet-scheme.address_prefix-subnet-ccp0101-bulkscan,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-ccp0101-casefilter,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-ccp0101-scsl,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-ccp0101-notifyatt,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-ccp0101-courtorders,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-ccp0101-courtreg,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-ccp0101-informantreg,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-ccp0101-legalaid,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-ccp0101-prisoncourtreg,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-ccp0101-hmpps,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-ccp0101-nowsce-complex,
    local.sit-ccm-vnet-scheme.address_prefix-subnet-ccp0101-nowsce,
  ]
  nft-ccm-vnet-scheme = {
    address_space_vnet        = "10.91.64.0/18"
    address_prefix-subnet-ops = "10.91.64.0/24"

    #   Second app tier "address_prefix-subnet-app-ext-01" is created due to app tier is run out of ip address
    address_prefix-subnet-web-01       = "10.91.65.0/27"
    address_prefix-subnet-app-01       = "10.91.65.32/27"
    address_prefix-subnet-app-audit-01 = "10.91.65.96/27"
    address_prefix-subnet-data-01      = "10.91.65.64/27"
    address_prefix-subnet-app-ext-01   = "10.91.67.0/24"

    # address_prefix-subnet-web-02  = "10.91.66.0/27"
    address_prefix-subnet-app-02 = "10.91.66.32/27"
    # address_prefix-subnet-data-02 = "10.91.66.64/27"

    address_prefix-subnet-rc-common = "10.91.127.224/28"
    address_prefix-subnet-sd-common = "10.91.127.192/28"


    address_prefix-subnet-apim-appgw = "10.91.127.248/29"
    address_prefix-subnet-apim-app   = "10.91.127.240/29"

    address_space_vnet_dmz    = "10.91.192.0/19"
    address_prefix-subnet-waf = "10.91.192.0/27"

    address_prefix-subnet-csfl      = "10.91.127.160/28"
    address_prefix-subnet-notifyatt = "10.91.127.112/28"

    # Funcation Apps
    # az network vnet subnet list --resource-group RG-NFT-CORE-01 --vnet-name VN-NFT-INT-01 --query "[?delegations[?serviceName=='Microsoft.Web/serverFarms']].{Name:name, Delegated:delegations[0].serviceName, CIDR:addressPrefix}" -o json | jq -r 'map({("address_prefix-subnet-" + (.Name | sub("sn-nft-"; "") | sub("fa-nft-"; "") | sub("SN-NFT-"; "") | sub("fn-nft-"; ""))): .CIDR}) | add | to_entries | .[] | "\(.key) = \"\(.value)\""'
    address_prefix-subnet-ccp0101-laa            = "10.91.126.16/28"
    address_prefix-subnet-ccp0101-scsl           = "10.91.126.48/28"
    address_prefix-subnet-ccp0101-casefilter     = "10.91.125.64/27"
    address_prefix-subnet-ccp0101-bulkscan       = "10.91.126.0/28"
    address_prefix-subnet-ccp0101-courtorders    = "10.91.124.0/28"
    address_prefix-subnet-ccp0101-courtreg       = "10.91.124.16/28"
    address_prefix-subnet-ccp0101-informantreg   = "10.91.124.32/28"
    address_prefix-subnet-ccp0101-legalaid       = "10.91.124.48/28"
    address_prefix-subnet-ccp0101-nowsce         = "10.91.124.64/28"
    address_prefix-subnet-ccp0101-prisoncourtreg = "10.91.124.80/28"
    address_prefix-subnet-ccp0101-hmpps          = "10.91.124.96/28"
    address_prefix-subnet-ccp0102-courtorders    = "10.91.124.112/28"
    address_prefix-subnet-ccp0102-courtreg       = "10.91.124.128/28"
    address_prefix-subnet-ccp0102-informantreg   = "10.91.124.144/28"
    address_prefix-subnet-ccp0102-legalaid       = "10.91.124.160/28"
    address_prefix-subnet-ccp0102-prisoncourtreg = "10.91.124.192/28"
    address_prefix-subnet-ccp0102-hmpps          = "10.91.124.208/28"
    address_prefix-subnet-ccp0102-bulkscan       = "10.91.126.32/28"
    address_prefix-subnet-ccp0102-casefilter     = "10.91.125.96/27"
    address_prefix-subnet-ccp0102-scsl           = "10.91.126.64/28"
    address_prefix-subnet-ccp0102-notifyatt      = "10.91.127.160/28"
    address_prefix-subnet-ccp0102-nowsce-complex = "10.91.125.0/27"
    address_prefix-subnet-ccp0102-nowsce         = "10.91.124.224/27"
  }
  nft-ccm01-app-subnets = [
    local.nft-ccm-vnet-scheme.address_prefix-subnet-app-01,
  ]
  nft-ccm02-app-subnets = [
    local.nft-ccm-vnet-scheme.address_prefix-subnet-app-02,
  ]
  nft-ccm-web-subnets = [
    local.nft-ccm-vnet-scheme.address_prefix-subnet-web-01,
  ]
  nft-ccm-data-subnets = [
    local.nft-ccm-vnet-scheme.address_prefix-subnet-data-01,
  ]
  nft-fn-app-subnets = [
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0101-laa,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0101-scsl,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0101-casefilter,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0101-bulkscan,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0101-courtorders,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0101-courtreg,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0101-informantreg,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0101-legalaid,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0101-nowsce,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0101-prisoncourtreg,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0101-hmpps,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0102-courtorders,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0102-courtreg,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0102-informantreg,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0102-legalaid,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0102-prisoncourtreg,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0102-hmpps,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0102-bulkscan,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0102-casefilter,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0102-scsl,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0102-notifyatt,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0102-nowsce-complex,
    local.nft-ccm-vnet-scheme.address_prefix-subnet-ccp0102-nowsce,
  ]
  ste-app-conf-subnets = [
    local.nlv-app-conf-vnet-scheme.address_prefix-subnet-CCP0101-Feature-Toggle,
  ]
  dev-app-conf-subnets = [
    local.nlv-app-conf-vnet-scheme.address_prefix-subnet-CCP0101-Feature-Toggle,
  ]
  sit-app-conf-subnets = [
    local.nlv-app-conf-vnet-scheme.address_prefix-subnet-CCP0101-Feature-Toggle,
  ]
  nft-app-conf-subnets = [
    local.nlv-app-conf-vnet-scheme.address_prefix-subnet-CCP0101-Feature-Toggle,
  ]
  dev-rota-vnet-scheme = {
    address_space_vnet        = "10.89.64.0/18"
    address_prefix-subnet-ops = "10.89.64.0/24"

    address_prefix-subnet-web-01  = "10.89.70.0/27"
    address_prefix-subnet-app-01  = "10.89.70.32/27"
    address_prefix-subnet-data-01 = "10.89.70.64/27"

    address_space_vnet_dmz         = "10.89.192.0/19"
    address_prefix-subnet-waf      = "10.89.192.0/27"
    address_prefix-subnet-dmz-kali = "10.89.192.32/29"
  }
  sit-rota-vnet-scheme = {
    address_space_vnet        = "10.90.64.0/18"
    address_prefix-subnet-ops = "10.90.64.0/24"

    address_prefix-subnet-web-01  = "10.90.70.0/27"
    address_prefix-subnet-app-01  = "10.90.70.32/27"
    address_prefix-subnet-data-01 = "10.90.70.64/27"

    address_space_vnet_dmz         = "10.90.192.0/19"
    address_prefix-subnet-waf      = "10.90.192.0/27"
    address_prefix-subnet-dmz-kali = "10.90.192.32/29"
  }
  nft-rota-vnet-scheme = {
    address_space_vnet        = "10.91.64.0/18"
    address_prefix-subnet-ops = "10.91.64.0/24"

    address_prefix-subnet-web-01  = "10.91.70.0/27"
    address_prefix-subnet-app-01  = "10.91.70.64/26"
    address_prefix-subnet-data-01 = "10.91.70.128/27"

    address_space_vnet_dmz    = "10.91.192.0/19"
    address_prefix-subnet-waf = "10.91.192.0/27"
  }
  prp-int-vnet-scheme = {
    address_space_vnet        = "10.201.64.0/18"
    address_prefix-subnet-ops = "10.201.64.0/24"

    address_prefix-subnet-web-01          = "10.201.65.0/27"
    address_prefix-subnet-app-01          = "10.201.65.32/27"
    address_prefix-subnet-app-ext-01      = "10.201.67.0/24"
    address_prefix-subnet-app-audit-01    = "10.201.65.128/27"
    address_prefix-subnet-data-01         = "10.201.65.64/27"
    address_prefix-subnet-app-ext-wfly-01 = "10.201.65.192/27"
    address_prefix-subnet-azdata-01       = "10.201.66.0/25"

    address_prefix-subnet-web-02  = "10.201.66.0/27"
    address_prefix-subnet-app-02  = "10.201.66.32/27"
    address_prefix-subnet-data-02 = "10.201.66.64/27"

    address_space_vnet_dmz                = "10.201.192.0/19"
    address_prefix-subnet-waf             = "10.201.192.0/27"
    address_prefix-subnet-dmz-vul-scanner = "10.201.192.32/28"

    address_prefix-subnet-apim-appgw = "10.201.65.128/29"
    address_prefix-subnet-apim-app   = "10.201.65.96/27"
    address_prefix-subnet-rc-elk     = "10.201.127.152/29"
    address_prefix-subnet-elkcache   = "10.201.127.160/29"
    #= address_prefix-subnet-appgw      = "10.201.65.224/27"

    # PAAS subnets
    address_prefix-subnet-rc-common = "10.201.68.224/28"
    address_prefix-subnet-sd-common = "10.201.68.192/28"
    address_prefix-subnet-csfl      = "10.201.68.160/28"
    address_prefix-subnet-blks      = "10.201.68.144/28"
    address_prefix-subnet-laa       = "10.201.68.128/28"
    address_prefix-subnet-scsl      = "10.201.68.112/28"
    address_prefix-subnet-sa-common = "10.201.68.104/29"
    address_prefix-subnet-kv-common = "10.201.68.96/29"
    address_prefix-subnet-blks-1    = "10.201.68.88/29"

    # Funcation Apps
    # az network vnet subnet list --resource-group RG-PRP-INT-01 --vnet-name VN-PRP-INT-01 --query "[?delegations[?serviceName=='Microsoft.Web/serverFarms']].{Name:name, Delegated:delegations[0].serviceName, CIDR:addressPrefix}" -o json | jq -r 'map({("address_prefix-subnet-" + (.Name | sub("sn-prp-"; "") | sub("fa-prp-"; "") | sub("SN-PRP-"; "") | sub("fn-prp-"; ""))): .CIDR}) | add | to_entries | .[] | "\(.key) = \"\(.value)\""'
    address_prefix-subnet-ccp0101-bulkscan-pe1   = "10.201.68.88/29"
    address_prefix-subnet-ccp0101-casefilter     = "10.201.68.160/28"
    address_prefix-subnet-ccp0101-bulkscan       = "10.201.68.144/28"
    address_prefix-subnet-ccp0101-legalaidagency = "10.201.68.128/28"
    address_prefix-subnet-ccp0101-scsl           = "10.201.68.112/28"
    address_prefix-subnet-CCP0102-FA-LAA         = "10.201.68.240/28"
    address_prefix-subnet-ccp0101-notifyatt      = "10.201.68.80/29"
    address_prefix-subnet-ccp0101-courtorders    = "10.201.124.0/28"
    address_prefix-subnet-ccp0101-courtreg       = "10.201.124.16/28"
    address_prefix-subnet-ccp0101-informantreg   = "10.201.124.32/28"
    address_prefix-subnet-ccp0101-legalaid       = "10.201.124.48/28"
    address_prefix-subnet-ccp0101-prisoncourtreg = "10.201.124.80/28"
    address_prefix-subnet-ccp0101-hmpps          = "10.201.124.96/28"
    address_prefix-subnet-ccp0101-nowsce         = "10.201.124.128/27"
    address_prefix-subnet-ccp0101-nowsce-complex = "10.201.124.160/27"

  }
  prp-fn-app-subnets = [
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-bulkscan-pe1,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-casefilter,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-bulkscan,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-legalaidagency,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-scsl,
    local.prp-int-vnet-scheme.address_prefix-subnet-CCP0102-FA-LAA,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-notifyatt,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-courtorders,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-courtreg,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-informantreg,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-legalaid,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-prisoncourtreg,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-hmpps,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-nowsce,
    local.prp-int-vnet-scheme.address_prefix-subnet-ccp0101-nowsce-complex,
  ]
  prx-fn-app-subnets = [
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0201-bulkscan-pe1,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0201-casefilter,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0201-bulkscan,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0201-legalaidagency,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0101-nowsce,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0201-scsl,
    local.prx-int-vnet-scheme.address_prefix-subnet-CCP0202-FA-LAA,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0201-notifyatt,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0101-courtorders,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0101-courtreg,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0101-informantreg,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0101-legalaid,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0101-nowsce,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0101-prisoncourtreg,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0101-hmpps,
    local.prx-int-vnet-scheme.address_prefix-subnet-ccp0101-nowsce-complex,
  ]

  prp-ccm-app-subnets = [
    local.prp-int-vnet-scheme.address_prefix-subnet-app-01,
    local.prp-int-vnet-scheme.address_prefix-subnet-app-ext-01,
    local.prp-int-vnet-scheme.address_prefix-subnet-app-audit-01,
    local.prp-int-vnet-scheme.address_prefix-subnet-app-ext-wfly-01,
    local.prp-int-vnet-scheme.address_prefix-subnet-app-02
  ]

  prx-ccm-app-subnets = [
    local.prx-int-vnet-scheme.address_prefix-subnet-app-01,
    local.prx-int-vnet-scheme.address_prefix-subnet-app-ext-01,
    local.prx-int-vnet-scheme.address_prefix-subnet-app-audit-01
    # local.prx-int-vnet-scheme.address_prefix-subnet-app-ext-wfly-01,
    # local.prx-int-vnet-scheme.address_prefix-subnet-app-02
  ]

  prx-int-vnet-scheme = {
    address_space_vnet                 = "10.203.128.0/18"
    address_prefix-subnet-ops          = "10.203.190.0/24"
    address_prefix-subnet-web-01       = "10.203.128.0/24"
    address_prefix-subnet-app-01       = "10.203.132.0/24"
    address_prefix-subnet-app-audit-01 = "10.203.133.0/27"
    address_prefix-subnet-data-01      = "10.203.134.0/24"
    address_prefix-subnet-app-ext-01   = "10.203.136.0/24"

    address_prefix-subnet-apim-app = "10.203.180.0/27"
    address_prefix-subnet-rc-elk   = "10.203.191.152/29"
    address_prefix-subnet-elkcache = "10.203.191.160/29"

    /* - Commented out for now by Ken

    address_prefix-subnet-web-02  = "10.201.66.0/27"
    address_prefix-subnet-app-02  = "10.201.66.32/27"
    address_prefix-subnet-data-02 = "10.201.66.64/27"

    address_space_vnet_dmz    = "10.201.192.0/19"
    address_prefix-subnet-waf = "10.201.192.0/27"
    address_prefix-subnet-dmz-vul-scanner = "10.201.192.32/28"

    address_prefix-subnet-apim-appgw = "10.201.65.128/29"
    #= address_prefix-subnet-appgw      = "10.201.65.224/27"
*/

    # PAAS subnets
    address_prefix-subnet-rc-common = "10.203.180.224/28"
    address_prefix-subnet-sd-common = "10.203.180.192/28"
    address_prefix-subnet-csfl      = "10.203.180.160/28"
    address_prefix-subnet-blks      = "10.203.180.144/28"
    address_prefix-subnet-laa       = "10.203.180.128/28"
    address_prefix-subnet-scsl      = "10.203.180.112/28"
    address_prefix-subnet-sa-common = "10.203.180.104/29"
    address_prefix-subnet-kv-common = "10.203.180.96/29"
    address_prefix-subnet-blks-1    = "10.203.180.88/29"

    # Funcation Apps
    # az network vnet subnet list --resource-group RG-PRP-INT-01 --vnet-name VN-PRP-INT-01 --query "[?delegations[?serviceName=='Microsoft.Web/serverFarms']].{Name:name, Delegated:delegations[0].serviceName, CIDR:addressPrefix}" -o json | jq -r 'map({("address_prefix-subnet-" + (.Name | sub("sn-prp-"; "") | sub("fa-prp-"; "") | sub("SN-PRP-"; "") | sub("fn-prp-"; ""))): .CIDR}) | add | to_entries | .[] | "\(.key) = \"\(.value)\""'
    address_prefix-subnet-ccp0201-bulkscan-pe1   = "10.203.180.88/29"
    address_prefix-subnet-ccp0201-casefilter     = "10.203.180.160/28"
    address_prefix-subnet-ccp0201-bulkscan       = "10.203.180.144/28"
    address_prefix-subnet-ccp0201-legalaidagency = "10.203.180.128/28"
    address_prefix-subnet-ccp0101-nowsce         = "10.203.183.64/28"
    address_prefix-subnet-ccp0201-scsl           = "10.203.180.112/28"
    address_prefix-subnet-CCP0202-FA-LAA         = "10.203.181.0/27"
    address_prefix-subnet-ccp0201-notifyatt      = "10.203.180.80/29"
    address_prefix-subnet-ccp0101-courtorders    = "10.203.183.0/28"
    address_prefix-subnet-ccp0101-courtreg       = "10.203.183.16/28"
    address_prefix-subnet-ccp0101-informantreg   = "10.203.183.32/28"
    address_prefix-subnet-ccp0101-legalaid       = "10.203.183.48/28"
    address_prefix-subnet-ccp0101-nowsce         = "10.203.183.64/28"
    address_prefix-subnet-ccp0101-prisoncourtreg = "10.203.183.80/28"
    address_prefix-subnet-ccp0101-hmpps          = "10.203.183.96/28"
    address_prefix-subnet-ccp0101-nowsce-complex = "10.203.183.160/27"
  }

  prp-int-bae-vnet-scheme = {
    address_space_vnet        = "10.203.0.0/18"
    address_prefix-subnet-ops = "10.203.62.0/24"

    address_prefix-subnet-web-01  = "10.203.0.0/27"
    address_prefix-subnet-app-01  = "10.203.0.64/26"
    address_prefix-subnet-data-01 = "10.203.0.128/27"

    address_prefix-subnet-apim-app = "10.203.1.0/27"
    address_prefix-subnet-rc-elk   = "10.203.61.0/29"
    # PAAS subnets
    address_prefix-subnet-rc-common = "10.203.4.224/28"
    address_prefix-subnet-sd-common = "10.203.4.192/28"
    address_prefix-subnet-csfl      = "10.203.4.160/28"
    address_prefix-subnet-blks      = "10.203.4.144/28"
    address_prefix-subnet-laa       = "10.203.4.128/28"
    address_prefix-subnet-scsl      = "10.203.4.112/28"
    address_prefix-subnet-sa-common = "10.203.4.104/29"
    address_prefix-subnet-kv-common = "10.203.4.96/29"
    address_prefix-subnet-blks-1    = "10.203.4.88/29"
  }
  prp-atl-vnet-scheme = {
    address_space_vnet            = "172.30.0.0/16"
    address_prefix-subnet-ops     = "172.30.10.0/24"
    address_prefix-subnet-app-01  = "172.30.1.0/24"
    address_prefix-subnet-data-01 = "172.30.2.0/24"
    address_space_dmz_vnet        = "192.168.240.0/24"
    address_prefix-subnet-waf     = "192.168.240.0/28"
  }
  prd-atl-vnet-scheme = {
    address_space_vnet            = "172.31.0.0/16"
    address_prefix-subnet-ops     = "172.31.10.0/24"
    address_prefix-subnet-app-01  = "172.31.1.0/24"
    address_prefix-subnet-data-01 = "172.31.2.0/24"
    address_space_dmz_vnet        = "192.168.241.0/24"
    address_prefix-subnet-waf     = "192.168.241.0/28"
  }
  prd-int-vnet-scheme = {
    address_space_vnet        = "10.202.64.0/18"
    address_prefix-subnet-ops = "10.202.64.0/24"

    address_prefix-subnet-web-01          = "10.202.65.0/27"
    address_prefix-subnet-app-01          = "10.202.65.32/27"
    address_prefix-subnet-app-ext-01      = "10.202.67.0/24"
    address_prefix-subnet-app-audit-01    = "10.202.65.128/27"
    address_prefix-subnet-data-01         = "10.202.65.64/27"
    address_prefix-subnet-app-ext-wfly-01 = "10.202.65.192/27"
    address_prefix-subnet-azdata-01       = "10.202.66.0/25"

    address_prefix-subnet-web-02  = "10.202.66.0/27"
    address_prefix-subnet-app-02  = "10.202.66.32/27"
    address_prefix-subnet-data-02 = "10.202.66.64/27"

    address_space_vnet_dmz                = "10.202.192.0/19"
    address_prefix-subnet-waf             = "10.202.192.0/27"
    address_prefix-subnet-dmz-vul-scanner = "10.202.192.32/28"

    #= address_prefix-subnet-apim-appgw = "10.202.65.128/29"
    address_prefix-subnet-apim-app = "10.202.65.96/27"
    address_prefix-subnet-rc-elk   = "10.202.127.152/29"
    address_prefix-subnet-elkcache = "10.202.127.160/29"
    # PAAS subnets
    address_prefix-subnet-rc-common = "10.202.68.224/28"
    address_prefix-subnet-sd-common = "10.202.68.192/28"
    address_prefix-subnet-csfl      = "10.202.68.160/28"
    address_prefix-subnet-blks      = "10.202.68.144/28"
    address_prefix-subnet-laa       = "10.202.68.128/28"
    address_prefix-subnet-scsl      = "10.202.68.112/28"
    address_prefix-subnet-sa-common = "10.202.68.104/29"
    address_prefix-subnet-kv-common = "10.202.68.96/29"
    address_prefix-subnet-blks-1    = "10.202.68.88/29"


    # Funcation Apps
    # az network vnet subnet list --resource-group RG-PRD-INT-01 --vnet-name VN-PRD-INT-01 --query "[?delegations[?serviceName=='Microsoft.Web/serverFarms']].{Name:name, Delegated:delegations[0].serviceName, CIDR:addressPrefix}" -o json | jq -r 'map({("address_prefix-subnet-" + (.Name | sub("sn-prd-"; "") | sub("fa-prd-"; "") | sub("SN-PRD-"; "") | sub("fn-prd-"; ""))): .CIDR}) | add | to_entries | .[] | "\(.key) = \"\(.value)\""'
    address_prefix-subnet-ccp0101-bulkscan-pe1      = "10.202.68.88/29"
    address_prefix-subnet-ccp0101-casefilter        = "10.202.68.160/28"
    address_prefix-subnet-ccp0101-bulkscan          = "10.202.68.144/28"
    address_prefix-subnet-ccp0101-legalaidagency    = "10.202.68.128/28"
    address_prefix-subnet-ccp0101-scsl              = "10.202.68.112/28"
    address_prefix-subnet-CCP0102-FA-LAA            = "10.202.68.240/28"
    address_prefix-subnet-ccp0101-notifyatt         = "10.202.68.80/29"
    address_prefix-subnet-ccp0101-courtorders       = "10.202.124.0/28"
    address_prefix-subnet-ccp0101-courtreg          = "10.202.124.16/28"
    address_prefix-subnet-ccp0101-informantreg      = "10.202.124.32/28"
    address_prefix-subnet-ccp0101-legalaid          = "10.202.124.48/28"
    address_prefix-subnet-ccp0101-nowsce            = "10.202.124.64/28"
    address_prefix-subnet-ccp0101-prisoncourtreg    = "10.202.124.80/28"
    address_prefix-subnet-ccp0101-hmpps             = "10.202.124.96/28"
    address_prefix-subnet-ccp0101-legalaid-02       = "10.202.124.128/27"
    address_prefix-subnet-ccp0101-nowsce-02         = "10.202.124.160/27"
    address_prefix-subnet-ccp0101-prisoncourtreg-02 = "10.202.124.192/27"
    address_prefix-subnet-ccp0101-nowsce-complex    = "10.202.124.224/27"
    address_prefix-subnet-ccp0101-nowsce2           = "10.202.125.64/26"
    address_prefix-subnet-ccp0101-nowsce-complex2   = "10.202.125.0/26"
  }
  prd-fn-app-subnets = [
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-bulkscan-pe1,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-casefilter,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-bulkscan,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-legalaidagency,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-scsl,
    local.prd-int-vnet-scheme.address_prefix-subnet-CCP0102-FA-LAA,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-notifyatt,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-courtorders,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-courtreg,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-informantreg,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-legalaid,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-nowsce,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-prisoncourtreg,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-hmpps,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-legalaid-02,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-nowsce-02,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-prisoncourtreg-02,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-nowsce-complex,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-nowsce2,
    local.prd-int-vnet-scheme.address_prefix-subnet-ccp0101-nowsce-complex2,
  ]
  prd-ccm-app-subnets = [
    local.prd-int-vnet-scheme.address_prefix-subnet-app-01,
    local.prd-int-vnet-scheme.address_prefix-subnet-app-ext-01,
    local.prd-int-vnet-scheme.address_prefix-subnet-app-audit-01,
    local.prd-int-vnet-scheme.address_prefix-subnet-app-ext-wfly-01,
    local.prd-int-vnet-scheme.address_prefix-subnet-app-02
  ]
  prx-app-conf-subnets = [
    local.lve-app-conf-vnet-scheme.address_prefix-subnet-CCP0101-Feature-Toggle,
  ]
  prp-app-conf-subnets = [
    local.lve-app-conf-vnet-scheme.address_prefix-subnet-CCP0101-Feature-Toggle,
  ]
  prd-app-conf-subnets = [
    local.lve-app-conf-vnet-scheme.address_prefix-subnet-CCP0101-Feature-Toggle,
  ]
  prp-rota-vnet-scheme = {
    address_space_vnet        = "10.201.70.0/18"
    address_prefix-subnet-ops = "10.201.70.0/24"

    address_prefix-subnet-web-01  = "10.201.70.0/27"
    address_prefix-subnet-app-01  = "10.201.70.64/26"
    address_prefix-subnet-data-01 = "10.201.70.128/27"

    address_space_vnet_dmz    = "10.201.192.0/19"
    address_prefix-subnet-waf = "10.201.192.0/27"
  }
  prd-rota-vnet-scheme = {
    address_space_vnet        = "10.202.70.0/18"
    address_prefix-subnet-ops = "10.202.70.0/24"

    address_prefix-subnet-web-01  = "10.202.70.0/27"
    address_prefix-subnet-app-01  = "10.202.70.64/26"
    address_prefix-subnet-data-01 = "10.202.70.128/27"

    address_space_vnet_dmz    = "10.202.192.0/19"
    address_prefix-subnet-waf = "10.202.192.0/27"
  }
  nle-atl-vnet-scheme = {
    address_space_vnet        = "10.254.0.0/20"
    address_prefix-subnet-ops = "10.254.10.0/24"

    address_prefix-subnet-app-01  = "10.254.2.0/24"
    address_prefix-subnet-data-01 = "10.254.3.0/24"

    address_space_dmz_vnet = "10.254.20.0/24"

    address_space_subnet_dmz  = "10.254.1.0/24"
    address_prefix-subnet-waf = "10.254.20.0/29"
  }
  idam-dev-vnet-scheme = {
    address_space_vnet                = "10.10.0.0/16"
    address_prefix_subnet_dmz         = "10.89.192.0/27"
    address_prefix_subnet_web_idm1_01 = "10.10.2.0/24"
    address_prefix_subnet_web_idm1_02 = "10.10.3.0/24"
    address_prefix_subnet_web_idm1_03 = "10.10.255.0/24"
    address_prefix_subnet_app_idm1_01 = "10.10.4.0/24"
    address_prefix_subnet_app_idm1_02 = "10.10.5.0/24"
    address_prefix_subnet_dat_idm1_01 = "10.10.6.0/24"
    address_prefix_subnet_dat_idm1_02 = "10.10.7.0/24"
    address_prefix_subnet_ops_01      = "10.10.1.0/24"
    address_prefix_subnet_ops_02      = "10.10.0.0/29"
    cpstub_proxy_static_ip            = "10.10.255.5"
    rotastub_proxy_static_ip          = "10.10.255.8"
  }
  idam-sit-vnet-scheme = {
    address_space_vnet                = "10.15.0.0/16"
    address_prefix_subnet_dmz         = "10.90.192.0/19"
    address_prefix_subnet_web_idm1_01 = "10.15.2.0/24"
    address_prefix_subnet_web_idm1_02 = "10.15.3.0/24"
    address_prefix_subnet_web_idm1_03 = "10.15.255.0/24"
    address_prefix_subnet_app_idm1_01 = "10.15.4.0/24"
    address_prefix_subnet_app_idm1_02 = "10.15.5.0/24"
    address_prefix_subnet_dat_idm1_01 = "10.15.6.0/24"
    address_prefix_subnet_dat_idm1_02 = "10.15.7.0/24"
    address_prefix_subnet_ops_01      = "10.15.1.0/24"
    address_prefix_subnet_ops_02      = "10.15.0.0/29"
    cpstub_proxy_static_ip            = "10.15.255.5"
    rotastub_proxy_static_ip          = "10.15.255.8"
  }
  idam-nft-vnet-scheme = {
    address_space_vnet                = "10.20.0.0/16"
    address_prefix_subnet_dmz         = "10.91.192.0/27"
    address_prefix_subnet_web_idm1_01 = "10.20.2.0/24"
    address_prefix_subnet_web_idm1_02 = "10.20.3.0/24"
    address_prefix_subnet_web_idm1_03 = "10.20.255.0/24"
    address_prefix_subnet_app_idm1_01 = "10.20.4.0/24"
    address_prefix_subnet_app_idm1_02 = "10.20.5.0/24"
    address_prefix_subnet_dat_idm1_01 = "10.20.6.0/24"
    address_prefix_subnet_dat_idm1_02 = "10.20.7.0/24"
    address_prefix_subnet_ops_01      = "10.20.1.0/24"
    address_prefix_subnet_ops_02      = "10.20.0.0/29"
    cpstub_proxy_static_ip            = "10.20.255.5"
    rotastub_proxy_static_ip          = "10.20.255.8"
  }
  idam-prp-vnet-scheme = {
    address_space_vnet                = "10.220.0.0/16"
    address_prefix_subnet_dmz         = "10.91.192.0/19"
    address_prefix_subnet_web_idm1_01 = "10.220.2.0/24"
    address_prefix_subnet_web_idm1_02 = "10.220.3.0/24"
    address_prefix_subnet_app_idm1_01 = "10.220.4.0/24"
    address_prefix_subnet_app_idm1_02 = "10.220.5.0/24"
    address_prefix_subnet_dat_idm1_01 = "10.220.6.0/24"
    address_prefix_subnet_dat_idm1_02 = "10.220.7.0/24"
    address_prefix_subnet_ops_01      = "10.220.1.0/24"
  }

  idam-prd-vnet-scheme = {
    address_space_vnet                = "10.225.0.0/16"
    address_prefix_subnet_dmz         = "10.91.192.0/19"
    address_prefix_subnet_web_idm1_01 = "10.225.2.0/24"
    address_prefix_subnet_web_idm1_02 = "10.225.3.0/24"
    address_prefix_subnet_app_idm1_01 = "10.225.4.0/24"
    address_prefix_subnet_app_idm1_02 = "10.225.5.0/24"
    address_prefix_subnet_dat_idm1_01 = "10.225.6.0/24"
    address_prefix_subnet_dat_idm1_02 = "10.225.7.0/24"
    address_prefix_subnet_ops_01      = "10.225.1.0/24"
  }

  ste-api-app-subnets = [
    "10.87.30.32/27",
  ]

  dev-api-app-subnets = [
    "10.89.127.248/29",
  ]

  sit-api-app-subnets = [
    "10.90.127.240/29",
  ]

  nft-api-app-subnets = [
    "10.91.127.0/29",
  ]

  prp-api-app-subnets = [
    "10.201.65.96/27",
  ]

  prd-api-app-subnets = [
    "10.202.65.96/27",
  ]

  prx-api-app-subnets = [
    "10.203.180.0/27",
  ]
}
