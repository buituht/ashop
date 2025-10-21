package com.ashop.controllers.admin;

import com.ashop.entity.User;
import com.ashop.services.UserService;
import com.ashop.services.impl.UserServiceImpl; // Giả định

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/admin/user/add", "/admin/user/edit"})
public class UserFormController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final UserService userService = new UserServiceImpl();

    /**
     * Xử lý yêu cầu GET: Hiển thị form thêm mới hoặc form chỉnh sửa.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String servletPath = request.getServletPath();
        
        // --- Logic Chỉnh sửa ---
        if (servletPath.equals("/admin/user/edit")) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    int userId = Integer.parseInt(idParam);
                    User user = userService.findById(userId);
                    
                    if (user != null) {
                        request.setAttribute("user", user);
                    } else {
                        // Không tìm thấy user
                        request.getSession().setAttribute("message", "Lỗi: Không tìm thấy người dùng có ID: " + userId);
                        response.sendRedirect(request.getContextPath() + "/admin/users");
                        return;
                    }
                } catch (NumberFormatException e) {
                    // ID không hợp lệ
                    request.getSession().setAttribute("message", "Lỗi: ID người dùng không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    return;
                }
            }
        }
        
        // --- Hiển thị Form ---
        request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request, response);
    }

    /**
     * Xử lý yêu cầu POST: Lưu người dùng mới hoặc cập nhật người dùng hiện tại.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String servletPath = request.getServletPath();
        User user;
        String message;

        try {
            // 1. Lấy thông tin từ form
            String username = request.getParameter("username");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String role = request.getParameter("role");
            String statusParam = request.getParameter("status");

            // Xử lý Checkbox Status
            boolean status = "on".equalsIgnoreCase(statusParam) || "true".equalsIgnoreCase(statusParam);


            // --- Logic CẬP NHẬT (EDIT) ---
            if (servletPath.equals("/admin/user/edit")) {
                String idParam = request.getParameter("userId");
                int userId = Integer.parseInt(idParam);
                
                // Lấy user cũ để giữ lại các trường không sửa đổi (như password, created_at)
                user = userService.findById(userId);
                if (user == null) {
                    request.getSession().setAttribute("message", "Lỗi: Cập nhật thất bại. Không tìm thấy người dùng.");
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    return;
                }

                // Cập nhật các trường mới
                user.setFullName(fullName);
                user.setEmail(email);
                user.setPhone(phone);
                user.setAddress(address);
                user.setRole(role);
                user.setStatus(status);

                message = "Cập nhật người dùng **" + username + "** thành công!";

            // --- Logic THÊM MỚI (ADD) ---
            } else {
                String password = request.getParameter("password");
                if (password == null || password.isEmpty()) {
                    request.setAttribute("user", new User(null, username, fullName, email, phone, address, role, status)); // Đưa lại dữ liệu vào form
                    request.setAttribute("error", "Vui lòng nhập mật khẩu.");
                    request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request, response);
                    return;
                }

                // Tạo đối tượng User mới
                user = new User(username, password, fullName, email, phone, address);
                user.setRole(role);
                user.setStatus(status);
                
                message = "Thêm mới người dùng **" + username + "** thành công!";
            }
            
            // 2. Lưu/Cập nhật qua Service
            userService.saveOrUpdate(user);

            // 3. Chuyển hướng về trang danh sách
            request.getSession().setAttribute("message", message);
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi (ví dụ: duplicate username/email, lỗi DB...)
            request.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
            // Đặt lại dữ liệu vào request để người dùng không phải nhập lại
            request.setAttribute("user", new User(null, request.getParameter("username"), request.getParameter("fullName"), 
                                                 request.getParameter("email"), request.getParameter("phone"), 
                                                 request.getParameter("address"), request.getParameter("role"), 
                                                 "on".equalsIgnoreCase(request.getParameter("status"))));
            
            request.getRequestDispatcher("/views/admin/user-form.jsp").forward(request, response);
        }
    }
}