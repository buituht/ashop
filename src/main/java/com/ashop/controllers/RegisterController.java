package com.ashop.controllers;

import com.ashop.entity.User;
import com.ashop.services.UserService;
import com.ashop.services.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final UserService userService = new UserServiceImpl();

    /**
     * Xử lý GET: Hiển thị form đăng ký.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        // Kiểm tra xem người dùng đã đăng nhập chưa (Nếu có, chuyển hướng)
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Chuyển tiếp đến trang JSP đăng ký
      
        req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
    }

    /**
     * Xử lý POST: Nhận dữ liệu form và tạo người dùng mới.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        // 1. Lấy dữ liệu từ form
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address"); 
        
        // Mặc định cho các trường ẩn/mặc định
        String role = "USER";
        Boolean status = true;
        String avatar = "default_avatar.png"; 

        HttpSession session = req.getSession();
        String forwardUrl = "/views/register.jsp";

        try {
            // 2. Kiểm tra nghiệp vụ: Email và Username tồn tại
            if (userService.checkExistEmail(email)) {
                req.setAttribute("alert", "Email này đã được đăng ký!");
                req.getRequestDispatcher(forwardUrl).forward(req, resp);
                return;
            }
            
            if (userService.checkExistUsername(username)) {
                req.setAttribute("alert", "Tên đăng nhập này đã tồn tại!");
                req.getRequestDispatcher(forwardUrl).forward(req, resp);
                return;
            }
            
            // 3. Thực hiện Đăng ký qua Service
            // UserService.register() sẽ đảm nhiệm việc hash mật khẩu và lưu vào DB
            boolean isSuccess = userService.register(username, password, fullName, email, phone, address, role, status, avatar);
            
            if (isSuccess) {
                // *** THÀNH CÔNG: LƯU THÔNG BÁO VÀO SESSION VÀ CHUYỂN HƯỚNG (PRG) ***
                session.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            } else {
                // Lỗi DB/Hệ thống
                req.setAttribute("alert", "Đăng ký thất bại do lỗi hệ thống. Vui lòng thử lại.");
                req.getRequestDispatcher(forwardUrl).forward(req, resp);
                return;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("alert", "Lỗi kỹ thuật: Không thể hoàn tất đăng ký.");
            req.getRequestDispatcher(forwardUrl).forward(req, resp);
        }
    }
}