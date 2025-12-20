package com.ashop.controllers;

import com.ashop.entity.User;
import com.ashop.services.UserService;
import com.ashop.services.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Kiểm tra nếu đã có session hợp lệ hoặc cookie "username"
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            // Đã đăng nhập -> Chuyển hướng đến trang chính
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        // 2. Nếu không, hiển thị trang đăng nhập
        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        
        // 1. Lấy dữ liệu từ form
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String rememberMe = req.getParameter("rememberMe"); // checkbox: "on" nếu được chọn

        String errorMsg = null;
        String forwardUrl = "/views/login.jsp";

        try {
            // 2. Gọi service để lấy user (nếu không tồn tại sẽ trả về null)
            User existing = userService.findByUsername(username);
            if (existing != null && Boolean.FALSE.equals(existing.getEmailVerified())) {
                errorMsg = "Tài khoản chưa được xác thực email. Vui lòng kiểm tra email và bấm vào liên kết xác thực.";
                req.setAttribute("error", errorMsg);
                req.getRequestDispatcher(forwardUrl).forward(req, resp);
                return;
            }

            // 3. Xác thực người dùng qua Service
            User user = userService.login(username, password);

            if (user != null) {
                // 4. Xử lý ĐĂNG NHẬP THÀNH CÔNG
                HttpSession session = req.getSession(true);
                session.setAttribute("currentUser", user); // Lưu đối tượng User vào session
                session.setAttribute("role", user.getRole()); // Lưu vai trò (ADMIN/USER)

                // 5. Xử lý "Nhớ mật khẩu" (Cookie)
                if ("on".equals(rememberMe)) {
                    Cookie userCookie = new Cookie("username", username);
                    userCookie.setMaxAge(60 * 60 * 24 * 7); // Cookie tồn tại 7 ngày
                    userCookie.setPath(req.getContextPath());
                    // security flags
                    userCookie.setHttpOnly(true);
                    if (req.isSecure()) {
                        userCookie.setSecure(true);
                    }
                    resp.addCookie(userCookie);
                } else {
                    // Xóa cookie nếu nó tồn tại và người dùng bỏ chọn "Nhớ mật khẩu"
                    Cookie userCookie = new Cookie("username", "");
                    userCookie.setMaxAge(0);
                    userCookie.setPath(req.getContextPath());
                    userCookie.setHttpOnly(true);
                    if (req.isSecure()) {
                        userCookie.setSecure(true);
                    }
                    resp.addCookie(userCookie);
                }

                // Chuyển hướng thành công: Nếu là ADMIN, chuyển đến trang Admin
                if ("ADMIN".equals(user.getRole())) {
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/");
                }
                return;
                
            } else {
                // 6. Xử lý ĐĂNG NHẬP THẤT BẠI
                errorMsg = "Tên đăng nhập hoặc mật khẩu không chính xác.";
            }

        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = "Lỗi hệ thống: Không thể xác thực đăng nhập.";
        }

        // Quay lại trang đăng nhập với thông báo lỗi
        req.setAttribute("error", errorMsg);
        req.getRequestDispatcher(forwardUrl).forward(req, resp);
    }
}