package com.ashop.services.impl;

import com.ashop.dao.OrderDetailDAO;
import com.ashop.dao.impl.OrderDetailDAOImpl;
import com.ashop.entity.OrderDetail;
import com.ashop.entity.Order;
import com.ashop.services.OrderDetailService;
import java.util.List;

public class OrderDetailServiceImpl implements OrderDetailService {
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAOImpl();
    @Override
    public OrderDetail findById(int id) { return orderDetailDAO.findById(id); }
    @Override
    public List<OrderDetail> findByOrder(Order order) { return orderDetailDAO.findByOrder(order); }
    @Override
    public OrderDetail createOrderDetail(OrderDetail orderDetail) { return orderDetailDAO.create(orderDetail); }
    @Override
    public OrderDetail updateOrderDetail(OrderDetail orderDetail) { return orderDetailDAO.update(orderDetail); }
    @Override
    public void removeOrderDetail(OrderDetail orderDetail) { orderDetailDAO.remove(orderDetail); }
}
