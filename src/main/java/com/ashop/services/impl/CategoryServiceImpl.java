package com.ashop.services.impl;

import com.ashop.dao.CategoryDAO;
import com.ashop.dao.impl.CategoryDAOImpl;
import com.ashop.entity.Category;
import com.ashop.services.CategoryService;
import java.util.List;

public class CategoryServiceImpl implements CategoryService {

    private final CategoryDAO categoryDAO = new CategoryDAOImpl(); 

    @Override
    public List<Category> findWithPagination(int page, int limit) {
        int offset = (page - 1) * limit;
        return categoryDAO.findRange(offset, limit);
    }

    @Override
    public List<Category> findAll() {
        return categoryDAO.findAll();
    }

    @Override
    public List<Category> findActive() {
        return categoryDAO.findActive();
    }
    
    @Override
    public long countAll() {
        return categoryDAO.countAll();
    }

    @Override
    public Category findById(int id) {
        return categoryDAO.findById(id);
    }

    @Override
    public Category saveOrUpdate(Category category) {
        if (category.getCategoryId() == null) {
            return categoryDAO.create(category);
        } else {
            return categoryDAO.update(category);
        }
    }

    @Override
    public boolean delete(int id) {
        // Áp dụng logic thay đổi trạng thái (soft delete)
        Category category = categoryDAO.findById(id);
        if (category != null) {
            category.setStatus(false); 
            categoryDAO.update(category);
            return true;
        }
        return false;
    }
}