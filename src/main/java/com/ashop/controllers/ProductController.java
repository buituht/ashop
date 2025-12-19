package com.ashop.controllers;

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

@WebServlet({"/products", "/product", "/promotions"})
public class ProductController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ProductService productService = new ProductServiceImpl();
    private static final int ITEMS_PER_PAGE = 12;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String servletPath = request.getServletPath();
        try {
            if (servletPath.equals("/products")) {
                int currentPage = 1;
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    try {
                        currentPage = Integer.parseInt(pageParam);
                    } catch (NumberFormatException e) {
                        currentPage = 1;
                    }
                }

                long total = productService.countActive();
                int totalPages = (int) Math.ceil((double) total / ITEMS_PER_PAGE);

                List<Product> products = productService.findActiveWithPagination(currentPage, ITEMS_PER_PAGE);

                request.setAttribute("products", products);
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("totalPages", totalPages);
                request.getRequestDispatcher("/views/product-list.jsp").forward(request, response);

            } else if (servletPath.equals("/product")) {
                String idParam = request.getParameter("id");
                if (idParam == null) {
                    response.sendRedirect(request.getContextPath() + "/products");
                    return;
                }
                int id;
                try {
                    id = Integer.parseInt(idParam);
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/products");
                    return;
                }

                Product product = productService.findById(id);
                if (product == null || product.getStatus() == null || !product.getStatus()) {
                    response.sendRedirect(request.getContextPath() + "/products");
                    return;
                }

                request.setAttribute("product", product);
                request.getRequestDispatcher("/views/product-detail.jsp").forward(request, response);

            } else if (servletPath.equals("/promotions")) {
                int currentPage = 1;
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    try {
                        currentPage = Integer.parseInt(pageParam);
                    } catch (NumberFormatException e) {
                        currentPage = 1;
                    }
                }

                long total = productService.countDiscountedActive();
                int totalPages = (int) Math.ceil((double) total / ITEMS_PER_PAGE);

                List<Product> products = productService.findDiscountedActiveWithPagination(currentPage, ITEMS_PER_PAGE);

                request.setAttribute("products", products);
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("totalPages", totalPages);
                request.getRequestDispatcher("/views/product-promotions.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý sản phẩm.");
        }
    }
}