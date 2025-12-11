package com.ashop.controllers;

import com.ashop.entity.User;
import com.ashop.entity.Order;
import com.ashop.services.UserService;
import com.ashop.services.OrderService;
import com.ashop.services.impl.UserServiceImpl;
import com.ashop.services.impl.OrderServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet({"/account","/account/edit","/account/changePassword"})
public class AccountController extends HttpServlet {
    private final UserService userService = new UserServiceImpl();
    private final OrderService orderService = new OrderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User sessionUser = (User) request.getSession().getAttribute("currentUser");
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String servletPath = request.getServletPath();
        if ("/account/edit".equals(servletPath)) {
            // load fresh user from DB
            User user = userService.findById(sessionUser.getUserId());
            request.setAttribute("user", user);
            request.getRequestDispatcher("/views/account-edit.jsp").forward(request, response);
            return;
        }

        // If someone explicitly requests /account/changePassword, redirect to account page with security tab
        if ("/account/changePassword".equals(servletPath)) {
            response.sendRedirect(request.getContextPath() + "/account#security");
            return;
        }

        // default: account view
        User user = userService.findById(sessionUser.getUserId());

        // --- pagination for user's orders ---
        List<Order> allOrders = orderService.findByUser(user);
        if (allOrders == null) allOrders = new ArrayList<>();
        String pageParam = request.getParameter("page");
        String sizeParam = request.getParameter("size");
        int page = 1;
        int size = 5; // default page size
        try { if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException ignored) {}
        try { if (sizeParam != null) size = Math.max(1, Integer.parseInt(sizeParam)); } catch (NumberFormatException ignored) {}

        int total = allOrders.size();
        int totalPages = (int) Math.max(1, Math.ceil(total / (double) size));
        if (page > totalPages) page = totalPages;
        int fromIndex = Math.max(0, (page - 1) * size);
        int toIndex = Math.min(fromIndex + size, total);
        List<Order> pageList = new ArrayList<>();
        if (fromIndex < toIndex) {
            pageList = allOrders.subList(fromIndex, toIndex);
        }

        request.setAttribute("user", user);
        request.setAttribute("ordersPage", pageList);
        request.setAttribute("ordersPageNumber", page);
        request.setAttribute("ordersTotalPages", totalPages);
        request.setAttribute("ordersPageSize", size);
        request.setAttribute("ordersTotal", total);

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("message", msg);
        request.getRequestDispatcher("/views/account.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User sessionUser = (User) request.getSession().getAttribute("currentUser");
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String servletPath = request.getServletPath();
        if ("/account/edit".equals(servletPath)) {
            try {
                User user = userService.findById(sessionUser.getUserId());
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                if (fullName != null) user.setFullName(fullName.trim());
                if (email != null) user.setEmail(email.trim());
                if (phone != null) user.setPhone(phone.trim());
                if (address != null) user.setAddress(address.trim());
                userService.saveOrUpdate(user);
                // update session user (hide password)
                user.setPassword(null);
                request.getSession().setAttribute("currentUser", user);
                response.sendRedirect(request.getContextPath() + "/account?msg=Cập nhật thành công");
                return;
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/account?msg=Đã có lỗi khi cập nhật");
                return;
            }
        }

        if ("/account/changePassword".equals(servletPath)) {
            String current = request.getParameter("currentPassword");
            String nw = request.getParameter("newPassword");
            String confirm = request.getParameter("confirmPassword");
            String base = request.getContextPath() + "/account"; // base redirect
            if (current == null || nw == null || confirm == null) {
                response.sendRedirect(base + "?msg=Vui lòng điền đầy đủ#security");
                return;
            }
            if (!nw.equals(confirm)) {
                response.sendRedirect(base + "?msg=Mật khẩu mới không khớp#security");
                return;
            }
            User user = userService.findById(sessionUser.getUserId());
            // DB may store hashed password; check with BCrypt and fallback to plain-text for legacy
            String stored = user.getPassword();
            boolean ok = false;
            try {
                if (stored != null && (stored.startsWith("$2a$") || stored.startsWith("$2b$") || stored.startsWith("$2y$"))) {
                    ok = BCrypt.checkpw(current, stored);
                } else {
                    ok = current.equals(stored);
                }
            } catch (Exception ex) {
                ok = false;
            }

            if (!ok) {
                response.sendRedirect(base + "?msg=Mật khẩu hiện tại không chính xác#security");
                return;
            }
            // Hash new password before saving
            String hashed = BCrypt.hashpw(nw, BCrypt.gensalt());
            user.setPassword(hashed);
            userService.saveOrUpdate(user);
            // clear password in session
            user.setPassword(null);
            request.getSession().setAttribute("currentUser", user);
            response.sendRedirect(base + "?msg=Đổi mật khẩu thành công#security");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/account");
    }
}