package com.ashop.dao.impl;

import com.ashop.configs.JPAConfig;
import com.ashop.dao.CartDAO;
import com.ashop.entity.Cart;
import com.ashop.entity.User;
import com.ashop.entity.Product;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class CartDAOImpl implements CartDAO {
    @Override
    public Cart findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.find(Cart.class, id);
        } finally {
            em.close();
        }
    }
    @Override
    public List<Cart> findByUser(User user) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Cart> query = em.createQuery("SELECT c FROM Cart c JOIN FETCH c.product WHERE c.user = :user", Cart.class);
            query.setParameter("user", user);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    @Override
    public Cart findByUserAndProduct(User user, Product product) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Cart> query = em.createQuery("SELECT c FROM Cart c WHERE c.user = :user AND c.product = :product", Cart.class);
            query.setParameter("user", user);
            query.setParameter("product", product);
            List<Cart> result = query.getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }
    @Override
    public Cart create(Cart cart) {
        EntityManager em = JPAConfig.getEntityManager();
        em.getTransaction().begin();
        em.persist(cart);
        em.getTransaction().commit();
        em.close();
        return cart;
    }
    @Override
    public Cart update(Cart cart) {
        EntityManager em = JPAConfig.getEntityManager();
        em.getTransaction().begin();
        Cart merged = em.merge(cart);
        em.getTransaction().commit();
        em.close();
        return merged;
    }
    @Override
    public void remove(Cart cart) {
        EntityManager em = JPAConfig.getEntityManager();
        em.getTransaction().begin();
        Cart merged = em.merge(cart);
        em.remove(merged);
        em.getTransaction().commit();
        em.close();
    }
}