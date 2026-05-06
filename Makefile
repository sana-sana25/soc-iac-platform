# =========================================================
# SOC-IAC PLATFORM MAKEFILE
# =========================================================

PROJECT_NAME=soc-iac-platform

# =========================================================
# DEFAULT TARGET
# =========================================================

.DEFAULT_GOAL := help

# =========================================================
# HELP
# =========================================================

help:
	@echo ""
	@echo "================================================="
	@echo "             SOC-IAC PLATFORM"
	@echo "================================================="
	@echo ""
	@echo "Available commands:"
	@echo ""
	@echo " make bootstrap        -> Initial deployment"
	@echo " make up               -> Start SOC stack"
	@echo " make down             -> Stop SOC stack"
	@echo " make restart          -> Restart all containers"
	@echo " make rebuild          -> Rebuild containers"
	@echo " make logs             -> Show container logs"
	@echo " make status           -> Show running containers"
	@echo " make clean            -> Remove containers"
	@echo " make reset            -> Full reset"
	@echo " make generator        -> Run attack generator"
	@echo " make health           -> Check services"
	@echo " make urls             -> Show SOC URLs"
	@echo ""

# =========================================================
# BOOTSTRAP
# =========================================================

bootstrap:
	chmod +x bootstrap.sh
	sudo ./bootstrap.sh

# =========================================================
# START SERVICES
# =========================================================

up:
	docker compose up -d

# =========================================================
# STOP SERVICES
# =========================================================

down:
	docker compose down

# =========================================================
# RESTART
# =========================================================

restart:
	docker compose restart

# =========================================================
# REBUILD
# =========================================================

rebuild:
	docker compose down
	docker compose build --no-cache
	docker compose up -d

# =========================================================
# LOGS
# =========================================================

logs:
	docker compose logs -f

# =========================================================
# STATUS
# =========================================================

status:
	docker ps

# =========================================================
# CLEAN
# =========================================================

clean:
	docker compose down -v
	docker system prune -f

# =========================================================
# FULL RESET
# =========================================================

reset:
	docker compose down -v
	docker rm -f $$(docker ps -aq) || true
	docker volume prune -f
	docker network prune -f

# =========================================================
# HEALTH CHECKS
# =========================================================

health:
	@echo ""
	@echo "================================================="
	@echo "              HEALTH CHECKS"
	@echo "================================================="
	@echo ""

	@curl -s http://localhost:9200 > /dev/null \
		&& echo "[OK] Elasticsearch reachable" \
		|| echo "[ERROR] Elasticsearch unreachable"

	@curl -s http://localhost:5601 > /dev/null \
		&& echo "[OK] Kibana reachable" \
		|| echo "[ERROR] Kibana unreachable"

	@curl -s http://localhost:9000 > /dev/null \
		&& echo "[OK] TheHive reachable" \
		|| echo "[ERROR] TheHive unreachable"

	@curl -s http://localhost:9001 > /dev/null \
		&& echo "[OK] Cortex reachable" \
		|| echo "[ERROR] Cortex unreachable"

# =========================================================
# URLS
# =========================================================

urls:
	@IP=$$(hostname -I | awk '{print $$1}') ; \
	echo "" ; \
	echo "=================================================" ; \
	echo "                SOC URLS" ; \
	echo "=================================================" ; \
	echo "" ; \
	echo "Kibana        : http://$$IP:5601" ; \
	echo "Elasticsearch : http://$$IP:9200" ; \
	echo "TheHive       : http://$$IP:9000" ; \
	echo "Cortex        : http://$$IP:9001" ; \
	echo ""

# =========================================================
# ATTACK GENERATOR
# =========================================================

generator:
	python3 attack_generator/generator.py

# =========================================================
# IMPORT DASHBOARDS
# =========================================================

import-dashboards:
	bash scripts/import-dashboards.sh

# =========================================================
# IMPORT RULES
# =========================================================

import-rules:
	bash scripts/import-rules.sh

# =========================================================
# CREATE INDEXES
# =========================================================

create-indexes:
	bash scripts/create-indexes.sh

# =========================================================
# CLEAN LOG FILES
# =========================================================

clean-logs:
	rm -f simulated_logs/*.json

# =========================================================
# SHOW NETWORKS
# =========================================================

networks:
	docker network ls

# =========================================================
# SHOW VOLUMES
# =========================================================

volumes:
	docker volume ls