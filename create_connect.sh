#!/bin/bash

# Ver: Apache Nif
curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
  "name": "keycloak_connector",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "connection.url": "http://elasticsearch:9200",
    "tasks.max": "1",
    "topics": "KEYCLOAK_EVENTS",
    "type.name": "_doc",
    "key.ignore": "true",
    "schema.ignore": "true"
  }
}'


curl -X PUT http://localhost:9200/keycloak_events -H "Content-Type: application/json" -d '
{
  "properties": {
    "time": {
      "type": "date",
      "format": "epoch_millis"
    }
  }
}'