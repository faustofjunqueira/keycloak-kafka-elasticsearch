KAFKA_CONTAINER_CMD=docker-compose exec kafka
KAFKA_SERVER="localhost:29092"
ZOOKEEPER_SERVER="zookeeper:2181"
KEYCLOAK_EVENTS="KEYCLOAK_EVENTS"

up:
	docker-compose up -d

up-build:  compile
	docker-compose up -d --build

status:
	watch -n2 "docker-compose ps"

down:
	docker-compose down

logs:
	docker-compose logs -f

compile:
	mvn -f ./keycloak-kafka/pom.xml clean package

kafka-describe:
	$(KAFKA_CONTAINER_CMD) kafka-topics --bootstrap-server $(KAFKA_SERVER) --describe

kafka-consumer:
	$(KAFKA_CONTAINER_CMD) kafka-console-consumer --bootstrap-server $(KAFKA_SERVER) --topic $(KEYCLOAK_EVENTS) --from-beginning

kafka-consumer-groups:
	$(KAFKA_CONTAINER_CMD) kafka-consumer-groups --all-groups --bootstrap-server $(KAFKA_SERVER) --describe
