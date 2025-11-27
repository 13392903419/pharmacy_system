package com.pharma.model;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

@Data
public class SalesOrder {
    private Integer salesId;
    private String salesCode;
    private Integer customerId;
    private Integer employeeId;
    private BigDecimal totalAmount;
    private String status;
    private String createdAt;
    private String updatedAt;
    private List<SalesOrderDetail> details;
}