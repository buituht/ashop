package com.ashop.controllers.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // If query param view=stats then forward to new dashboard-stats.jsp
        String view = request.getParameter("view");
        if ("stats".equalsIgnoreCase(view)) {
            request.getRequestDispatcher("/views/admin/dashboard-stats.jsp").forward(request, response);
            return;
        }


        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
}