package com.ashop.services;

import com.ashop.entity.Cart;
import com.ashop.entity.User;
import com.ashop.entity.Product;
import java.util.List;

public interface CartService {
    Cart findById(int id);
    List<Cart> findByUser(User user);
    Cart findByUserAndProduct(User user, Product product);
    Cart addToCart(User user, Product product, int quantity);
    Cart updateCart(Cart cart);
    void removeFromCart(Cart cart);
}
