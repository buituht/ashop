package com.ashop.dao;

import com.ashop.entity.User;
import java.util.List;

public interface UserDAO {
    User findById(int id);
    List<User> findRange(int offset, int limit); // Dùng cho phân trang
    List<User> findAll();
    long countAll();
    User create(User user);
    User update(User user);
    void remove(User user);
    User findByUsername(String username);
    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
}