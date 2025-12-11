package com.ashop.dao;

import com.ashop.entity.Order;
import com.ashop.entity.User;
import java.util.List;

public interface OrderDAO {
    Order findById(int id);
    List<Order> findByUser(User user);
    List<Order> findAll();
    Order create(Order order);
    Order update(Order order);
    void remove(Order order);
}