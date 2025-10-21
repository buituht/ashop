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

        try {
            // 1. Lấy dữ liệu cơ bản
            String productName = request.getParameter("productName");
            String description = request.getParameter("description");
            Integer categoryId = Integer.parseInt(request.getParameter("categoryId"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            BigDecimal salePrice = new BigDecimal(request.getParameter("salePrice"));
            Integer quantity = Integer.parseInt(request.getParameter("quantity"));
            boolean status = "on".equalsIgnoreCase(request.getParameter("status"));
            
            // 2. Xử lý Slug
            String slug = SlugUtil.toSlug(productName); 
            
            // 3. Xử lý Upload File
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
                imagePath = oldImage; // Giữ lại ảnh cũ
            }
            
            // 4. Lấy đối tượng Category
            Category category = categoryService.findById(categoryId);
            if (category == null) {
                 throw new IllegalArgumentException("Danh mục không hợp lệ.");
            }

            // --- Logic CẬP NHẬT (EDIT) ---
            if (servletPath.equals("/admin/product/edit")) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                product = productService.findById(productId);
                
                if (product == null) {
                    throw new RuntimeException("Không tìm thấy sản phẩm để cập nhật.");
                }

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
                product = new Product(null, productName, slug, price, salePrice, quantity, description, imagePath, status);
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
            request.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
            
            // Đặt lại danh sách Category và dữ liệu Product để hiển thị lại form
            request.setAttribute("categories", categoryService.findAll());
            Product errorProduct = new Product(
                servletPath.equals("/admin/product/edit") ? Integer.valueOf(request.getParameter("productId")) : null, 
                request.getParameter("productName"), 
                request.getParameter("slug") != null ? request.getParameter("slug") : SlugUtil.toSlug(request.getParameter("productName")),
                new BigDecimal(request.getParameter("price")), 
                new BigDecimal(request.getParameter("salePrice")), 
                Integer.parseInt(request.getParameter("quantity")), 
                request.getParameter("description"), 
                imagePath != null ? imagePath : oldImage,
                "on".equalsIgnoreCase(request.getParameter("status"))
            );
            
            // Cần set lại Category cho errorProduct để Dropdown hiển thị đúng lựa chọn cũ
            if (request.getParameter("categoryId") != null) {
                try {
                    errorProduct.setCategory(categoryService.findById(Integer.parseInt(request.getParameter("categoryId"))));
                } catch (Exception ignored) {}
            }
            
            request.setAttribute("product", errorProduct);
            request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);
        }
    }
}