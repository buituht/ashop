package com.ashop.controllers;

import com.ashop.entity.User;
import com.ashop.entity.Order;
import com.ashop.entity.Cart;
import com.ashop.services.OrderService;
import com.ashop.services.impl.OrderServiceImpl;
import com.ashop.services.CartService;
import com.ashop.services.impl.CartServiceImpl;
import com.ashop.utils.EmailUtil;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;
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
        // Lưu order và lấy lại đối tượng đã persist (để lấy orderId nếu cần)
        Order savedOrder = orderService.createOrder(order);

        // Gửi email xác nhận đơn hàng cho người mua (nếu email hợp lệ)
        try {
            String to = user.getEmail();
            if (to != null && !to.isEmpty()) {
                NumberFormat currency = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                String subject = "Xác nhận đơn hàng #" + (savedOrder.getOrderId() != null ? savedOrder.getOrderId() : "") + " - " + request.getServerName();
                StringBuilder body = new StringBuilder();
                body.append("Xin chào ").append(user.getFullName() != null ? user.getFullName() : user.getUsername()).append(",\n\n");
                body.append("Cảm ơn bạn đã đặt hàng. Dưới đây là thông tin đơn hàng của bạn:\n\n");
                body.append("Mã đơn hàng: ").append(savedOrder.getOrderId() != null ? savedOrder.getOrderId() : "(chưa có)").append("\n");
                body.append("Người nhận: ").append(receiverName != null ? receiverName : "(không có)").append("\n");
                body.append("Địa chỉ giao hàng: ").append(shippingAddress != null ? shippingAddress : "(không có)").append("\n");
                body.append("Số điện thoại: ").append(phone != null ? phone : "(không có)").append("\n");
                body.append("Phương thức thanh toán: ").append(paymentMethod != null ? paymentMethod : "(không có)").append("\n\n");

                body.append("Chi tiết sản phẩm:\n");
                for (Cart item : cartItems) {
                    // Product entity uses getProductName()
                    String prodName = item.getProduct() != null ? item.getProduct().getProductName() : "(sản phẩm)";
                    BigDecimal price = item.getProduct() != null && item.getProduct().getSalePrice() != null && item.getProduct().getSalePrice().doubleValue() > 0 ? item.getProduct().getSalePrice() : item.getProduct().getPrice();
                    BigDecimal sub = price.multiply(BigDecimal.valueOf(item.getQuantity()));
                    body.append(" - ").append(prodName).append(" x").append(item.getQuantity()).append(" : ").append(currency.format(price)).append(" = ").append(currency.format(sub)).append("\n");
                }
                body.append("\nTổng thanh toán: ").append(currency.format(totalAmount)).append("\n\n");
                body.append("Nếu bạn có bất kỳ câu hỏi nào, vui lòng trả lời email này hoặc liên hệ bộ phận hỗ trợ.\n\n");
                body.append("Trân trọng,\n");
                body.append("Nhóm 3");

                try {
                    EmailUtil.sendEmail(to, subject, body.toString());
                } catch (MessagingException me) {
                    // Không để lỗi gửi email ngăn luồng đặt hàng; chỉ log để debug                    me.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Xóa giỏ hàng sau khi đặt hàng
        for (Cart item : cartItems) {
            cartService.removeFromCart(item);
        }
        response.sendRedirect(request.getContextPath() + "/orders?success=1");
    }
}