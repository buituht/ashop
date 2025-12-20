package com.ashop.controllers.admin;

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

@WebServlet("/admin/user/delete")
public class UserActionController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserService userService = new UserServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // For safety, redirect GET to list
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User current = (User) session.getAttribute("currentUser");
        if (current == null || !"ADMIN".equals(current.getRole())) {
            // not authorized
            session.setAttribute("message", "Bạn không có quyền thực hiện hành động này.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("message", "Thiếu tham số id.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("message", "ID người dùng không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        // Prevent admin deleting themselves
        if (current.getUserId() != null && current.getUserId().intValue() == userId) {
            session.setAttribute("message", "Bạn không thể xóa chính mình.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        User target = userService.findById(userId);
        if (target == null) {
            session.setAttribute("message", "Người dùng không tồn tại.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        // Do not allow deleting other admins
        if ("ADMIN".equals(target.getRole())) {
            session.setAttribute("message", "Không thể xóa tài khoản ADMIN.");
            resp.sendRedirect(req.getContextPath() + "/admin/users");
            return;
        }

        try {
            boolean deleted = userService.deleteIfNoOrders(userId);
            if (deleted) {
                session.setAttribute("message", "Đã xóa người dùng (không có đơn hàng).");
            } else {
                // cannot delete because has orders -> lock instead
                boolean locked = userService.lockUser(userId);
                if (locked) {
                    session.setAttribute("message", "Tài khoản có đơn hàng, đã khóa thay vì xóa.");
                } else {
                    session.setAttribute("message", "Không thể xóa hoặc khóa tài khoản.");
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            session.setAttribute("message", "Đã xảy ra lỗi khi xử lý yêu cầu.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
