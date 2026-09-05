package io.multicloudx.order;
import java.time.Instant;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.*;
@RestController @RequestMapping("/api/orders")
class OrderController {
  private final KafkaTemplate<String, Object> kafka;
  OrderController(KafkaTemplate<String, Object> kafka) { this.kafka = kafka; }
  @PostMapping ResponseEntity<Map<String, Object>> create(@RequestBody CreateOrder request) {
    var event = Map.<String, Object>of("orderId", request.orderId(), "customerId", request.customerId(), "createdAt", Instant.now().toString());
    kafka.send("orders.created", request.orderId(), event);
    return ResponseEntity.accepted().body(event);
  }
  record CreateOrder(String orderId, String customerId) {}
}
