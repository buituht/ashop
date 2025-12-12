package com.ashop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.ashop.utils.EmailUtil;

import java.io.IOException;

@WebServlet("/smtp-test")
public class SmtpTestController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/views/smtp_test.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String to = req.getParameter("to");
        String subject = req.getParameter("subject");
        String body = req.getParameter("body");

        if (to == null || to.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập email người nhận.");
            req.getRequestDispatcher("/views/smtp_test.jsp").forward(req, resp);
            return;
        }

        try {
            EmailUtil.sendEmail(to, subject == null ? "[Test] SMTP" : subject, body == null ? "Test body" : body);
            req.setAttribute("success", "Email đã gửi tới: " + to);
        } catch (Exception e) {
            req.setAttribute("error", "Gửi email thất bại: " + e.getMessage());
            e.printStackTrace();
        }

        req.getRequestDispatcher("/views/smtp_test.jsp").forward(req, resp);
    }
}
