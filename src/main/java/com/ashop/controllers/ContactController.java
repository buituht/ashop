package com.ashop.controllers;

import com.ashop.entity.Contact;
import com.ashop.services.ContactService;
import com.ashop.services.impl.ContactServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigInteger;
import java.security.SecureRandom;
import java.util.regex.Pattern;

@WebServlet({"/contact"})
public class ContactController extends HttpServlet {
    private final ContactService contactService = new ContactServiceImpl();
    private static final Pattern EMAIL_REGEX = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private String generateToken() {
        SecureRandom random = new SecureRandom();
        return new BigInteger(130, random).toString(32);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // optional success message
        String sent = request.getParameter("sent");
        if ("1".equals(sent)) {
            request.setAttribute("message", "Tin nhắn của bạn đã được gửi. Chúng tôi sẽ liên hệ sớm.");
        }
        // create CSRF token and store in session
        String csrf = generateToken();
        request.getSession().setAttribute("csrfToken", csrf);
        request.setAttribute("csrfToken", csrf);
        request.getRequestDispatcher("/views/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String token = request.getParameter("csrfToken");
        String sessionToken = (String) request.getSession().getAttribute("csrfToken");
        if (token == null || sessionToken == null || !token.equals(sessionToken)) {
            request.setAttribute("error", "Yêu cầu không hợp lệ (CSRF). Vui lòng thử lại.");
            request.getRequestDispatcher("/views/contact.jsp").forward(request, response);
            return;
        }
        // Invalidate token after use
        request.getSession().removeAttribute("csrfToken");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Server-side validation
        StringBuilder error = new StringBuilder();
        if (name == null || name.trim().isEmpty()) {
            error.append("Vui lòng nhập tên. ");
        }
        if (email == null || email.trim().isEmpty()) {
            error.append("Vui lòng nhập email. ");
        } else if (!EMAIL_REGEX.matcher(email).matches()) {
            error.append("Email không hợp lệ. ");
        }
        if (message == null || message.trim().isEmpty()) {
            error.append("Vui lòng nhập nội dung tin nhắn. ");
        }

        if (error.length() > 0) {
            // Forward back to form with errors and previous values
            request.setAttribute("error", error.toString());
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("subject", subject);
            request.setAttribute("messageText", message);
            request.getRequestDispatcher("/views/contact.jsp").forward(request, response);
            return;
        }

        // Save to DB
        Contact c = new Contact();
        c.setName(name);
        c.setEmail(email);
        c.setSubject(subject);
        c.setMessage(message);

        contactService.save(c);

        response.sendRedirect(request.getContextPath() + "/contact?sent=1");
    }
}