package com.ashop.dao.impl;

import com.ashop.configs.JPAConfig;
import com.ashop.dao.CategoryDAO;
import com.ashop.entity.Category;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class CategoryDAOImpl implements CategoryDAO {
    
    @Override
    public Category findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.find(Category.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Category> findRange(int offset, int limit) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Category> query = em.createQuery("SELECT c FROM Category c ORDER BY c.categoryId DESC", Category.class);
            query.setFirstResult(offset);
            query.setMaxResults(limit);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Category> findAll() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Category> query = em.createQuery("SELECT c FROM Category c", Category.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countAll() { 
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(c) FROM Category c", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public Category create(Category category) { 
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(category);
            trans.commit();
            return category;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            throw new RuntimeException("Không thể thêm danh mục: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Category update(Category category) { 
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Category mergedCategory = em.merge(category);
            trans.commit();
            return mergedCategory;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            throw new RuntimeException("Không thể cập nhật danh mục: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
    
    // Lưu ý: Thường nên thay bằng update status=false
    @Override
    public void remove(Category category) { 
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Category attachedCategory = em.merge(category); 
            em.remove(attachedCategory);
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            throw new RuntimeException("Không thể xóa danh mục: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
}