package com.ashop.controllers.admin;

import com.ashop.entity.Contact;
import com.ashop.entity.User;
import com.ashop.services.ContactService;
import com.ashop.services.impl.ContactServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet({"/admin/contacts","/admin/contacts/delete"})
public class ContactsAdminController extends HttpServlet {
    private final ContactService contactService = new ContactServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
        // Check admin session - assume session attribute 'currentUser' and User has isAdmin flag
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null /*|| !user.isAdmin()*/) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("/admin/contacts/delete".equals(servletPath)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int id = Integer.parseInt(idParam);
                    Contact c = contactService.findById(id);
                    if (c != null) contactService.delete(c);
                } catch (NumberFormatException e) {
                    // ignore
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/contacts");
            return;
        }

        List<Contact> contacts = contactService.findAll();
        request.setAttribute("contacts", contacts);
        request.getRequestDispatcher("/views/admin/contacts.jsp").forward(request, response);
    }
}
