# =========================================================
# SOC-IAC PLATFORM
# TERRAFORM CONFIGURATION
# =========================================================

terraform {

  required_version = ">= 1.5.0"

  required_providers {

    docker = {

      source  = "kreuzwerker/docker"

      version = "~> 3.0"

    }

  }

}

# =========================================================
# DOCKER PROVIDER
# =========================================================

provider "docker" {}

# =========================================================
# NETWORK
# =========================================================

resource "docker_network" "soc_network" {

  name = "soc_iac_network"

}

# =========================================================
# ELASTICSEARCH
# =========================================================

resource "docker_image" "elasticsearch" {

  name = "docker.elastic.co/elasticsearch/elasticsearch:8.12.2"

}

resource "docker_container" "elasticsearch" {

  name  = "soc-elasticsearch"

  image = docker_image.elasticsearch.image_id

  hostname = "elasticsearch"

  env = [

    "discovery.type=single-node",
    "xpack.security.enabled=false",
    "ES_JAVA_OPTS=-Xms1g -Xmx1g"

  ]

  ports {

    internal = 9200
    external = 9200

  }

  ports {

    internal = 9300
    external = 9300

  }

  networks_advanced {

    name = docker_network.soc_network.name

  }

}

# =========================================================
# KIBANA
# =========================================================

resource "docker_image" "kibana" {

  name = "docker.elastic.co/kibana/kibana:8.12.2"

}

resource "docker_container" "kibana" {

  name  = "soc-kibana"

  image = docker_image.kibana.image_id

  hostname = "kibana"

  env = [

    "ELASTICSEARCH_HOSTS=http://elasticsearch:9200"

  ]

  ports {

    internal = 5601
    external = 5601

  }

  networks_advanced {

    name = docker_network.soc_network.name

  }

  depends_on = [

    docker_container.elasticsearch

  ]

}

# =========================================================
# LOGSTASH
# =========================================================

resource "docker_image" "logstash" {

  name = "docker.elastic.co/logstash/logstash:8.12.2"

}

resource "docker_container" "logstash" {

  name  = "soc-logstash"

  image = docker_image.logstash.image_id

  hostname = "logstash"

  ports {

    internal = 5044
    external = 5044

  }

  networks_advanced {

    name = docker_network.soc_network.name

  }

  depends_on = [

    docker_container.elasticsearch

  ]

}

# =========================================================
# THEHIVE
# =========================================================

resource "docker_image" "thehive" {

  name = "strangebee/thehive:5"

}

resource "docker_container" "thehive" {

  name  = "soc-thehive"

  image = docker_image.thehive.image_id

  hostname = "thehive"

  ports {

    internal = 9000
    external = 9000

  }

  networks_advanced {

    name = docker_network.soc_network.name

  }

}

# =========================================================
# CORTEX
# =========================================================

resource "docker_image" "cortex" {

  name = "thehiveproject/cortex:3.1.7"

}

resource "docker_container" "cortex" {

  name  = "soc-cortex"

  image = docker_image.cortex.image_id

  hostname = "cortex"

  ports {

    internal = 9001
    external = 9001

  }

  networks_advanced {

    name = docker_network.soc_network.name

  }

}

# =========================================================
# OUTPUTS
# =========================================================

output "kibana_url" {

  value = "http://localhost:5601"

}

output "elasticsearch_url" {

  value = "http://localhost:9200"

}

output "thehive_url" {

  value = "http://localhost:9000"

}

output "cortex_url" {

  value = "http://localhost:9001"

}