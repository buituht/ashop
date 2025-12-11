package com.ashop.services.impl;

import com.ashop.dao.ContactDAO;
import com.ashop.dao.impl.ContactDAOImpl;
import com.ashop.entity.Contact;
import com.ashop.services.ContactService;
import com.ashop.utils.EmailUtil;

import jakarta.mail.MessagingException;
import java.util.List;

public class ContactServiceImpl implements ContactService {
    private final ContactDAO contactDAO = new ContactDAOImpl();
    @Override
    public Contact save(Contact contact) {
        Contact created = contactDAO.create(contact);
        // Try sending notification email to admin if SMTP settings are provided via env vars
        try {
            String host = System.getenv("SMTP_HOST");
            String port = System.getenv("SMTP_PORT");
            String username = System.getenv("SMTP_USER");
            String password = System.getenv("SMTP_PASS");
            String adminEmail = System.getenv("ADMIN_EMAIL");
            if (host != null && port != null && username != null && password != null && adminEmail != null) {
                String subject = "[AShop] New contact from " + contact.getName();
                StringBuilder body = new StringBuilder();
                body.append("Name: ").append(contact.getName()).append("\n");
                body.append("Email: ").append(contact.getEmail()).append("\n");
                body.append("Subject: ").append(contact.getSubject()).append("\n\n");
                body.append("Message:\n").append(contact.getMessage()).append("\n");
                EmailUtil.sendEmail(host, port, username, password, adminEmail, subject, body.toString());
            }
        } catch (MessagingException me) {
            // log and ignore - don't fail saving contact if email can't be sent
            me.printStackTrace();
        }
        return created;
    }
    @Override
    public Contact findById(int id) { return contactDAO.findById(id); }
    @Override
    public List<Contact> findAll() { return contactDAO.findAll(); }
    @Override
    public void delete(Contact contact) { contactDAO.remove(contact); }
}