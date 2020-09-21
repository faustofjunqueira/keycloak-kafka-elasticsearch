FROM jboss/keycloak

COPY ./keycloak-kafka-1.0.0-jar-with-dependencies.jar /opt/jboss/keycloak/standalone/deployments/
COPY ./kafka-module.cli /opt/jboss/startup-scripts/

RUN rm -rf /opt/jboss/keycloak/standalone/configuration/standalone_xml_history