
up:
	docker-compose up -d

up-build: volumes compile
	docker-compose up -d --build

status:
	watch -n2 "docker-compose ps"

down:
	docker-compose down

logs:
	docker-compose logs -f

compile:
	mvn -f ./kafka/pom.xml clean package