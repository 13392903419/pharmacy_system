package com.pharma.mapper;

import com.pharma.model.PurchaseOrder;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface PurchaseOrderMapper {
    @Select("SELECT p.*, s.name AS supplierName, e.name AS employeeName " +
            "FROM purchase_order p " +
            "LEFT JOIN supplier s ON p.supplier_id = s.supplier_id " +
            "LEFT JOIN employee e ON p.employee_id = e.employee_id " +
            "WHERE p.purchase_code LIKE CONCAT('%', #{keyword}, '%') " +
            "OR s.name LIKE CONCAT('%', #{keyword}, '%') " +
            "ORDER BY p.purchase_id DESC LIMIT #{offset}, #{pageSize}")
    List<PurchaseOrder> selectByPageAndKeyword(@Param("offset") int offset, @Param("pageSize") int pageSize, @Param("keyword") String keyword);

    @Select("SELECT COUNT(*) FROM purchase_order p " +
            "LEFT JOIN supplier s ON p.supplier_id = s.supplier_id " +
            "WHERE p.purchase_code LIKE CONCAT('%', #{keyword}, '%') " +
            "OR s.name LIKE CONCAT('%', #{keyword}, '%')")
    int countByKeyword(@Param("keyword") String keyword);

    @Select("SELECT p.*, s.name AS supplierName, e.name AS employeeName " +
            "FROM purchase_order p " +
            "LEFT JOIN supplier s ON p.supplier_id = s.supplier_id " +
            "LEFT JOIN employee e ON p.employee_id = e.employee_id " +
            "WHERE p.purchase_id = #{id}")
    PurchaseOrder selectById(Integer id);

    @Insert("INSERT INTO purchase_order (purchase_code, supplier_id, employee_id, total_amount, status, created_at, updated_at) " +
            "VALUES (#{purchaseCode}, #{supplierId}, #{employeeId}, #{totalAmount}, #{status}, #{createdAt}, #{updatedAt})")
    @Options(useGeneratedKeys = true, keyProperty = "purchaseId")
    void insert(PurchaseOrder purchaseOrder);

    @Update("UPDATE purchase_order SET " +
            "purchase_code = #{purchaseCode}, " +
            "supplier_id = #{supplierId}, " +
            "employee_id = #{employeeId}, " +
            "total_amount = #{totalAmount}, " +
            "status = #{status}, " +
            "updated_at = #{updatedAt} " +
            "WHERE purchase_id = #{purchaseId}")
    void update(PurchaseOrder purchaseOrder);

    @Delete("DELETE FROM purchase_order WHERE purchase_id = #{id}")
    void deleteById(Integer id);

    @Select("SELECT p.*, s.name AS supplierName, e.name AS employeeName " +
            "FROM purchase_order p " +
            "LEFT JOIN supplier s ON p.supplier_id = s.supplier_id " +
            "LEFT JOIN employee e ON p.employee_id = e.employee_id " +
            "WHERE p.status = 'pending' " +
            "ORDER BY p.created_at DESC LIMIT 5")
    List<PurchaseOrder> selectRecentPending();

    @Select("SELECT p.*, s.name AS supplierName, e.name AS employeeName FROM purchase_order p LEFT JOIN supplier s ON p.supplier_id = s.supplier_id LEFT JOIN employee e ON p.employee_id = e.employee_id ORDER BY p.created_at DESC")
    List<PurchaseOrder> selectAll();

    @Select("SELECT COUNT(*) FROM purchase_order WHERE status = 'pending'")
    int countPendingOrders();
}
