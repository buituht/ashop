package com.ashop.services;

import com.ashop.entity.Contact;
import java.util.List;

public interface ContactService {
    Contact save(Contact contact);
    Contact findById(int id);
    List<Contact> findAll();
    void delete(Contact contact);
}
