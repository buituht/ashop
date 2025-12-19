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

    // Tìm các sản phẩm đang bật (status = true) theo phạm vi để dùng cho trang công khai
    List<Product> findActiveRange(int offset, int limit);
    // Đếm số sản phẩm đang bật
    long countActive();

    // Tìm các sản phẩm đang có giá giảm (salePrice > 0) và đang bật, theo phạm vi
    List<Product> findDiscountedActiveRange(int offset, int limit);
    // Đếm số sản phẩm đang giảm giá và đang bật
    long countDiscountedActive();
}