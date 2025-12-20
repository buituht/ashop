package com.ashop.dao.impl;

import com.ashop.configs.JPAConfig;
import com.ashop.dao.ContactDAO;
import com.ashop.entity.Contact;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class ContactDAOImpl implements ContactDAO {
    @Override
    public Contact create(Contact contact) {
        EntityManager em = JPAConfig.getEntityManager();
        em.getTransaction().begin();
        em.persist(contact);
        em.getTransaction().commit();
        em.close();
        return contact;
    }

    @Override
    public Contact findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.find(Contact.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Contact> findAll() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Contact> q = em.createQuery("SELECT c FROM Contact c ORDER BY c.createdAt DESC", Contact.class);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void remove(Contact contact) {
        EntityManager em = JPAConfig.getEntityManager();
        em.getTransaction().begin();
        Contact merged = em.merge(contact);
        em.remove(merged);
        em.getTransaction().commit();
        em.close();
    }

    @Override
    public long count() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            Long c = em.createQuery("SELECT COUNT(c) FROM Contact c", Long.class).getSingleResult();
            return c != null ? c : 0L;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Contact> findWithPagination(int page, int size) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Contact> q = em.createQuery("SELECT c FROM Contact c ORDER BY c.createdAt DESC", Contact.class);
            int first = Math.max(0, (page - 1) * size);
            q.setFirstResult(first);
            q.setMaxResults(size);
            return q.getResultList();
        } finally {
            em.close();
        }
    }
}