package com.ashop.controllers;

import com.ashop.entity.User;
import com.ashop.services.UserService;
import com.ashop.services.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final UserService userService = new UserServiceImpl();

    /**
     * Xử lý GET: Hiển thị form đăng ký.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        // Kiểm tra xem người dùng đã đăng nhập chưa (Nếu có, chuyển hướng)
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Chuyển tiếp đến trang JSP đăng ký
      
        req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
    }

    /**
     * Xử lý POST: Nhận dữ liệu form và tạo người dùng mới.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        // 1. Lấy dữ liệu từ form
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address"); 
        
        // Mặc định cho các trường ẩn/mặc định
        String role = "USER";
        Boolean status = true;
        String avatar = "default_avatar.png"; 

        HttpSession session = req.getSession();
        String forwardUrl = "/views/register.jsp";

        try {
            // 2. Kiểm tra nghiệp vụ: Email và Username tồn tại
            if (userService.checkExistEmail(email)) {
                req.setAttribute("alert", "Email này đã được đăng ký!");
                req.getRequestDispatcher(forwardUrl).forward(req, resp);
                return;
            }
            
            if (userService.checkExistUsername(username)) {
                req.setAttribute("alert", "Tên đăng nhập này đã tồn tại!");
                req.getRequestDispatcher(forwardUrl).forward(req, resp);
                return;
            }
            
            // 3. Thực hiện Đăng ký qua Service (với email xác thực)
            String appUrl = req.getScheme() + "://" + req.getServerName() + (req.getServerPort() == 80 || req.getServerPort() == 443 ? "" : ":" + req.getServerPort()) + req.getContextPath();
            boolean isSuccess = false;
            try {
                isSuccess = userService.registerWithEmailVerification(username, password, fullName, email, phone, address, role, status, avatar, appUrl);
            } catch (Exception e) {
                e.printStackTrace();
                // If sending fails we still want to show a helpful message and the verification link if possible
                // Try to fetch the created user and provide the link to the UI
                User created = userService.findByUsername(username);
                if (created != null && created.getVerificationToken() != null) {
                    String verifyLink = appUrl + "/verify?token=" + created.getVerificationToken();
                    session.setAttribute("verificationLink", verifyLink);
                }
                req.setAttribute("alert", "Không thể gửi email xác thực. Vui lòng kiểm tra cấu hình SMTP hoặc sử dụng liên kết kích hoạt hiển thị bên dưới.");
                req.getRequestDispatcher(forwardUrl).forward(req, resp);
                return;
            }
            
            if (isSuccess) {
                // Determine SMTP config presence to customize message
                String smtpHost = System.getProperty("mail.smtp.host", System.getenv().getOrDefault("MAIL_SMTP_HOST", ""));
                String emailInfo;
                if (smtpHost == null || smtpHost.isEmpty()) {
                    // env not set; dev fallback likely printed link to console. Provide the link in UI by reading saved user.
                    User created = userService.findByUsername(username);
                    String verifyLink = null;
                    if (created != null && created.getVerificationToken() != null) {
                        verifyLink = appUrl + "/verify?token=" + created.getVerificationToken();
                        session.setAttribute("verificationLink", verifyLink);
                    }
                    emailInfo = "Đăng ký thành công! (Chạy ở môi trường dev): liên kết kích hoạt được hiển thị bên dưới.";
                } else {
                    emailInfo = "Đăng ký thành công! Email xác thực đã được gửi đến " + email + ". Vui lòng kiểm tra hộp thư (và spam).";
                }

                // Store success message and email info in session so login page can display them
                session.setAttribute("successMessage", "Đăng ký thành công!");
                session.setAttribute("emailInfo", emailInfo);

                // Redirect to login (PRG)
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            } else {
                // Lỗi DB/Hệ thống
                req.setAttribute("alert", "Đăng ký thất bại do lỗi hệ thống. Vui lòng thử lại.");
                req.getRequestDispatcher(forwardUrl).forward(req, resp);
                return;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("alert", "Lỗi kỹ thuật: Không thể hoàn tất đăng ký.");
            req.getRequestDispatcher(forwardUrl).forward(req, resp);
        }
    }
}