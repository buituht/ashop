package com.ashop.controllers;

import com.ashop.entity.Product;
import com.ashop.entity.User;
import com.ashop.entity.Cart;
import com.ashop.services.CartService;
import com.ashop.services.impl.CartServiceImpl;
import com.ashop.services.ProductService;
import com.ashop.services.impl.ProductServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/cart", "/cart/add", "/cart/remove"})
public class CartController extends HttpServlet {
    private final CartService cartService = new CartServiceImpl();
    private final ProductService productService = new ProductServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        List<Cart> cartItems = cartService.findByUser(user);
        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("/views/cart.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String servletPath = request.getServletPath();
        if ("/cart/add".equals(servletPath)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String quantityParam = request.getParameter("quantity");
            int quantity = 1;
            if (quantityParam != null && !quantityParam.isEmpty()) {
                try {
                    quantity = Integer.parseInt(quantityParam);
                } catch (NumberFormatException e) {
                    quantity = 1;
                }
            }
            Product product = productService.findById(productId);
            if (product != null) {
                cartService.addToCart(user, product, quantity);
            }
            response.sendRedirect(request.getContextPath() + "/cart");
        } else if ("/cart/remove".equals(servletPath)) {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            Cart cart = cartService.findById(cartId);
            if (cart != null && cart.getUser().getUserId().equals(user.getUserId())) {
                cartService.removeFromCart(cart);
            }
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}