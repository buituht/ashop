package com.ashop.dao;

import java.time.LocalDateTime;
import java.util.List;

public interface StatisticsDAO {
    List<Object[]> getInventory();
    List<Object[]> getSalesByProduct(LocalDateTime start, LocalDateTime end);
    List<Object[]> getSalesByCustomer(LocalDateTime start, LocalDateTime end);
    // count products for debug
    long countProducts();
}