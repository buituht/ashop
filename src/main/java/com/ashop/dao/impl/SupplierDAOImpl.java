package com.ashop.dao.impl;

import com.ashop.configs.JPAConfig;
import com.ashop.dao.SupplierDAO;
import com.ashop.entity.Supplier;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class SupplierDAOImpl implements SupplierDAO {

    @Override
    public Supplier findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.find(Supplier.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Supplier> findAll() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<Supplier> q = em.createQuery("SELECT s FROM Supplier s WHERE s.status = true", Supplier.class);
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Supplier create(Supplier supplier) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(supplier);
            trans.commit();
            return supplier;
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            throw new RuntimeException("Không thể thêm nhà cung cấp: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Supplier update(Supplier supplier) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Supplier merged = em.merge(supplier);
            trans.commit();
            return merged;
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            throw new RuntimeException("Không thể cập nhật nhà cung cấp: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void remove(Supplier supplier) {
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Supplier attached = em.merge(supplier);
            em.remove(attached);
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) trans.rollback();
            throw new RuntimeException("Không thể xóa nhà cung cấp: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
}
