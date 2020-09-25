package com.github.fj.keycloak.event;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.jboss.logging.Logger;
import org.keycloak.events.Event;
import org.keycloak.events.EventListenerProvider;
import org.keycloak.events.EventType;
import org.keycloak.events.admin.AdminEvent;

import java.util.ArrayList;
import java.util.List;

public class KafkaEventListenerProvider implements EventListenerProvider {

    private static final Logger LOG = Logger.getLogger(KafkaEventListenerProvider.class);

    private final String topicEvents;

    private final List<EventType> events;

    private final String topicAdminEvents;

    private final Producer<String, String> producer;

    private final ObjectMapper mapper;

    public KafkaEventListenerProvider(String bootstrapServers,
                                      String clientId,
                                      String topicEvents,
                                      String[] events,
                                      String topicAdminEvents) {
        this.topicEvents = topicEvents;
        this.events = new ArrayList<>();
        this.topicAdminEvents = topicAdminEvents;

        for (int i = 0; i < events.length; i++) {
            try {
                EventType eventType = EventType.valueOf(events[i].toUpperCase());
                this.events.add(eventType);
            } catch (IllegalArgumentException e) {
                LOG.debug("Ignoring event >" + events[i] + "<. Event does not exist.");
            }
        }

        producer = KafkaProducerFactory.createProducer(clientId, bootstrapServers);
        mapper = new ObjectMapper();
    }

    private void produceEvent(String eventAsString, String topic) {
        try {
            LOG.info("[KAFKA][PRODUCING] topic=" + topicEvents);
            ProducerRecord<String, String> record = new ProducerRecord<>(topic, eventAsString);
            producer.send(record, (recordMetadata, e) -> {
                if (e != null) {
                    LOG.error(e);
                    return;
                }
                LOG.info(String.format("[KAFKA][PRODUCED] timestamp=%s ::: topic=%s ::: key=%s ::: partition=%d ::: offset=%d", recordMetadata.timestamp(), recordMetadata.topic(), record.key(), recordMetadata.partition(), recordMetadata.offset()));
            }).get();
        } catch (Exception e) {
            LOG.error(e);
        }
    }

    @Override
    public void onEvent(Event event) {
        if (events.contains(event.getType())) {
            try {
                String message = mapper.writeValueAsString(event);
                produceEvent(message, topicEvents);
            } catch (JsonProcessingException e) {
                LOG.error(e.getMessage(), e);
                Thread.currentThread().interrupt();
            }
        }
    }

    @Override
    public void onEvent(AdminEvent event, boolean includeRepresentation) {
        if (topicAdminEvents != null) {
            try {
                produceEvent(mapper.writeValueAsString(event), topicAdminEvents);
            } catch (JsonProcessingException e) {
                LOG.error(e.getMessage(), e);
                Thread.currentThread().interrupt();
            }
        }
    }

    @Override
    public void close() {
        // ignore
    }
}