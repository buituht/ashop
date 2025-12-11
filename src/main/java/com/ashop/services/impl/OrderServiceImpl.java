package com.ashop.services.impl;

import com.ashop.dao.OrderDAO;
import com.ashop.dao.impl.OrderDAOImpl;
import com.ashop.entity.Order;
import com.ashop.entity.User;
import com.ashop.services.OrderService;
import java.util.List;

public class OrderServiceImpl implements OrderService {
    private final OrderDAO orderDAO = new OrderDAOImpl();
    @Override
    public Order findById(int id) { return orderDAO.findById(id); }
    @Override
    public List<Order> findByUser(User user) { return orderDAO.findByUser(user); }
    @Override
    public List<Order> findAll() { return orderDAO.findAll(); }
    @Override
    public Order createOrder(Order order) { return orderDAO.create(order); }
    @Override
    public Order updateOrder(Order order) { return orderDAO.update(order); }
    @Override
    public void removeOrder(Order order) { orderDAO.remove(order); }
}