package com.pharma.mapper;

import com.pharma.model.Supplier;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface SupplierMapper {
    @Select("SELECT supplier_id AS supplierId, supplier_code AS supplierCode, name, contact_person AS contactPerson, phone, email, address FROM supplier WHERE name LIKE CONCAT('%', #{keyword}, '%') OR supplier_code LIKE CONCAT('%', #{keyword}, '%') ORDER BY supplier_id DESC LIMIT #{offset}, #{pageSize}")
    List<Supplier> selectByPageAndKeyword(@Param("offset") int offset, @Param("pageSize") int pageSize, @Param("keyword") String keyword);

    @Select("SELECT COUNT(*) FROM supplier WHERE name LIKE CONCAT('%', #{keyword}, '%') OR supplier_code LIKE CONCAT('%', #{keyword}, '%')")
    int countByKeyword(@Param("keyword") String keyword);

    @Select("SELECT supplier_id AS supplierId, supplier_code AS supplierCode, name, contact_person AS contactPerson, phone, email, address FROM supplier WHERE supplier_id = #{id}")
    Supplier selectById(Integer id);

    @Insert("INSERT INTO supplier (supplier_code, name, contact_person, phone, email, address) VALUES (#{supplierCode}, #{name}, #{contactPerson}, #{phone}, #{email}, #{address})")
    @Options(useGeneratedKeys = true, keyProperty = "supplierId")
    void insert(Supplier supplier);

    @Update("UPDATE supplier SET supplier_code=#{supplierCode}, name=#{name}, contact_person=#{contactPerson}, phone=#{phone}, email=#{email}, address=#{address} WHERE supplier_id=#{supplierId}")
    void update(Supplier supplier);

    @Delete("DELETE FROM supplier WHERE supplier_id=#{id}")
    void deleteById(Integer id);
} 