package com.ashop.dao;

import com.ashop.entity.Category;
import java.util.List;

public interface CategoryDAO {
    Category findById(int id);
    List<Category> findRange(int offset, int limit);
    List<Category> findAll();
    long countAll();
    Category create(Category category);
    Category update(Category category);
    void remove(Category category);
    List<Category> findActive();
}