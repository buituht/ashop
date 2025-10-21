package com.ashop.controllers.admin;

import com.ashop.entity.Category;
import com.ashop.services.CategoryService;
import com.ashop.services.impl.CategoryServiceImpl; 

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/categories")
public class CategoryListController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final CategoryService categoryService = new CategoryServiceImpl();
    private static final int ITEMS_PER_PAGE = 5; // Có thể đặt khác

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

            long totalCategories = categoryService.countAll();
            int totalPages = (int) Math.ceil((double) totalCategories / ITEMS_PER_PAGE);

            List<Category> categories = categoryService.findWithPagination(currentPage, ITEMS_PER_PAGE);

            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalCategories);
            
            request.getRequestDispatcher("/views/admin/category-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải danh mục.");
        }
    }
}