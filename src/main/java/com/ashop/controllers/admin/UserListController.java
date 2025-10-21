package com.ashop.controllers.admin;

import com.ashop.entity.User;
import com.ashop.services.UserService;
import com.ashop.services.impl.UserServiceImpl; 

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class UserListController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Khởi tạo Service
    private final UserService userService = new UserServiceImpl(); 

    // Thiết lập phân trang mặc định
    private static final int ITEMS_PER_PAGE = 10;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Thiết lập encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Lấy thông tin phân trang
            int currentPage = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            // 2. Lấy tổng số người dùng và tính tổng số trang
            long totalUsers = userService.countAll();
            int totalPages = (int) Math.ceil((double) totalUsers / ITEMS_PER_PAGE);

            // 3. Lấy danh sách người dùng cho trang hiện tại
            List<User> users = userService.findWithPagination(currentPage, ITEMS_PER_PAGE);

            // 4. Đặt thuộc tính vào request scope
            request.setAttribute("users", users);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalUsers);
            
            // 5. Chuyển tiếp tới trang JSP
            request.getRequestDispatcher("/views/admin/user-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi (ví dụ: chuyển hướng đến trang lỗi)
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải danh sách người dùng.");
        }
    }
}