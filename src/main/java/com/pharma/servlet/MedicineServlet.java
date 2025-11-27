package com.pharma.servlet;

import com.pharma.model.Medicine;
import com.pharma.service.MedicineService;
import com.pharma.service.impl.MedicineServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/medicine/*")
public class MedicineServlet extends HttpServlet {
    private MedicineService medicineService;

    @Override
    public void init() throws ServletException {
        medicineService = new MedicineServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        System.out.println("Path Info: " + pathInfo); // 添加调试日志

        if (pathInfo == null || pathInfo.equals("/")) {
            // List all medicines
            List<Medicine> medicines = medicineService.getAllMedicines();
            request.setAttribute("medicines", medicines);
            request.getRequestDispatcher("/WEB-INF/views/medicine/list.jsp").forward(request, response);
        } else if (pathInfo.equals("/add")) {
            // Show add form
            request.getRequestDispatcher("/WEB-INF/views/medicine/form.jsp").forward(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            // Show edit form
            System.out.println("=== enter/edit/ branch===");

            String idStr = pathInfo.substring(6);
            System.out.println("edit idStr: " + idStr);

            try {
                Integer id = Integer.parseInt(idStr);
                Medicine medicine = medicineService.getMedicineById(id);
                if (medicine != null) {
                    request.setAttribute("medicine", medicine);
                    System.out.println("medicine: " + medicine);
                    request.getRequestDispatcher("/WEB-INF/views/medicine/form.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/delete/")) {
            // Delete medicine
            System.out.println("=== enter/delete/branch===");
            String idStr = pathInfo.substring(8);
            try {
                Integer id = Integer.parseInt(idStr);
                medicineService.deleteMedicine(id);
                response.sendRedirect(request.getContextPath() + "/medicine");
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.equals("/search")) {
            // Search medicines
            String keyword = request.getParameter("keyword");
            List<Medicine> medicines = medicineService.searchMedicines(keyword);
            request.setAttribute("medicines", medicines);
            request.getRequestDispatcher("/WEB-INF/views/medicine/list.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        System.out.println("POST Path Info: " + pathInfo); // 添加调试日志

        if (pathInfo == null || pathInfo.equals("/save")) {
            // Save medicine
            Medicine medicine = new Medicine();
            try {
                String idStr = request.getParameter("medicineId");
                if (idStr != null && !idStr.isEmpty()) {
                    medicine.setMedicineId(Integer.parseInt(idStr));
                }
                medicine.setMedicineCode(request.getParameter("medicineCode"));
                medicine.setMedicineName(request.getParameter("medicineName"));
                medicine.setSpecification(request.getParameter("specification"));
                medicine.setManufacturer(request.getParameter("manufacturer"));
                medicine.setUnit(request.getParameter("unit"));
                medicine.setPrice(new java.math.BigDecimal(request.getParameter("price")));

                medicineService.saveMedicine(medicine);
                response.sendRedirect(request.getContextPath() + "/medicine");
            } catch (Exception e) {
                request.setAttribute("error", "保存失败：" + e.getMessage());
                request.setAttribute("medicine", medicine);
                request.getRequestDispatcher("/WEB-INF/views/medicine/form.jsp").forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
} 