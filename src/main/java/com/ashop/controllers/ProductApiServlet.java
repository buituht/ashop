package com.ashop.controllers;

import com.ashop.entity.Product;
import com.ashop.services.ProductService;
import com.ashop.services.impl.ProductServiceImpl;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/products")
public class ProductApiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ProductService productService = new ProductServiceImpl();
    private final Gson gson = new Gson();
    private static final int ITEMS_PER_PAGE = 12;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        try {
            String action = request.getParameter("action");
            
            if ("filter".equals(action)) {
                handleFilter(request, response);
            } else if ("load-more".equals(action)) {
                handleLoadMore(request, response);
            } else if ("pagination".equals(action)) {
                handlePagination(request, response);
            } else {
                sendError(response, 400, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, 500, "Lỗi server: " + e.getMessage());
        }
    }

    /**
     * Xử lý lọc sản phẩm theo category
     */
    private void handleFilter(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String categoryId = request.getParameter("categoryId");
        String sortBy = request.getParameter("sort");
        int page = getPageParameter(request, 1);

        List<Product> products;
        long total;

        try {
            if (categoryId != null && !categoryId.isEmpty() && !"0".equals(categoryId)) {
                int catId = Integer.parseInt(categoryId);
                // Dùng phương thức sắp xếp từ database
                if (sortBy != null && !sortBy.isEmpty()) {
                    products = productService.findByCategorySorted(catId, page, ITEMS_PER_PAGE, sortBy);
                } else {
                    products = productService.findByCategoryWithPagination(catId, page, ITEMS_PER_PAGE);
                }
                total = productService.countByCategory(catId);
            } else {
                // Dùng phương thức sắp xếp từ database
                if (sortBy != null && !sortBy.isEmpty()) {
                    products = productService.findActiveSorted(page, ITEMS_PER_PAGE, sortBy);
                } else {
                    products = productService.findActiveWithPagination(page, ITEMS_PER_PAGE);
                }
                total = productService.countActive();
            }

            int totalPages = (int) Math.ceil((double) total / ITEMS_PER_PAGE);

            JsonObject response_obj = new JsonObject();
            response_obj.addProperty("success", true);
            response_obj.addProperty("currentPage", page);
            response_obj.addProperty("totalPages", totalPages);
            response_obj.addProperty("totalItems", total);
            response_obj.add("products", gson.toJsonTree(convertProductsToJson(products)));

            response.getWriter().write(response_obj.toString());
        } catch (NumberFormatException e) {
            sendError(response, 400, "Invalid category ID");
        }
    }

    /**
     * Xử lý lazy loading - tải thêm sản phẩm
     */
    private void handleLoadMore(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int page = getPageParameter(request, 1);
        String categoryId = request.getParameter("categoryId");
        String sortBy = request.getParameter("sort");

        List<Product> products;
        long total;

        try {
            if (categoryId != null && !categoryId.isEmpty() && !"0".equals(categoryId)) {
                int catId = Integer.parseInt(categoryId);
                // Dùng phương thức sắp xếp từ database
                if (sortBy != null && !sortBy.isEmpty()) {
                    products = productService.findByCategorySorted(catId, page, ITEMS_PER_PAGE, sortBy);
                } else {
                    products = productService.findByCategoryWithPagination(catId, page, ITEMS_PER_PAGE);
                }
                total = productService.countByCategory(catId);
            } else {
                // Dùng phương thức sắp xếp từ database
                if (sortBy != null && !sortBy.isEmpty()) {
                    products = productService.findActiveSorted(page, ITEMS_PER_PAGE, sortBy);
                } else {
                    products = productService.findActiveWithPagination(page, ITEMS_PER_PAGE);
                }
                total = productService.countActive();
            }

            int totalPages = (int) Math.ceil((double) total / ITEMS_PER_PAGE);
            boolean hasMore = page < totalPages;

            JsonObject response_obj = new JsonObject();
            response_obj.addProperty("success", true);
            response_obj.addProperty("hasMore", hasMore);
            response_obj.addProperty("currentPage", page);
            response_obj.addProperty("totalPages", totalPages);
            response_obj.add("products", gson.toJsonTree(convertProductsToJson(products)));

            response.getWriter().write(response_obj.toString());
        } catch (NumberFormatException e) {
            sendError(response, 400, "Invalid parameters");
        }
    }

    /**
     * Xử lý phân trang thông thường
     */
    private void handlePagination(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int page = getPageParameter(request, 1);
        String categoryId = request.getParameter("categoryId");
        String sortBy = request.getParameter("sort");

        List<Product> products;
        long total;

        try {
            if (categoryId != null && !categoryId.isEmpty() && !"0".equals(categoryId)) {
                int catId = Integer.parseInt(categoryId);
                // Dùng phương thức sắp xếp từ database
                if (sortBy != null && !sortBy.isEmpty()) {
                    products = productService.findByCategorySorted(catId, page, ITEMS_PER_PAGE, sortBy);
                } else {
                    products = productService.findByCategoryWithPagination(catId, page, ITEMS_PER_PAGE);
                }
                total = productService.countByCategory(catId);
            } else {
                // Dùng phương thức sắp xếp từ database
                if (sortBy != null && !sortBy.isEmpty()) {
                    products = productService.findActiveSorted(page, ITEMS_PER_PAGE, sortBy);
                } else {
                    products = productService.findActiveWithPagination(page, ITEMS_PER_PAGE);
                }
                total = productService.countActive();
            }

            int totalPages = (int) Math.ceil((double) total / ITEMS_PER_PAGE);

            JsonObject response_obj = new JsonObject();
            response_obj.addProperty("success", true);
            response_obj.addProperty("currentPage", page);
            response_obj.addProperty("totalPages", totalPages);
            response_obj.addProperty("totalItems", total);
            response_obj.add("products", gson.toJsonTree(convertProductsToJson(products)));

            response.getWriter().write(response_obj.toString());
        } catch (NumberFormatException e) {
            sendError(response, 400, "Invalid parameters");
        }
    }

    /**
     * Chuyển đổi Product entities sang JSON objects đơn giản
     */
    private JsonArray convertProductsToJson(List<Product> products) {
        JsonArray jsonArray = new JsonArray();
        for (Product product : products) {
            JsonObject obj = new JsonObject();
            obj.addProperty("productId", product.getProductId());
            obj.addProperty("productName", product.getProductName());
            obj.addProperty("slug", product.getSlug());
            obj.addProperty("price", product.getPrice().doubleValue());
            obj.addProperty("salePrice", product.getSalePrice() != null ? product.getSalePrice().doubleValue() : 0);
            obj.addProperty("image", product.getImage() != null ? product.getImage() : "");
            obj.addProperty("shortDescription", product.getShortDescription() != null ? product.getShortDescription() : "Sản phẩm chất lượng");
            obj.addProperty("categoryName", product.getCategory() != null ? product.getCategory().getCategoryName() : "");
            jsonArray.add(obj);
        }
        return jsonArray;
    }

    private int getPageParameter(HttpServletRequest request, int defaultValue) {
        String pageParam = request.getParameter("page");
        try {
            return pageParam != null ? Integer.parseInt(pageParam) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private void sendError(HttpServletResponse response, int statusCode, String message) throws IOException {
        response.setStatus(statusCode);
        JsonObject errorObj = new JsonObject();
        errorObj.addProperty("success", false);
        errorObj.addProperty("message", message);
        response.getWriter().write(errorObj.toString());
    }
}
