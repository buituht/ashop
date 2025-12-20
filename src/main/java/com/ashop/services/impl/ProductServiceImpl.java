package com.ashop.services.impl;

import com.ashop.dao.ProductDAO;
import com.ashop.dao.impl.ProductDAOImpl;
import com.ashop.entity.Product;
import com.ashop.services.ProductService;
import java.util.List;

public class ProductServiceImpl implements ProductService {

    private final ProductDAO productDAO = new ProductDAOImpl(); 

    @Override
    public List<Product> findWithPagination(int page, int limit) {
        int offset = (page - 1) * limit;
        return productDAO.findRange(offset, limit);
    }

    @Override
    public long countAll() {
        return productDAO.countAll();
    }

    @Override
    public Product findById(int id) {
        return productDAO.findById(id);
    }

    @Override
    public Product saveOrUpdate(Product product) {
        if (product.getProductId() == null) {
            return productDAO.create(product);
        } else {
            return productDAO.update(product);
        }
    }

    @Override
    public boolean delete(int id) {
        // Áp dụng logic soft delete (thay đổi status)
        Product product = productDAO.findById(id);
        if (product != null) {
            product.setStatus(false); 
            productDAO.update(product);
            return true;
        }
        return false;
    }

    @Override
    public List<Product> findActiveWithPagination(int page, int limit) {
        int offset = (page - 1) * limit;
        return productDAO.findActiveRange(offset, limit);
    }

    @Override
    public long countActive() {
        return productDAO.countActive();
    }

    @Override
    public List<Product> findDiscountedActiveWithPagination(int page, int limit) {
        int offset = (page - 1) * limit;
        return productDAO.findDiscountedActiveRange(offset, limit);
    }

    @Override
    public long countDiscountedActive() {
        return productDAO.countDiscountedActive();
    }

    @Override
    public List<Product> findByCategoryWithPagination(int categoryId, int page, int limit) {
        int offset = (page - 1) * limit;
        return productDAO.findByCategory(categoryId, offset, limit);
    }

    @Override
    public long countByCategory(int categoryId) {
        return productDAO.countByCategory(categoryId);
    }

    @Override
    public List<Product> findActiveSorted(int page, int limit, String sortBy) {
        int offset = (page - 1) * limit;
        return productDAO.findActiveSorted(offset, limit, sortBy);
    }

    @Override
    public List<Product> findByCategorySorted(int categoryId, int page, int limit, String sortBy) {
        int offset = (page - 1) * limit;
        return productDAO.findByCategorySorted(categoryId, offset, limit, sortBy);
    }
}