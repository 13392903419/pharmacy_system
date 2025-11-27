package com.pharma.model;

import lombok.Data;

@Data
public class Customer {
    private Integer customerId;
    private String customerCode;
    private String name;
    private String contactPerson;
    private String phone;
    private String email;
    private String address;
    private String type;
} 