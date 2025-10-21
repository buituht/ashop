package com.ashop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        // 1. Invalidate the HTTP Session
        HttpSession session = req.getSession(false);
        if (session != null) {
            // Xóa tất cả các thuộc tính của session và hủy session
            session.invalidate(); 
        }

        // 2. Xóa Cookie "username" (Nếu tùy chọn "Nhớ mật khẩu" được sử dụng)
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("username")) {
                    cookie.setMaxAge(0); // Đặt thời gian tồn tại về 0
                    cookie.setPath(req.getContextPath());
                    resp.addCookie(cookie);
                    break;
                }
            }
        }
        
        // 3. Chuyển hướng người dùng về trang đăng nhập hoặc trang chủ
        // Thường chuyển về trang đăng nhập và gửi một thông báo (tùy chọn)
        resp.sendRedirect(req.getContextPath() + "/login?msg=logged_out");
    }
    
    // Yêu cầu logout chỉ cần xử lý bằng GET, không cần doPost()
}