package com.ashop.controllers.admin;

import com.ashop.entity.Category;
import com.ashop.services.CategoryService;
import com.ashop.services.impl.CategoryServiceImpl; 

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig; // Quan trọng cho upload file
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part; // Cho upload file
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet({"/admin/category/add", "/admin/category/edit"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class CategoryFormController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final CategoryService categoryService = new CategoryServiceImpl();
    // Giả định thư mục lưu ảnh là /images/categories/ trong thư mục wtpwebapps/ashop/
    private static final String UPLOAD_DIR = "/images/categories/"; 

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String servletPath = request.getServletPath();
        
        if (servletPath.equals("/admin/category/edit")) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(idParam);
                    Category category = categoryService.findById(categoryId);
                    
                    if (category != null) {
                        request.setAttribute("category", category);
                    } else {
                        request.getSession().setAttribute("message", "Lỗi: Không tìm thấy danh mục.");
                        response.sendRedirect(request.getContextPath() + "/admin/categories");
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("message", "Lỗi: ID danh mục không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                    return;
                }
            }
        }
        
        request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String servletPath = request.getServletPath();
        Category category;
        String message;
        String imagePath = null;
        String oldImage = request.getParameter("oldImage"); // Tên trường ẩn trong form

        try {
            // Lấy dữ liệu form
            String categoryName = request.getParameter("categoryName");
            String description = request.getParameter("description");
            String statusParam = request.getParameter("status");
            boolean status = "on".equalsIgnoreCase(statusParam) || "true".equalsIgnoreCase(statusParam);

            // Xử lý Upload File
            Part filePart = request.getPart("imageFile"); // Tên trường <input type="file" name="imageFile">
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fullUploadPath = request.getServletContext().getRealPath(UPLOAD_DIR);
                
                // Tạo thư mục nếu chưa tồn tại
                Path uploadPath = Paths.get(fullUploadPath);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                
                // Lưu file vào thư mục vật lý và lấy đường dẫn tương đối để lưu vào DB
                Path filePath = Paths.get(fullUploadPath, fileName);
                filePart.write(filePath.toString());
                imagePath = UPLOAD_DIR + fileName;
            } else {
                imagePath = oldImage; // Giữ lại ảnh cũ nếu không upload ảnh mới
            }

            // --- Logic CẬP NHẬT (EDIT) ---
            if (servletPath.equals("/admin/category/edit")) {
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                
                category = categoryService.findById(categoryId);
                if (category == null) {
                    request.getSession().setAttribute("message", "Lỗi: Cập nhật thất bại. Không tìm thấy danh mục.");
                    response.sendRedirect(request.getContextPath() + "/admin/categories");
                    return;
                }

                category.setCategoryName(categoryName);
                category.setDescription(description);
                category.setImage(imagePath);
                category.setStatus(status);

                message = "Cập nhật danh mục **" + categoryName + "** thành công!";

            // --- Logic THÊM MỚI (ADD) ---
            } else {
                category = new Category(categoryName, description, imagePath, status);
                message = "Thêm mới danh mục **" + categoryName + "** thành công!";
            }
            
            // 2. Lưu/Cập nhật qua Service
            categoryService.saveOrUpdate(category);

            // 3. Chuyển hướng
            request.getSession().setAttribute("message", message);
            response.sendRedirect(request.getContextPath() + "/admin/categories");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
            
            // Đặt lại dữ liệu vào request để người dùng không phải nhập lại
            Category errorCategory = new Category(
                servletPath.equals("/admin/category/edit") ? Integer.valueOf(request.getParameter("categoryId")) : null, 
                request.getParameter("categoryName"), 
                request.getParameter("description"), 
                imagePath != null ? imagePath : oldImage, // Sử dụng ảnh đã upload hoặc ảnh cũ
                "on".equalsIgnoreCase(request.getParameter("status"))
            );
            
            request.setAttribute("category", errorCategory);
            request.getRequestDispatcher("/views/admin/category-form.jsp").forward(request, response);
        }
    }
}