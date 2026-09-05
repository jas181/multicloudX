package io.multicloudx.payment;
import java.util.Map;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.*;
@RestController @RequestMapping("/api/payments")
class PaymentController {
  private final StringRedisTemplate redis;
  PaymentController(StringRedisTemplate redis) { this.redis = redis; }
  @PostMapping("/{id}/authorize") Map<String, String> authorize(@PathVariable String id, @RequestBody Authorization request) {
    redis.opsForValue().set("payment:" + id, "AUTHORIZED");
    return Map.of("paymentId", id, "status", "AUTHORIZED");
  }
  record Authorization(String tokenReference) {}
}
