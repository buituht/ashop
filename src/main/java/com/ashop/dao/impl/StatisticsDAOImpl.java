package com.ashop.dao.impl;

import com.ashop.configs.JPAConfig;
import com.ashop.dao.StatisticsDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;

import java.time.LocalDateTime;
import java.util.List;

public class StatisticsDAOImpl implements StatisticsDAO {

    @Override
    public List<Object[]> getInventory() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            // Chỉ lấy stock_quantity vì dump có dữ liệu ở cột này
            Query q = em.createNativeQuery("SELECT product_id, product_name, IFNULL(stock_quantity,0) as qty FROM products ORDER BY qty ASC");
            @SuppressWarnings("unchecked")
            List<Object[]> results = q.getResultList();
            return results;
        } finally {
            em.close();
        }
    }

    @Override
    public long countProducts() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            Query q = em.createNativeQuery("SELECT COUNT(*) FROM products");
            Object res = q.getSingleResult();
            if (res instanceof Number) return ((Number) res).longValue();
            return Long.parseLong(String.valueOf(res));
        } finally {
            em.close();
        }
    }

    @Override
    public List<Object[]> getSalesByProduct(LocalDateTime start, LocalDateTime end) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            Query q = em.createQuery("SELECT od.product.productId, od.product.productName, SUM(od.quantity), SUM(od.subtotal) " +
                    "FROM OrderDetail od WHERE od.order.orderDate BETWEEN :start AND :end " +
                    "GROUP BY od.product.productId, od.product.productName ORDER BY SUM(od.quantity) DESC");
            q.setParameter("start", start);
            q.setParameter("end", end);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Object[]> getSalesByCustomer(LocalDateTime start, LocalDateTime end) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            Query q = em.createQuery("SELECT od.order.user.userId, od.order.user.fullName, SUM(od.quantity), SUM(od.subtotal) " +
                    "FROM OrderDetail od WHERE od.order.orderDate BETWEEN :start AND :end " +
                    "GROUP BY od.order.user.userId, od.order.user.fullName ORDER BY SUM(od.subtotal) DESC");
            q.setParameter("start", start);
            q.setParameter("end", end);
            return q.getResultList();
        } finally {
            em.close();
        }
    }
}