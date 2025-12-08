package com.pharma.mapper;

import com.pharma.model.Employee;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface EmployeeMapper {
    @Select("SELECT * FROM employee")
    List<Employee> selectAll();

    @Select("SELECT employee_id AS employeeId, employee_code AS employeeCode, name, gender, phone, email, position, status FROM employee WHERE name LIKE CONCAT('%', #{keyword}, '%') OR employee_code LIKE CONCAT('%', #{keyword}, '%') ORDER BY employee_id DESC LIMIT #{offset}, #{pageSize}")
    List<Employee> selectByPageAndKeyword(@Param("offset") int offset, @Param("pageSize") int pageSize, @Param("keyword") String keyword);

    @Select("SELECT COUNT(*) FROM employee WHERE name LIKE CONCAT('%', #{keyword}, '%') OR employee_code LIKE CONCAT('%', #{keyword}, '%')")
    int countByKeyword(@Param("keyword") String keyword);

    @Select("SELECT employee_id AS employeeId, employee_code AS employeeCode, name, gender, phone, email, position, status FROM employee WHERE employee_id = #{id}")
    Employee selectById(Integer id);

    @Select("SELECT employee_id AS employeeId, employee_code AS employeeCode, name, gender, phone, email, position, status FROM employee WHERE position = #{position}")
    List<Employee> selectByPosition(@Param("position") String position);

    @Select("SELECT COUNT(*) FROM employee WHERE employee_code = #{employeeCode} AND (#{excludeId} IS NULL OR employee_id != #{excludeId})")
    int countByEmployeeCode(@Param("employeeCode") String employeeCode, @Param("excludeId") Integer excludeId);

    @Insert("INSERT INTO employee (employee_code, name, gender, phone, email, position, status) VALUES (#{employeeCode}, #{name}, #{gender}, #{phone}, #{email}, #{position}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "employeeId")
    void insert(Employee employee);

    @Update("UPDATE employee SET employee_code=#{employeeCode}, name=#{name}, gender=#{gender}, phone=#{phone}, email=#{email}, position=#{position}, status=#{status} WHERE employee_id=#{employeeId}")
    void update(Employee employee);

    @Delete("DELETE FROM employee WHERE employee_id=#{id}")
    void deleteById(Integer id);
} 