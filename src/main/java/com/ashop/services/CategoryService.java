package com.ashop.services;

import com.ashop.entity.Category;
import java.util.List;

public interface CategoryService {
    List<Category> findWithPagination(int page, int limit);
    long countAll();
    Category findById(int id);
    Category saveOrUpdate(Category category);
    boolean delete(int id);
    List<Category> findAll(); // Dùng cho danh sách đổ vào các form khác
}