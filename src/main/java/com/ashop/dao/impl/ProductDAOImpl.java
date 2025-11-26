package com.ashop.dao.impl;

import com.ashop.configs.JPAConfig;
import com.ashop.dao.ProductDAO;
import com.ashop.entity.Product;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class ProductDAOImpl implements ProductDAO {
    
    @Override
    public Product findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            // Sử dụng Fetch Join để tải Category cùng lúc, tránh lỗi LazyInitializationException
            TypedQuery<Product> query = em.createQuery(
                "SELECT p FROM Product p LEFT JOIN FETCH p.category WHERE p.productId = :id", Product.class);
            query.setParameter("id", id);
            return query.getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Product> findRange(int offset, int limit) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            // Fetch Join Category để tránh N+1 query
            TypedQuery<Product> query = em.createQuery(
                "SELECT p FROM Product p LEFT JOIN FETCH p.category ORDER BY p.productId DESC", Product.class);
            query.setFirstResult(offset);
            query.setMaxResults(limit);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Product> findAll() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Product> query = em.createQuery("SELECT p FROM Product p LEFT JOIN FETCH p.category", Product.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countAll() { 
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(p) FROM Product p", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Product> findActiveRange(int offset, int limit) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Product> query = em.createQuery(
                "SELECT p FROM Product p LEFT JOIN FETCH p.category WHERE p.status = true ORDER BY p.productId DESC", Product.class);
            query.setFirstResult(offset);
            query.setMaxResults(limit);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public long countActive() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(p) FROM Product p WHERE p.status = true", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }
    
    @Override
    public Product create(Product product) { 
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(product);
            trans.commit();
            return product;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            throw new RuntimeException("Không thể thêm sản phẩm: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Product update(Product product) { 
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Product mergedProduct = em.merge(product);
            trans.commit();
            return mergedProduct;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            throw new RuntimeException("Không thể cập nhật sản phẩm: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public void remove(Product product) { 
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Product attachedProduct = em.merge(product); 
            em.remove(attachedProduct);
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            throw new RuntimeException("Không thể xóa sản phẩm: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
}