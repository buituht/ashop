package com.ashop.dao;

import com.ashop.entity.Cart;
import com.ashop.entity.User;
import com.ashop.entity.Product;
import java.util.List;

public interface CartDAO {
    Cart findById(int id);
    List<Cart> findByUser(User user);
    Cart findByUserAndProduct(User user, Product product);
    Cart create(Cart cart);
    Cart update(Cart cart);
    void remove(Cart cart);
}
