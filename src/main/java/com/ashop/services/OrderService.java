package com.ashop.services;

import com.ashop.entity.Order;
import com.ashop.entity.User;
import java.util.List;

public interface OrderService {
    Order findById(int id);
    List<Order> findByUser(User user);
    List<Order> findAll();
    Order createOrder(Order order);
    Order updateOrder(Order order);
    void removeOrder(Order order);
}