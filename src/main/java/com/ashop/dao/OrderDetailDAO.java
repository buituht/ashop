package com.ashop.dao;

import com.ashop.entity.OrderDetail;
import com.ashop.entity.Order;
import java.util.List;

public interface OrderDetailDAO {
    OrderDetail findById(int id);
    List<OrderDetail> findByOrder(Order order);
    OrderDetail create(OrderDetail orderDetail);
    OrderDetail update(OrderDetail orderDetail);
    void remove(OrderDetail orderDetail);
}
