package com.pharma.service;

import com.pharma.model.Medicine;
import java.util.List;

public interface MedicineService {
    List<Medicine> getAllMedicines();
    Medicine getMedicineById(Integer id);
    void saveMedicine(Medicine medicine);
    void deleteMedicine(Integer id);
    List<Medicine> searchMedicines(String keyword);
} 