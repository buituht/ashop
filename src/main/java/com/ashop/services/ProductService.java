package com.ashop.services;

import com.ashop.entity.Product;
import java.util.List;

public interface ProductService {
    List<Product> findWithPagination(int page, int limit);
    long countAll();
    Product findById(int id);
    Product saveOrUpdate(Product product);
    boolean delete(int id);

    // Dành cho trang công khai: chỉ lấy sản phẩm active
    List<Product> findActiveWithPagination(int page, int limit);
    long countActive();

    // Dành cho trang khuyến mãi: lấy sản phẩm có salePrice > 0 và đang active
    List<Product> findDiscountedActiveWithPagination(int page, int limit);
    long countDiscountedActive();

    // Lọc sản phẩm theo danh mục (category)
    List<Product> findByCategoryWithPagination(int categoryId, int page, int limit);
    long countByCategory(int categoryId);

    // Sắp xếp sản phẩm active
    List<Product> findActiveSorted(int page, int limit, String sortBy);
    
    // Sắp xếp sản phẩm theo danh mục
    List<Product> findByCategorySorted(int categoryId, int page, int limit, String sortBy);
}