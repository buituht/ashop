package com.ashop.dao.impl;

import com.ashop.configs.JPAConfig;
import com.ashop.dao.UserDAO;
import com.ashop.entity.User;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class UserDAOImpl implements UserDAO {
    
    // --- KHAI BÁO CÁC PHƯƠNG THỨC DAO ĐÃ TRIỂN KHAI ---

    @Override
    public User findById(int id) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> findRange(int offset, int limit) {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u ORDER BY u.userId DESC", User.class);
            query.setFirstResult(offset);
            query.setMaxResults(limit);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<User> findAll() {
        EntityManager em = JPAConfig.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u", User.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public long countAll() { 
        EntityManager em = JPAConfig.getEntityManager();
        try {
            // Sử dụng Long.class để đảm bảo kiểu trả về là Long
            return em.createQuery("SELECT COUNT(u) FROM User u", Long.class)
                     .getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public User create(User user) { 
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(user);
            trans.commit();
            return user;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            throw new RuntimeException("Không thể thêm người dùng: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public User update(User user) { 
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            User mergedUser = em.merge(user);
            trans.commit();
            return mergedUser;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            throw new RuntimeException("Không thể cập nhật người dùng: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
    
    // Phương thức remove này nên được sử dụng cẩn thận (thường chỉ thay đổi status)
    @Override
    public void remove(User user) { 
        EntityManager em = JPAConfig.getEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            // Cần merge trước khi remove nếu đối tượng không nằm trong context hiện tại
            User attachedUser = em.merge(user); 
            em.remove(attachedUser);
            trans.commit();
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            throw new RuntimeException("Không thể xóa người dùng: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public User findByUsername(String username) {
        EntityManager em = JPAConfig.getEntityManager();
        
        // JPQL Query: Tìm user theo username
        String jpql = "SELECT u FROM User u WHERE u.username = :username";
        
        try {
            TypedQuery<User> query = em.createQuery(jpql, User.class);
            query.setParameter("username", username);
            
            // Lấy một kết quả duy nhất (username là UNIQUE)
            return query.getSingleResult();
            
        } catch (NoResultException e) {
            // Trả về null nếu không tìm thấy user nào
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean checkExistEmail(String email) {
        EntityManager em = JPAConfig.getEntityManager();
        String jpql = "SELECT COUNT(u) FROM User u WHERE u.email = :email";
        
        try {
            Long count = em.createQuery(jpql, Long.class)
                           .setParameter("email", email)
                           .getSingleResult();
            return count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
    @Override
    public boolean checkExistUsername(String username) {
        EntityManager em = JPAConfig.getEntityManager();
        
        // JPQL Query: Count users where username matches (username is UNIQUE)
        String jpql = "SELECT COUNT(u) FROM User u WHERE u.username = :username";
        
        try {
            Long count = em.createQuery(jpql, Long.class)
                           .setParameter("username", username)
                           .getSingleResult();
            
            // If count is greater than 0, the username exists
            return count > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
    
}