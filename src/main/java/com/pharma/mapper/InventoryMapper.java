package com.pharma.mapper;

import com.pharma.model.Inventory;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface InventoryMapper {
    @Select("SELECT i.*, m.medicine_name AS medicineName, m.medicine_code AS medicineCode " +
            "FROM inventory i " +
            "LEFT JOIN medicine m ON i.medicine_id = m.medicine_id " +
            "WHERE m.medicine_name LIKE CONCAT('%', #{keyword}, '%') " +
            "OR m.medicine_code LIKE CONCAT('%', #{keyword}, '%') " +
            "OR i.batch_number LIKE CONCAT('%', #{keyword}, '%') " +
            "ORDER BY i.inventory_id DESC LIMIT #{offset}, #{pageSize}")
    List<Inventory> selectByPageAndKeyword(@Param("offset") int offset, @Param("pageSize") int pageSize, @Param("keyword") String keyword);

    @Select("SELECT COUNT(*) FROM inventory i " +
            "LEFT JOIN medicine m ON i.medicine_id = m.medicine_id " +
            "WHERE m.medicine_name LIKE CONCAT('%', #{keyword}, '%') " +
            "OR m.medicine_code LIKE CONCAT('%', #{keyword}, '%') " +
            "OR i.batch_number LIKE CONCAT('%', #{keyword}, '%')")
    int countByKeyword(@Param("keyword") String keyword);

    @Select("SELECT i.*, m.medicine_name AS medicineName, m.medicine_code AS medicineCode " +
            "FROM inventory i " +
            "LEFT JOIN medicine m ON i.medicine_id = m.medicine_id " +
            "WHERE i.inventory_id = #{id}")
    Inventory selectById(Integer id);

    @Insert("INSERT INTO inventory (medicine_id, quantity, min_stock, max_stock, batch_number, production_date, expiry_date, " +
            "location, status, created_at, updated_at) " +
            "VALUES (#{medicineId}, #{quantity}, #{minStock}, #{maxStock}, #{batchNumber}, #{productionDate}, #{expiryDate}, " +
            "#{location}, #{status}, #{createdAt}, #{updatedAt})")
    @Options(useGeneratedKeys = true, keyProperty = "inventoryId")
    void insert(Inventory inventory);

    @Update("UPDATE inventory SET " +
            "medicine_id = #{medicineId}, " +
            "quantity = #{quantity}, " +
            "min_stock = #{minStock}, " +
            "max_stock = #{maxStock}, " +
            "batch_number = #{batchNumber}, " +
            "production_date = #{productionDate}, " +
            "expiry_date = #{expiryDate}, " +
            "location = #{location}, " +
            "status = #{status}, " +
            "updated_at = #{updatedAt} " +
            "WHERE inventory_id = #{inventoryId}")
    void update(Inventory inventory);

    @Delete("DELETE FROM inventory WHERE inventory_id = #{id}")
    void deleteById(Integer id);

    @Select("SELECT i.*, m.medicine_name AS medicineName, m.medicine_code AS medicineCode " +
            "FROM inventory i " +
            "LEFT JOIN medicine m ON i.medicine_id = m.medicine_id " +
            "WHERE i.medicine_id = #{medicineId}")
    List<Inventory> selectByMedicineId(Integer medicineId);

    @Select("SELECT i.*, m.medicine_name AS medicineName, m.medicine_code AS medicineCode " +
            "FROM inventory i " +
            "LEFT JOIN medicine m ON i.medicine_id = m.medicine_id " +
            "WHERE i.quantity <= 10 OR (i.expiry_date > CURDATE() AND i.expiry_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY)) " +
            "ORDER BY i.expiry_date ASC LIMIT 5")
    List<Inventory> selectWarnings();

    @Select("SELECT i.*, m.medicine_name AS medicineName, m.medicine_code AS medicineCode " +
            "FROM inventory i " +
            "LEFT JOIN medicine m ON i.medicine_id = m.medicine_id " +
            "WHERE i.expiry_date > CURDATE() AND i.expiry_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) " +
            "ORDER BY i.expiry_date ASC")
    List<Inventory> selectExpiringList();

    @Select("SELECT i.*, m.medicine_name AS medicineName, m.medicine_code AS medicineCode " +
            "FROM inventory i " +
            "LEFT JOIN medicine m ON i.medicine_id = m.medicine_id " +
            "WHERE i.quantity <= 10 " +
            "ORDER BY i.quantity ASC")
    List<Inventory> selectLowQuantityList();

    @Select("SELECT COUNT(*) FROM inventory WHERE quantity <= 10 OR (expiry_date > CURDATE() AND expiry_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY))")
    int countWarningAll();

    // 获取最近的库存预警记录
    @Select("SELECT i.*, m.medicine_name AS medicineName, m.medicine_code AS medicineCode " +
            "FROM inventory i " +
            "LEFT JOIN medicine m ON i.medicine_id = m.medicine_id " +
            "WHERE i.quantity <= 10 OR (i.expiry_date > CURDATE() AND i.expiry_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY)) " +
            "ORDER BY i.updated_at DESC LIMIT #{limit}")
    List<Inventory> selectRecentWarnings(@Param("limit") int limit);

    // 获取已过期的药品列表
    @Select("SELECT i.*, m.medicine_name AS medicineName, m.medicine_code AS medicineCode " +
            "FROM inventory i " +
            "LEFT JOIN medicine m ON i.medicine_id = m.medicine_id " +
            "WHERE i.expiry_date <= CURDATE() " +
            "ORDER BY i.expiry_date ASC")
    List<Inventory> selectExpiredList();

    /**
     * 根据药品ID获取当前库存总数量
     * @param medicineId 药品ID
     * @return 库存总数量
     */
    @Select("SELECT SUM(quantity) FROM inventory WHERE medicine_id = #{medicineId} AND status != 'expired'")
    Integer getStockByMedicineId(Integer medicineId);

    /**
     * 减少库存（按批次，先进先出）
     * @param medicineId 药品ID
     * @param quantity 减少数量
     * @return 影响行数
     */
    @Update("UPDATE inventory SET " +
            "quantity = CASE " +
            "  WHEN quantity >= #{quantity} THEN quantity - #{quantity} " +
            "  ELSE 0 " +
            "END, " +
            "updated_at = NOW() " +
            "WHERE medicine_id = #{medicineId} " +
            "AND status != 'expired' " +
            "AND quantity > 0 " +
            "ORDER BY expiry_date ASC " +
            "LIMIT 1")
    int reduceStock(@Param("medicineId") Integer medicineId, @Param("quantity") Integer quantity);
    /**
     * 增加库存（删除订单时恢复库存）
     * @param medicineId 药品ID
     * @param quantity 增加数量
     * @return 影响行数
     */
    @Update("UPDATE inventory SET " +
            "quantity = quantity + #{quantity}, " +
            "updated_at = NOW() " +
            "WHERE medicine_id = #{medicineId}")
    int addStock(@Param("medicineId") Integer medicineId, @Param("quantity") Integer quantity);

    List<Inventory> findLowStockItems();
}


