package io.multicloudx.customer;

import jakarta.persistence.*;

@Entity
@Table(name = "customers")
class Customer {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY) Long id;
  @Column(nullable = false) String name;
  @Column(nullable = false, unique = true) String email;
  Customer() {}
  Customer(String name, String email) { this.name = name; this.email = email; }
}
