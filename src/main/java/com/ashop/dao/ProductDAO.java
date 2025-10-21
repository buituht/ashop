package com.ashop.dao;

import com.ashop.entity.Product;
import java.util.List;

public interface ProductDAO {
    Product findById(int id);
    List<Product> findRange(int offset, int limit);
    List<Product> findAll();
    long countAll();
    Product create(Product product);
    Product update(Product product);
    void remove(Product product);
}