package com.ashop.services;

import com.ashop.entity.Product;
import java.util.List;

public interface ProductService {
    List<Product> findWithPagination(int page, int limit);
    long countAll();
    Product findById(int id);
    Product saveOrUpdate(Product product);
    boolean delete(int id);
}