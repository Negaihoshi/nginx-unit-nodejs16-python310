name := unit
vol_name := ${name}_node_modules
vol := $(shell docker volume ls -qf name=${vol_name})

.DEFAULT_GOAL := all

.PHONY: all
all: build push up config

.PHONY: build
build:
	docker-compose build

.PHONY: down
down:
	docker-compose -p ${name} down -v

.PHONY: up
up:
	docker network inspect local >/dev/null 2>&1 && true || docker network create --subnet=172.16.16.0/24 local
	@if [ -z "${vol}" ]; then echo -n "creating ${vol_name} volume: "; docker volume create ${vol_name}; fi
	COMPOSE_HTTP_TIMEOUT=300 docker-compose -p ${name} up -d --force-recreate ${name}
	docker exec -ti -u unit -w /www/fapi_app ${name} /bin/bash -c "/usr/local/bin/python3 -m venv venv && source venv/bin/activate; pip3 install -r requirements.txt"
	docker exec -ti -w /www/node_app ${name} /bin/bash -c "npm install -g npm@latest"
	docker exec -ti -w /www/node_app ${name} /bin/bash -c "npm link unit-http"

.PHONY: config
config:
	cp config.json /opt/www/config.json
	docker exec -ti ${name} bash -c "curl -X PUT --data-binary @/www/config.json  \
    --unix-socket /var/run/control.unit.sock  \
    http://localhost/config; rm /www/config.json"

.PHONY: app_build
app_build:
	docker exec -ti -u unit -w /www/node_app ${name} bash -c "npm run build"

.PHONY: app_restart_node
app_restart_node:
	docker exec -ti ${name} curl -X GET \
		--unix-socket /var/run/control.unit.sock  \
		http://localhost/control/applications/node/restart

.PHONY: app_restart_fapi
app_restart_fapi:
	docker exec -ti ${name} curl -X GET \
		--unix-socket /var/run/control.unit.sock  \
		http://localhost/control/applications/fapi/restart

.PHONY: app_restart
app_restart: app_restart_fapi app_restart_node
