package com.ashop.controllers;

import com.ashop.entity.Order;
import com.ashop.entity.User;
import com.ashop.services.OrderService;
import com.ashop.services.impl.OrderServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/orders", "/orders/view", "/orders/cancel"})
public class OrdersController extends HttpServlet {
    private final OrderService orderService = new OrderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String servletPath = request.getServletPath();
        // View a single order
        if ("/orders/view".equals(servletPath)) {
            String id = request.getParameter("id");
            if (id != null) {
                try {
                    Order o = orderService.findById(Integer.parseInt(id));
                    // Ensure the logged in user owns this order
                    if (o != null && o.getUser() != null && o.getUser().getUserId().equals(user.getUserId())) {
                        request.setAttribute("order", o);
                        request.getRequestDispatcher("/views/order-detail.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) { }
            }
            // if invalid, redirect to list
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        // Default: list orders for the current user
        List<Order> orders = orderService.findByUser(user);
        request.setAttribute("orders", orders);

        // Map optional message params into a friendly message
        String success = request.getParameter("success");
        String msg = request.getParameter("msg");
        if ("1".equals(success)) {
            request.setAttribute("message", "Đặt hàng thành công!");
        } else if ("cancelled".equals(msg)) {
            request.setAttribute("message", "Đơn hàng đã được hủy.");
        } else if (msg != null && !msg.isEmpty()) {
            request.setAttribute("message", msg);
        }

        request.getRequestDispatcher("/views/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String servletPath = request.getServletPath();
        if ("/orders/cancel".equals(servletPath)) {
            String id = request.getParameter("id");
            if (id != null) {
                try {
                    Order o = orderService.findById(Integer.parseInt(id));
                    if (o != null && o.getUser() != null && o.getUser().getUserId().equals(user.getUserId())) {
                        // allow cancellation only when still pending
                        if (o.getStatus() != null && o.getStatus().equalsIgnoreCase("PENDING")) {
                            o.setStatus("CANCELLED");
                            orderService.updateOrder(o);
                            response.sendRedirect(request.getContextPath() + "/orders?msg=cancelled");
                            return;
                        } else {
                            response.sendRedirect(request.getContextPath() + "/orders?msg=Không thể hủy đơn hàng này");
                            return;
                        }
                    }
                } catch (NumberFormatException e) { }
            }
        }
        response.sendRedirect(request.getContextPath() + "/orders");
    }
}