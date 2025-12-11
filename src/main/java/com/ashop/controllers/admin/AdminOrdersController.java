package com.ashop.controllers.admin;

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

@WebServlet({"/admin/orders","/admin/orders/view","/admin/orders/updateStatus"})
public class AdminOrdersController extends HttpServlet {
    private final OrderService orderService = new OrderServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null /*|| !user.isAdmin()*/) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String servletPath = request.getServletPath();
        if ("/admin/orders/view".equals(servletPath)) {
            String id = request.getParameter("id");
            if (id != null) {
                try {
                    Order o = orderService.findById(Integer.parseInt(id));
                    request.setAttribute("order", o);
                    request.getRequestDispatcher("/views/admin/order-detail.jsp").forward(request, response);
                    return;
                } catch (NumberFormatException e) { }
            }
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        // list all orders
        List<Order> orders = orderService.findAll();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/views/admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null /*|| !user.isAdmin()*/) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String servletPath = request.getServletPath();
        if ("/admin/orders/updateStatus".equals(servletPath)) {
            String id = request.getParameter("id");
            String status = request.getParameter("status");
            if (id != null && status != null) {
                try {
                    Order o = orderService.findById(Integer.parseInt(id));
                    if (o != null) {
                        o.setStatus(status);
                        orderService.updateOrder(o);
                    }
                } catch (NumberFormatException e) {}
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
