# =========================================================
# SOC-IAC PLATFORM
# TERRAFORM VARIABLES
# =========================================================

# =========================================================
# ELASTICSEARCH
# =========================================================

variable "elasticsearch_image" {

  description = "Elasticsearch Docker image"

  type = string

  default = "docker.elastic.co/elasticsearch/elasticsearch:8.12.2"

}

variable "elasticsearch_port" {

  description = "Elasticsearch exposed port"

  type = number

  default = 9200

}

# =========================================================
# KIBANA
# =========================================================

variable "kibana_image" {

  description = "Kibana Docker image"

  type = string

  default = "docker.elastic.co/kibana/kibana:8.12.2"

}

variable "kibana_port" {

  description = "Kibana exposed port"

  type = number

  default = 5601

}

# =========================================================
# LOGSTASH
# =========================================================

variable "logstash_image" {

  description = "Logstash Docker image"

  type = string

  default = "docker.elastic.co/logstash/logstash:8.12.2"

}

variable "logstash_port" {

  description = "Logstash exposed port"

  type = number

  default = 5044

}

# =========================================================
# THEHIVE
# =========================================================

variable "thehive_image" {

  description = "TheHive Docker image"

  type = string

  default = "strangebee/thehive:5"

}

variable "thehive_port" {

  description = "TheHive exposed port"

  type = number

  default = 9000

}

# =========================================================
# CORTEX
# =========================================================

variable "cortex_image" {

  description = "Cortex Docker image"

  type = string

  default = "thehiveproject/cortex:3.1.7"

}

variable "cortex_port" {

  description = "Cortex exposed port"

  type = number

  default = 9001

}

# =========================================================
# NETWORK
# =========================================================

variable "network_name" {

  description = "SOC Docker network name"

  type = string

  default = "soc_iac_network"

}

# =========================================================
# ELASTICSEARCH MEMORY
# =========================================================

variable "elasticsearch_heap_size" {

  description = "Elasticsearch Java heap size"

  type = string

  default = "1g"

}

# =========================================================
# ENVIRONMENT
# =========================================================

variable "environment" {

  description = "Deployment environment"

  type = string

  default = "local"

}

# =========================================================
# PROJECT NAME
# =========================================================

variable "project_name" {

  description = "SOC project name"

  type = string

  default = "soc-iac-platform"

}