package com.ashop.services;

import com.ashop.entity.OrderDetail;
import com.ashop.entity.Order;
import java.util.List;

public interface OrderDetailService {
    OrderDetail findById(int id);
    List<OrderDetail> findByOrder(Order order);
    OrderDetail createOrderDetail(OrderDetail orderDetail);
    OrderDetail updateOrderDetail(OrderDetail orderDetail);
    void removeOrderDetail(OrderDetail orderDetail);
}
