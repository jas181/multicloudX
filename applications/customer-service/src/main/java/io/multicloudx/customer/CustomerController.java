package io.multicloudx.customer;
import java.net.URI;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
@RestController @RequestMapping("/api/customers")
class CustomerController {
  private final CustomerRepository repository;
  CustomerController(CustomerRepository repository) { this.repository = repository; }
  @GetMapping List<Customer> list() { return repository.findAll(); }
  @PostMapping ResponseEntity<Customer> create(@RequestBody CreateCustomer request) {
    Customer customer = repository.save(new Customer(request.name(), request.email()));
    return ResponseEntity.created(URI.create("/api/customers/" + customer.id)).body(customer);
  }
  record CreateCustomer(String name, String email) {}
}
