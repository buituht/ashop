package com.ashop.dao.impl;

import com.ashop.configs.JPAConfig;
import com.ashop.dao.OrderDetailDAO;
import com.ashop.entity.OrderDetail;
import com.ashop.entity.Order;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class OrderDetailDAOImpl implements OrderDetailDAO {
    @Override
    public OrderDetail findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.find(OrderDetail.class, id);
        } finally {
            em.close();
        }
    }
    @Override
    public List<OrderDetail> findByOrder(Order order) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<OrderDetail> query = em.createQuery("SELECT od FROM OrderDetail od WHERE od.order = :order", OrderDetail.class);
            query.setParameter("order", order);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    @Override
    public OrderDetail create(OrderDetail orderDetail) {
        EntityManager em = JPAConfig.getEntityManager();
        em.getTransaction().begin();
        em.persist(orderDetail);
        em.getTransaction().commit();
        em.close();
        return orderDetail;
    }
    @Override
    public OrderDetail update(OrderDetail orderDetail) {
        EntityManager em = JPAConfig.getEntityManager();
        em.getTransaction().begin();
        OrderDetail merged = em.merge(orderDetail);
        em.getTransaction().commit();
        em.close();
        return merged;
    }
    @Override
    public void remove(OrderDetail orderDetail) {
        EntityManager em = JPAConfig.getEntityManager();
        em.getTransaction().begin();
        OrderDetail merged = em.merge(orderDetail);
        em.remove(merged);
        em.getTransaction().commit();
        em.close();
    }
}
