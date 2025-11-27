package com.pharma.model;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class SalesOrderDetail {
    private Integer detailId;
    private Integer salesId;
    private Integer medicineId;
    private String medicineName;    // 药品名称，用于显示
    private String medicineCode;    // 药品编码，用于显示
    private Integer quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;
}