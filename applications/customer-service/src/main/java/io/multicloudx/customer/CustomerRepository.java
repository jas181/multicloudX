package io.multicloudx.customer;
import org.springframework.data.jpa.repository.JpaRepository;
interface CustomerRepository extends JpaRepository<Customer, Long> {}
