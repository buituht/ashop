package com.ashop.controllers.admin;

import com.ashop.entity.Product;
import com.ashop.services.ProductService;
import com.ashop.services.impl.ProductServiceImpl; 

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/products")
public class ProductListController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final ProductService productService = new ProductServiceImpl();
    private static final int ITEMS_PER_PAGE = 10; 

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            long totalProducts = productService.countAll();
            int totalPages = (int) Math.ceil((double) totalProducts / ITEMS_PER_PAGE);

            List<Product> products = productService.findWithPagination(currentPage, ITEMS_PER_PAGE);

            request.setAttribute("products", products);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalProducts);
            
            request.getRequestDispatcher("/views/admin/product-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải danh sách sản phẩm.");
        }
    }
}