package com.pharma.mapper;

import com.pharma.model.PurchaseOrderDetail;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface PurchaseOrderDetailMapper {
    @Select("SELECT d.*, m.medicine_name AS medicineName, m.medicine_code AS medicineCode " +
            "FROM purchase_order_detail d " +
            "LEFT JOIN medicine m ON d.medicine_id = m.medicine_id " +
            "WHERE d.purchase_id = #{purchaseId}")
    List<PurchaseOrderDetail> selectByPurchaseId(Integer purchaseId);

    @Insert("INSERT INTO purchase_order_detail (purchase_id, medicine_id, quantity, unit_price, total_price) " +
            "VALUES (#{purchaseId}, #{medicineId}, #{quantity}, #{unitPrice}, #{totalPrice})")
    @Options(useGeneratedKeys = true, keyProperty = "detailId")
    void insert(PurchaseOrderDetail detail);

    @Update("UPDATE purchase_order_detail SET " +
            "medicine_id = #{medicineId}, " +
            "quantity = #{quantity}, " +
            "unit_price = #{unitPrice}, " +
            "total_price = #{totalPrice} " +
            "WHERE detail_id = #{detailId}")
    void update(PurchaseOrderDetail detail);

    @Delete("DELETE FROM purchase_order_detail WHERE detail_id = #{detailId}")
    void deleteById(Integer detailId);

    @Delete("DELETE FROM purchase_order_detail WHERE purchase_id = #{purchaseId}")
    void deleteByPurchaseId(Integer purchaseId);
} 