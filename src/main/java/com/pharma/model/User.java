package com.pharma.model;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class User {
    private Integer userId;
    private String username;
    private String password;
    private String email;
    private LocalDateTime createdAt;
} 