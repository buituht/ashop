package com.ashop.controllers.admin;

import com.ashop.entity.Category;
import com.ashop.entity.Product;
import com.ashop.services.CategoryService;
import com.ashop.services.ProductService;
import com.ashop.services.impl.CategoryServiceImpl; 
import com.ashop.services.impl.ProductServiceImpl;
 
import com.ashop.utils.SlugUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@WebServlet({"/admin/product/add", "/admin/product/edit"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class ProductFormController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final ProductService productService = new ProductServiceImpl();
    private final CategoryService categoryService = new CategoryServiceImpl();
    
    private static final String UPLOAD_DIR = "/images/products/"; 

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        // Đặt danh sách Category vào request để đổ vào Dropdown
        List<Category> categories = categoryService.findAll();
        request.setAttribute("categories", categories);
        
        String servletPath = request.getServletPath();
        
        if (servletPath.equals("/admin/product/edit")) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    int productId = Integer.parseInt(idParam);
                    Product product = productService.findById(productId);
                    
                    if (product != null) {
                        request.setAttribute("product", product);
                    } else {
                        request.getSession().setAttribute("message", "Lỗi: Không tìm thấy sản phẩm.");
                        response.sendRedirect(request.getContextPath() + "/admin/products");
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("message", "Lỗi: ID sản phẩm không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/admin/products");
                    return;
                }
            }
        }
        
        request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);
    }



    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String servletPath = request.getServletPath();
        Product product;
        String message;
        String imagePath = null;
        String oldImage = request.getParameter("oldImage"); 

        // --- Bắt đầu khối TRY (Áp dụng safe parsing) ---
        try {
            // 1. Lấy dữ liệu cơ bản và áp dụng SAFE PARSING
            String productName = request.getParameter("productName");
            String description = request.getParameter("description");
            
            // Dùng safeParseInteger và safeParseBigDecimal
            Integer categoryId = safeParseInteger(request.getParameter("categoryId")); 
            BigDecimal price = safeParseBigDecimal(request.getParameter("price")); 
            BigDecimal salePrice = safeParseBigDecimal(request.getParameter("salePrice")); 
            Integer quantity = safeParseInteger(request.getParameter("quantity"));
            
            boolean status = "on".equalsIgnoreCase(request.getParameter("status"));
            
            // 2. Xử lý Slug
            String slug = SlugUtil.toSlug(productName); 
            
            // 3. Xử lý Upload File (Giữ nguyên logic upload)
            Part filePart = request.getPart("imageFile"); 
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fullUploadPath = request.getServletContext().getRealPath(UPLOAD_DIR);
                
                Path uploadPath = Paths.get(fullUploadPath);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                
                Path filePath = Paths.get(fullUploadPath, fileName);
                filePart.write(filePath.toString());
                imagePath = UPLOAD_DIR + fileName;
            } else {
                imagePath = oldImage;
            }
            
            // 4. Lấy đối tượng Category
            Category category = categoryService.findById(categoryId);
            if (category == null) {
                 throw new IllegalArgumentException("Danh mục không hợp lệ hoặc không tồn tại.");
            }

            // --- Logic CẬP NHẬT (EDIT) ---
            if (servletPath.equals("/admin/product/edit")) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                product = productService.findById(productId);
                
                if (product == null) {
                    throw new RuntimeException("Không tìm thấy sản phẩm để cập nhật.");
                }

                // Cập nhật Entity
                product.setProductName(productName);
                product.setSlug(slug);
                product.setPrice(price);
                product.setSalePrice(salePrice);
                product.setQuantity(quantity);
                product.setDescription(description);
                product.setImage(imagePath);
                product.setStatus(status);
                product.setCategory(category); 

                message = "Cập nhật sản phẩm **" + productName + "** thành công!";

            // --- Logic THÊM MỚI (ADD) ---
            } else {
                // Constructor mới (chỉ có các tham số chính)
                product = new Product();
                product.setProductName(productName);
                product.setSlug(slug);
                product.setPrice(price);
                product.setSalePrice(salePrice);
                product.setQuantity(quantity);
                product.setDescription(description);
                product.setImage(imagePath);
                product.setStatus(status);
                product.setCategory(category);
                
                message = "Thêm mới sản phẩm **" + productName + "** thành công!";
            }
            
            // 5. Lưu/Cập nhật
            productService.saveOrUpdate(product);

            // 6. Chuyển hướng
            request.getSession().setAttribute("message", message);
            response.sendRedirect(request.getContextPath() + "/admin/products");

        } catch (Exception e) {
            e.printStackTrace();
            
            // --- BẮT ĐẦU KHỐI CATCH (TÁI TẠO DỮ LIỆU) ---
            
            // 1. Tái tạo dữ liệu form an toàn
            request.setAttribute("categories", categoryService.findAll());
            
            Product errorProduct = new Product();
            
            // Lấy ID nếu là EDIT
            if (servletPath.equals("/admin/product/edit") && request.getParameter("productId") != null) {
                errorProduct.setProductId(safeParseInteger(request.getParameter("productId")));
            }
            
            // Gán các giá trị AN TOÀN từ request
            errorProduct.setProductName(request.getParameter("productName"));
            errorProduct.setPrice(safeParseBigDecimal(request.getParameter("price")));
            errorProduct.setSalePrice(safeParseBigDecimal(request.getParameter("salePrice")));
            errorProduct.setQuantity(safeParseInteger(request.getParameter("quantity")));
            errorProduct.setDescription(request.getParameter("description"));
            errorProduct.setImage(imagePath != null ? imagePath : oldImage);
            errorProduct.setStatus("on".equalsIgnoreCase(request.getParameter("status"))); 
            
            // Set lại Category cho Dropdown
            String errorCategoryIdStr = request.getParameter("categoryId");
            if (errorCategoryIdStr != null && !errorCategoryIdStr.isEmpty()) {
                try {
                    Integer errCategoryId = safeParseInteger(errorCategoryIdStr);
                    if (errCategoryId != 0) {
                        errorProduct.setCategory(categoryService.findById(errCategoryId));
                    }
                } catch (Exception ignored) {}
            }
            
            // 2. Set Attributes và Forward
            request.setAttribute("product", errorProduct);
            request.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/product/product-form.jsp").forward(request, response);
        }
    }
    
    
    private BigDecimal safeParseBigDecimal(String param) {
        if (param == null || param.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        try {
            return new BigDecimal(param.trim());
        } catch (NumberFormatException e) {
            // Trả về 0 hoặc ném lỗi nếu cần, nhưng 0 là an toàn nhất khi xử lý lỗi
            return BigDecimal.ZERO; 
        }
    }

    private Integer safeParseInteger(String param) {
        if (param == null || param.trim().isEmpty()) {
            return 0; // Trả về 0 hoặc null nếu cột DB cho phép
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (NumberFormatException e) {
            return 0; 
        }
    }
}