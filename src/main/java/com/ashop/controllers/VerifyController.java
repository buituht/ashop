package com.ashop.controllers;

import com.ashop.services.UserService;
import com.ashop.services.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/verify")
public class VerifyController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.isEmpty()) {
            req.setAttribute("alert", "Token không hợp lệ.");
            req.getRequestDispatcher("/views/message.jsp").forward(req, resp);
            return;
        }

        boolean ok = userService.verifyToken(token);
        if (ok) {
            req.setAttribute("successMessage", "Xác thực email thành công. Bạn có thể đăng nhập ngay bây giờ.");
            req.getRequestDispatcher("/login").forward(req, resp);
        } else {
            req.setAttribute("alert", "Liên kết xác thực không hợp lệ hoặc đã hết hạn.");
            req.getRequestDispatcher("/views/message.jsp").forward(req, resp);
        }
    }
}
