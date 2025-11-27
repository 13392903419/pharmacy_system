package com.pharma.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Supplier {
    private Integer supplierId;
    private String supplierCode;
    private String name;
    private String contactPerson;
    private String phone;
    private String email;
    private String address;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
} 