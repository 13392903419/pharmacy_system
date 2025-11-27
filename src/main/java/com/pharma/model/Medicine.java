package com.pharma.model;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalDate;

@Data
public class Medicine {
    private Integer medicineId;
    private String medicineCode;
    private String medicineName;
    private String specification;
    private String manufacturer;
    private String unit;
    private BigDecimal price;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public String getName() {
        return medicineName;
    }

    public LocalDate getExpiryDate() {
        // This method is not provided in the original file or the new code block
        // It's assumed to exist as it's called in the new code block
        return null; // Placeholder return, actual implementation needed
    }
} 