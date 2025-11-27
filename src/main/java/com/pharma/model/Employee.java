package com.pharma.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Employee {
    private Integer employeeId;
    private String employeeCode;
    private String name;
    private String gender;
    private String phone;
    private String email;
    private String position;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
} 