# =========================================================
# SOC-IAC PLATFORM
# TERRAFORM OUTPUTS
# =========================================================

# =========================================================
# ELASTICSEARCH
# =========================================================

output "elasticsearch_url" {

  description = "Elasticsearch service URL"

  value = "http://localhost:${var.elasticsearch_port}"

}

# =========================================================
# KIBANA
# =========================================================

output "kibana_url" {

  description = "Kibana dashboard URL"

  value = "http://localhost:${var.kibana_port}"

}

# =========================================================
# LOGSTASH
# =========================================================

output "logstash_port" {

  description = "Logstash exposed port"

  value = var.logstash_port

}

# =========================================================
# THEHIVE
# =========================================================

output "thehive_url" {

  description = "TheHive incident response platform URL"

  value = "http://localhost:${var.thehive_port}"

}

# =========================================================
# CORTEX
# =========================================================

output "cortex_url" {

  description = "Cortex analyzer platform URL"

  value = "http://localhost:${var.cortex_port}"

}

# =========================================================
# NETWORK
# =========================================================

output "network_name" {

  description = "SOC Docker network"

  value = var.network_name

}

# =========================================================
# ENVIRONMENT
# =========================================================

output "environment" {

  description = "Deployment environment"

  value = var.environment

}

# =========================================================
# PROJECT NAME
# =========================================================

output "project_name" {

  description = "SOC project name"

  value = var.project_name

}

# =========================================================
# SUMMARY
# =========================================================

output "soc_summary" {

  description = "SOC deployment summary"

  value = <<EOT

=================================================
 SOC-IAC PLATFORM DEPLOYED
=================================================

Kibana:
http://localhost:${var.kibana_port}

Elasticsearch:
http://localhost:${var.elasticsearch_port}

TheHive:
http://localhost:${var.thehive_port}

Cortex:
http://localhost:${var.cortex_port}

Environment:
${var.environment}

Project:
${var.project_name}

=================================================

EOT

}