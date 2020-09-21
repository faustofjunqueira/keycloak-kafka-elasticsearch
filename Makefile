
up:
	sudo docker-compose up -d

up-build:
	sudo docker-compose up -d --build

down:
	docker-compose down

compile:
	mvn -f ./kafka/pom.