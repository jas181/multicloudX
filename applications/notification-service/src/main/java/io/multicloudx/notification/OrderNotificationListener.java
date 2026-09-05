package io.multicloudx.notification;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
@Component
class OrderNotificationListener {
  private static final Logger log = LoggerFactory.getLogger(OrderNotificationListener.class);
  @KafkaListener(topics = "orders.created", groupId = "notification-service")
  void onOrderCreated(String event) { log.info("notification_event_received event={}", event); }
}
