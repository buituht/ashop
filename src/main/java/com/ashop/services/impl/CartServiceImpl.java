package com.ashop.services.impl;

import com.ashop.dao.CartDAO;
import com.ashop.dao.impl.CartDAOImpl;
import com.ashop.entity.Cart;
import com.ashop.entity.User;
import com.ashop.entity.Product;
import com.ashop.services.CartService;
import java.util.List;

public class CartServiceImpl implements CartService {
    private final CartDAO cartDAO = new CartDAOImpl();
    @Override
    public Cart findById(int id) { return cartDAO.findById(id); }
    @Override
    public List<Cart> findByUser(User user) { return cartDAO.findByUser(user); }
    @Override
    public Cart findByUserAndProduct(User user, Product product) { return cartDAO.findByUserAndProduct(user, product); }
    @Override
    public Cart addToCart(User user, Product product, int quantity) {
        Cart cart = cartDAO.findByUserAndProduct(user, product);
        if (cart == null) {
            cart = new Cart();
            cart.setUser(user);
            cart.setProduct(product);
            cart.setQuantity(quantity);
            return cartDAO.create(cart);
        } else {
            cart.setQuantity(cart.getQuantity() + quantity);
            return cartDAO.update(cart);
        }
    }
    @Override
    public Cart updateCart(Cart cart) { return cartDAO.update(cart); }
    @Override
    public void removeFromCart(Cart cart) { cartDAO.remove(cart); }
}
