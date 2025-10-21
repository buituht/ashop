package com.ashop.filters; 

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
// ... imports ...
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.ashop.entity.User; // <--- Cần Import Entity User mới


// Ánh xạ Filter đến TẤT CẢ các URL bắt đầu bằng /admin/
@WebFilter(urlPatterns="/admin/*")
public class AdminFilter implements Filter {

 
    
    // ==========================================================
    // CÁC PHƯƠNG THỨC VÒNG ĐỜI (Giữ nguyên)
    // ==========================================================
    @Override
    public void init(FilterConfig fConfig) throws ServletException {
        System.out.println("AdminFilter initialized!");
    }

    @Override
    public void destroy() {
        System.out.println("AdminFilter destroyed!");
    }

    // ==========================================================
    // PHƯƠNG THỨC LỌC CHÍNH (MAIN FILTER METHOD)
    // ==========================================================

    @Override // <--- ADD THIS ANNOTATION
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException { // <--- Full signature must match interface
        
        // Cast to HTTP objects (Standard practice for web filters)
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        
        // *Luồng 1: Lấy Session và User Object*
        HttpSession session = req.getSession(false); 
        User user = null; 
        
        if (session != null) {
             Object userObj = session.getAttribute("currentUser");
             if (userObj instanceof User) {
                 user = (User) userObj;
             }
        }

        // *Luồng 2: Kiểm tra Đã đăng nhập và Quyền hạn*
        if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) { 
            
            // Hợp lệ -> Cho phép yêu cầu đi tiếp qua chuỗi Filter
            chain.doFilter(request, response);
            return;
            
        } else {
            // Không hợp lệ -> Chuyển hướng
            String contextPath = req.getContextPath(); 
            String loginUrl = contextPath + "/login";
            
            resp.sendRedirect(loginUrl); 
        }
    }


}