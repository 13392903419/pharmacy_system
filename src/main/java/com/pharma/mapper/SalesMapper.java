package com.pharma.mapper;

import com.pharma.model.SalesOrder;
import com.pharma.model.SalesOrderDetail;
import org.apache.ibatis.annotations.*;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface SalesMapper {
        @Select("SELECT sales_id AS salesId, sales_code AS salesCode, customer_id AS customerId, employee_id AS employeeId, total_amount AS totalAmount, status, created_at AS createdAt, updated_at AS updatedAt FROM sales_order WHERE sales_code LIKE CONCAT('%', #{keyword}, '%') ORDER BY created_at DESC LIMIT #{offset}, #{pageSize}")
    List<SalesOrder> selectByPageAndKeyword(@Param("offset") int offset, @Param("pageSize") int pageSize, @Param("keyword") String keyword);

    @Select("SELECT COUNT(*) FROM sales_order s WHERE s.sales_code LIKE CONCAT('%', #{keyword}, '%')")
    int countByKeyword(@Param("keyword") String keyword);

    // ========== 修改这个方法，添加明细查询 ==========
    @Select("SELECT so.sales_id AS salesId, so.sales_code AS salesCode, so.customer_id AS customerId, so.employee_id AS employeeId, so.total_amount AS totalAmount, so.status, so.created_at AS createdAt, so.updated_at AS updatedAt FROM sales_order so WHERE so.sales_id = #{id}")
    @Results({
            @Result(id = true, property = "salesId", column = "salesId"),
            @Result(property = "salesCode", column = "salesCode"),
            @Result(property = "customerId", column = "customerId"),
            @Result(property = "employeeId", column = "employeeId"),
            @Result(property = "totalAmount", column = "totalAmount"),
            @Result(property = "status", column = "status"),
            @Result(property = "createdAt", column = "createdAt"),
            @Result(property = "updatedAt", column = "updatedAt"),
            @Result(property = "details", column = "salesId",
                    many = @Many(select = "selectDetailsBySalesId"))
    })
    SalesOrder selectById(Integer id);

    // ========== 新增：查询销售明细的方法 ==========
    @Select("SELECT " +
            "sod.detail_id AS detailId, " +
            "sod.sales_id AS salesId, " +
            "sod.medicine_id AS medicineId, " +
            "m.medicine_code AS medicineCode, " +
            "m.medicine_name AS medicineName, " +
            "sod.quantity, " +
            "sod.unit_price AS unitPrice, " +
            "sod.total_price AS totalPrice " +
            "FROM sales_order_detail sod " +
            "LEFT JOIN medicine m ON sod.medicine_id = m.medicine_id " +
            "WHERE sod.sales_id = #{salesId}")
    List<SalesOrderDetail> selectDetailsBySalesId(Integer salesId);


    @Insert("INSERT INTO sales_order (sales_code, customer_id, employee_id, total_amount, status, created_at, updated_at) VALUES (#{salesCode}, #{customerId}, #{employeeId}, #{totalAmount}, #{status}, NOW(), NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "salesId")
    void insert(SalesOrder order);

    @Update("UPDATE sales_order SET sales_code=#{salesCode}, customer_id=#{customerId}, employee_id=#{employeeId}, total_amount=#{totalAmount}, status=#{status}, updated_at=NOW() WHERE sales_id=#{salesId}")
    void update(SalesOrder order);

    @Delete("DELETE FROM sales_order WHERE sales_id=#{id}")
    void deleteById(Integer id);

    // 添加这个方法到你的SalesMapper.java
    @Insert("INSERT INTO sales_order_detail (sales_id, medicine_id, quantity, unit_price, total_price) " +
            "VALUES (#{salesId}, #{medicineId}, #{quantity}, #{unitPrice}, #{totalPrice})")
    void insertDetail(SalesOrderDetail detail);

    // 新增：删除明细的方法
    @Delete("DELETE FROM sales_order_detail WHERE sales_id = #{salesId}")
    void deleteDetailsBySalesId(Integer salesId);

    // 统计今日销售数量
    @Select("SELECT COUNT(*) FROM sales_order so WHERE so.status = 'completed' AND so.created_at BETWEEN #{startTime} AND #{endTime}")
    int countTodaySales(@Param("startTime") LocalDateTime startTime, @Param("endTime") LocalDateTime endTime);

    // 获取最近的销售记录
    @Select("SELECT so.sales_id AS salesId, so.sales_code AS salesCode, so.customer_id AS customerId, so.employee_id AS employeeId, so.total_amount AS totalAmount, so.status, so.created_at AS createdAt, so.updated_at AS updatedAt FROM sales_order so ORDER BY so.created_at DESC LIMIT #{limit}")
    List<SalesOrder> selectRecentSales(@Param("limit") int limit);

    // 添加查询所有销售订单的方法（用于报表）
    @Select("SELECT so.sales_id AS salesId, so.sales_code AS salesCode, so.customer_id AS customerId, " +
            "so.employee_id AS employeeId, so.total_amount AS totalAmount, so.status, " +
            "so.created_at AS createdAt, so.updated_at AS updatedAt " +
            "FROM sales_order so ORDER BY so.created_at DESC")
    List<SalesOrder> selectAll();
}