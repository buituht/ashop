package com.ashop.dao;

import com.ashop.entity.Contact;
import java.util.List;

public interface ContactDAO {
    Contact create(Contact contact);
    Contact findById(int id);
    List<Contact> findAll();
    void remove(Contact contact);

    // Thêm hỗ trợ phân trang
    long count();
    List<Contact> findWithPagination(int page, int size);
}