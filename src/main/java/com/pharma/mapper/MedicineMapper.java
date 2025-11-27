package com.pharma.mapper;

import com.pharma.model.Medicine;
import org.apache.ibatis.annotations.*;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface MedicineMapper {
    @Select("SELECT medicine_id AS medicineId, medicine_code AS medicineCode, medicine_name AS medicineName, specification, manufacturer, unit, price FROM medicine")
    List<Medicine> selectAll();

    @Select("SELECT medicine_id AS medicineId, medicine_code AS medicineCode, medicine_name AS medicineName, specification, manufacturer, unit, price FROM medicine WHERE medicine_id = #{id}")
    Medicine selectById(Integer id);

    @Insert("INSERT INTO medicine (medicine_code, medicine_name, specification, manufacturer, unit, price) " +
            "VALUES (#{medicineCode}, #{medicineName}, #{specification}, #{manufacturer}, #{unit}, #{price})")
    @Options(useGeneratedKeys = true, keyProperty = "medicineId")
    void insert(Medicine medicine);

    @Update("UPDATE medicine SET medicine_code = #{medicineCode}, medicine_name = #{medicineName}, " +
            "specification = #{specification}, manufacturer = #{manufacturer}, unit = #{unit}, " +
            "price = #{price} WHERE medicine_id = #{medicineId}")
    void update(Medicine medicine);

    @Delete("DELETE FROM medicine WHERE medicine_id = #{id}")
    void deleteById(Integer id);

    @Select("SELECT medicine_id AS medicineId, medicine_code AS medicineCode, medicine_name AS medicineName, specification, manufacturer, unit, price FROM medicine WHERE medicine_name LIKE CONCAT('%', #{keyword}, '%') " +
            "OR medicine_code LIKE CONCAT('%', #{keyword}, '%') " +
            "OR manufacturer LIKE CONCAT('%', #{keyword}, '%')")

    List<Medicine> search(String keyword);

    List<Medicine> findExpiringMedicines(LocalDate warningDate);
    List<Medicine> findExpiredMedicines(LocalDate currentDate);
}
