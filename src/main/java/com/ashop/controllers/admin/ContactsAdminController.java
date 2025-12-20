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

        // Pagination params
        int page = 1;
        int size = 10; // default page size
        String pageParam = request.getParameter("page");
        String sizeParam = request.getParameter("size");
        try { if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException ignored) {}
        try { if (sizeParam != null) size = Math.max(1, Integer.parseInt(sizeParam)); } catch (NumberFormatException ignored) {}

        long total = contactService.count();
        int totalPages = (int) Math.max(1, Math.ceil(total / (double) size));
        if (page > totalPages) page = totalPages;

        List<Contact> contacts = contactService.findWithPagination(page, size);

        request.setAttribute("contacts", contacts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", size);

        request.getRequestDispatcher("/views/admin/contacts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();
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
                    if (c != null) {
                        contactService.delete(c);
                        request.getSession().setAttribute("message", "Xóa liên hệ thành công");
                    } else {
                        request.getSession().setAttribute("message", "Liên hệ không tồn tại");
                    }
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("message", "ID liên hệ không hợp lệ");
                } catch (Exception ex) {
                    request.getSession().setAttribute("message", "Đã xảy ra lỗi khi xóa liên hệ");
                }
            } else {
                request.getSession().setAttribute("message", "Thiếu tham số id");
            }
            response.sendRedirect(request.getContextPath() + "/admin/contacts");
            return;
        }

        // Default fallback
        response.sendRedirect(request.getContextPath() + "/admin/contacts");
    }
}