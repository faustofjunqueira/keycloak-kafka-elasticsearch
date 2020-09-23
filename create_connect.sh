#!/bin/bash

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