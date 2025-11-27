package com.pharma.model;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class SalesOrder {
    private Integer salesId;
    private String salesCode;
    private Integer customerId;
    private Integer employeeId;
    private BigDecimal totalAmount;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<SalesOrderDetail> details;
}