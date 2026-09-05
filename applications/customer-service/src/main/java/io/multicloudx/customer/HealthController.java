package io.multicloudx.customer;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
@RestController class HealthController { @GetMapping("/health") Map<String, String> health() { return Map.of("service", "customer-service", "status", "UP"); } }
