package com.ashop.dao.impl;

import com.ashop.configs.JPAConfig;
import com.ashop.dao.OrderDAO;
import com.ashop.entity.Order;
import com.ashop.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.NoResultException;
import java.util.List;

public class OrderDAOImpl implements OrderDAO {
    @Override
    public Order findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            // Use JOIN FETCH to initialize orderDetails and their product so JSP can access them after EM is closed
            try {
                TypedQuery<Order> q = em.createQuery(
                    "SELECT DISTINCT o FROM Order o " +
                    "LEFT JOIN FETCH o.orderDetails d " +
                    "LEFT JOIN FETCH d.product p " +
                    "WHERE o.orderId = :id", Order.class);
                q.setParameter("id", id);
                return q.getSingleResult();
            } catch (NoResultException nre) {
                // fallback to simple find if query returns no result
                return em.find(Order.class, id);
            }
        } finally {
            em.close();
        }
    }
    @Override
    public List<Order> findByUser(User user) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Order> query = em.createQuery("SELECT o FROM Order o WHERE o.user = :user ORDER BY o.orderDate DESC", Order.class);
            query.setParameter("user", user);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    @Override
    public List<Order> findAll() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Order> q = em.createQuery("SELECT o FROM Order o ORDER BY o.orderDate DESC", Order.class);
            return q.getResultList();
        } finally {
            em.close();
        }
    }
    @Override
    public Order create(Order order) {
        EntityManager em = JPAConfig.getEntityManager();
        em.getTransaction().begin();
        em.persist(order);
        em.getTransaction().commit();
        em.close();
        return order;
    }
    @Override
    public Order update(Order order) {
        EntityManager em = JPAConfig.getEntityManager();
        em.getTransaction().begin();
        Order merged = em.merge(order);
        em.getTransaction().commit();
        em.close();
        return merged;
    }
    @Override
    public void remove(Order order) {
        EntityManager em = JPAConfig.getEntityManager();
        em.getTransaction().begin();
        Order merged = em.merge(order);
        em.remove(merged);
        em.getTransaction().commit();
        em.close();
    }
}