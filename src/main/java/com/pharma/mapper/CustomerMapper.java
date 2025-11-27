package com.pharma.mapper;

import com.pharma.model.Customer;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface CustomerMapper {
    @Select("SELECT customer_id AS customerId, customer_code AS customerCode, name, contact_person AS contactPerson, phone, email, address, type FROM customer WHERE name LIKE CONCAT('%', #{keyword}, '%') OR customer_code LIKE CONCAT('%', #{keyword}, '%') ORDER BY customer_id DESC LIMIT #{offset}, #{pageSize}")
    List<Customer> selectByPageAndKeyword(@Param("offset") int offset, @Param("pageSize") int pageSize, @Param("keyword") String keyword);

    @Select("SELECT COUNT(*) FROM customer WHERE name LIKE CONCAT('%', #{keyword}, '%') OR customer_code LIKE CONCAT('%', #{keyword}, '%')")
    int countByKeyword(@Param("keyword") String keyword);

    @Select("SELECT customer_id AS customerId, customer_code AS customerCode, name, contact_person AS contactPerson, phone, email, address, type FROM customer WHERE customer_id = #{id}")
    Customer selectById(Integer id);

    @Insert("INSERT INTO customer (customer_code, name, contact_person, phone, email, address, type) VALUES (#{customerCode}, #{name}, #{contactPerson}, #{phone}, #{email}, #{address}, #{type})")
    @Options(useGeneratedKeys = true, keyProperty = "customerId")
    void insert(Customer customer);

    @Update("UPDATE customer SET customer_code=#{customerCode}, name=#{name}, contact_person=#{contactPerson}, phone=#{phone}, email=#{email}, address=#{address}, type=#{type} WHERE customer_id=#{customerId}")
    void update(Customer customer);

    @Delete("DELETE FROM customer WHERE customer_id=#{id}")
    void deleteById(Integer id);
} 