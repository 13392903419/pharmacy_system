package com.pharma.service.impl;

import com.pharma.mapper.MedicineMapper;
import com.pharma.model.Medicine;
import com.pharma.service.MedicineService;
import com.pharma.util.DBUtil;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class MedicineServiceImpl implements MedicineService {
    private static SqlSessionFactory sqlSessionFactory;

    static {
        try {
            String resource = "mybatis-config.xml";
            InputStream inputStream = Resources.getResourceAsStream(resource);
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Medicine> getAllMedicines() {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            MedicineMapper mapper = session.getMapper(MedicineMapper.class);
            return mapper.selectAll();
        }
    }

    @Override
    public Medicine getMedicineById(Integer id) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            MedicineMapper mapper = session.getMapper(MedicineMapper.class);
            return mapper.selectById(id);
        }
    }

    @Override
    public void saveMedicine(Medicine medicine) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            MedicineMapper mapper = session.getMapper(MedicineMapper.class);
            if (medicine.getMedicineId() == null) {
                mapper.insert(medicine);
            } else {
                mapper.update(medicine);
            }
            session.commit();
        }
    }

    @Override
    public void deleteMedicine(Integer id) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            MedicineMapper mapper = session.getMapper(MedicineMapper.class);
            mapper.deleteById(id);
            session.commit();
        }
    }

    @Override
    public List<Medicine> searchMedicines(String keyword) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            MedicineMapper mapper = session.getMapper(MedicineMapper.class);
            return mapper.search(keyword);
        }
    }
} 