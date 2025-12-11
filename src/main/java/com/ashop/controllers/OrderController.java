package com.ashop.controllers;

import com.ashop.entity.User;
import com.ashop.entity.Order;
import com.ashop.entity.Cart;
import com.ashop.services.OrderService;
import com.ashop.services.impl.OrderServiceImpl;
import com.ashop.services.CartService;
import com.ashop.services.impl.CartServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet({"/checkout"})
public class OrderController extends HttpServlet {
    private final OrderService orderService = new OrderServiceImpl();
    private final CartService cartService = new CartServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        List<Cart> cartItems = cartService.findByUser(user);
        // Tính sẵn price và subtotal cho từng item và lưu vào map thay vì nhiều request attributes
        Map<Integer, java.math.BigDecimal> priceMap = new HashMap<>();
        Map<Integer, java.math.BigDecimal> subtotalMap = new HashMap<>();
        for (Cart item : cartItems) {
            if (item.getCartId() != null) {
                java.math.BigDecimal price = (item.getProduct().getSalePrice() != null && item.getProduct().getSalePrice().doubleValue() > 0)
                    ? item.getProduct().getSalePrice() : item.getProduct().getPrice();
                java.math.BigDecimal subtotal = price.multiply(java.math.BigDecimal.valueOf(item.getQuantity()));
                priceMap.put(item.getCartId(), price);
                subtotalMap.put(item.getCartId(), subtotal);
            }
        }
        request.setAttribute("priceMap", priceMap);
        request.setAttribute("subtotalMap", subtotalMap);
        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/views/checkout.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // Lấy thông tin đặt hàng
        String shippingAddress = request.getParameter("shippingAddress");
        String phone = request.getParameter("phone");
        String receiverName = request.getParameter("receiverName");
        String paymentMethod = request.getParameter("paymentMethod");
        String note = request.getParameter("note");
        List<Cart> cartItems = cartService.findByUser(user);
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Cart item : cartItems) {
            BigDecimal price = item.getProduct().getSalePrice() != null && item.getProduct().getSalePrice().doubleValue() > 0 ? item.getProduct().getSalePrice() : item.getProduct().getPrice();
            totalAmount = totalAmount.add(price.multiply(BigDecimal.valueOf(item.getQuantity())));
        }
        Order order = new Order();
        order.setUser(user);
        order.setShippingAddress(shippingAddress);
        order.setPhone(phone);
        order.setReceiverName(receiverName);
        order.setPaymentMethod(paymentMethod);
        order.setNote(note);
        order.setTotalAmount(totalAmount);
        orderService.createOrder(order);
        // Xóa giỏ hàng sau khi đặt hàng
        for (Cart item : cartItems) {
            cartService.removeFromCart(item);
        }
        response.sendRedirect(request.getContextPath() + "/orders?success=1");
    }
}