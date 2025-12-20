package com.ashop.services.impl;

import com.ashop.entity.User;
import com.ashop.services.UserService;
import com.ashop.dao.UserDAO; // Giả định
import com.ashop.dao.impl.UserDAOImpl; // Giả định
import com.ashop.utils.EmailUtil;

import java.util.List;
import org.mindrot.jbcrypt.BCrypt;
import java.util.UUID;

public class UserServiceImpl implements UserService {

    // Dependency Injection (Thường dùng @Inject/Autowired, ở đây là khởi tạo thủ công)
    private final UserDAO userDAO = new UserDAOImpl(); 

    @Override
    public List<User> findWithPagination(int page, int limit) {
        // Tính toán offset (vị trí bắt đầu)
        int offset = (page - 1) * limit;
        return userDAO.findRange(offset, limit);
    }

    @Override
    public long countAll() {
        return userDAO.countAll();
    }

    @Override
    public User findById(int id) {
        return userDAO.findById(id);
    }

    @Override
    public User saveOrUpdate(User user) {
   
        if (user.getUserId() == null) {
            
            // user.setPassword(PasswordUtils.hash(user.getPassword())); 
            return userDAO.create(user);
        } else {
            return userDAO.update(user);
        }
    }

    @Override
    public boolean delete(int id) {
        // Thay vì xóa cứng, nên thay đổi trạng thái status = false để khóa tài khoản
        User user = userDAO.findById(id);
        if (user != null) {
            user.setStatus(false); // Khóa tài khoản
            userDAO.update(user);
            return true;
        }
        return false;
    }

    @Override
    public boolean lockUser(int userId) {
        User user = userDAO.findById(userId);
        if (user == null) return false;
        try {
            user.setStatus(false);
            userDAO.update(user);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteIfNoOrders(int userId) {
        try {
            long orders = userDAO.countOrdersByUser(userId);
            if (orders > 0) return false; // cannot delete
            User user = userDAO.findById(userId);
            if (user == null) return false;
            userDAO.remove(user);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public User login(String username, String rawPassword) {
        // 1. Tìm user trong DB theo username
        User user = userDAO.findByUsername(username); // Giả định DAO có findByUsername
        
        if (user != null) {
            // 2. So sánh mật khẩu (Sử dụng BCrypt nếu mật khẩu trong DB đã được hash)
            try {
                String stored = user.getPassword();
                if (stored != null && (stored.startsWith("$2a$") || stored.startsWith("$2b$") || stored.startsWith("$2y$"))) {
                    // bcrypt hashed password
                    if (BCrypt.checkpw(rawPassword, stored)) {
                        user.setPassword(null);
                        return user;
                    }
                } else {
                    // fallback to plain-text comparison for legacy records
                    if (rawPassword.equals(stored)) {
                        user.setPassword(null);
                        return user;
                    }
                }
            } catch (Exception ex) {
                // if any error occurs during check, treat as authentication failure
                ex.printStackTrace();
            }
         }
         return null; // Đăng nhập thất bại
     }
     @Override
     public boolean checkExistEmail(String email) {
         // Delegate the check to the DAO layer
         return userDAO.checkExistEmail(email); 
     }
     
     @Override
     public boolean register(String username, String password, String fullName, String email, String phone, String address, String role, Boolean status, String avatar) {
         try {
             // NOTE: HASHING MUST BE DONE HERE
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // 1. Tạo Entity
            User newUser = new User(); 
            
            // 2. Set các giá trị (bao gồm mật khẩu đã hash)
            newUser.setUsername(username);
            newUser.setPassword(hashedPassword);
             newUser.setFullName(fullName);
             newUser.setEmail(email);
             newUser.setPhone(phone);
             newUser.setAddress(address);
             newUser.setRole(role);
             newUser.setStatus(status);
             // ... set avatar, created_at, etc. ...

             // 3. Gọi DAO để lưu
             userDAO.create(newUser); 
             return true;
         } catch (Exception e) {
             e.printStackTrace();
             return false;
         }
     }
     
     @Override
     public boolean checkExistUsername(String username) {
         // Logic sẽ gọi DAO để kiểm tra sự tồn tại
         return userDAO.checkExistUsername(username); 
     }

     @Override
     public User findByUsername(String username) {
         return userDAO.findByUsername(username);
     }

     @Override
     public boolean registerWithEmailVerification(String username, String password, String fullName, String email, String phone, String address, String role, Boolean status, String avatar, String appUrl) throws Exception {
        try {
            // 1. Hash password
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // 2. Create user and token
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPassword(hashedPassword);
            newUser.setFullName(fullName);
            newUser.setEmail(email);
            newUser.setPhone(phone);
            newUser.setAddress(address);
            newUser.setRole(role);
            newUser.setStatus(status);

            String token = UUID.randomUUID().toString();
            newUser.setVerificationToken(token);
            newUser.setEmailVerified(false);

            // 3. Persist user
            userDAO.create(newUser);

            // 4. Send verification email
            String verifyLink = appUrl + "/verify?token=" + token;
            String subject = "Xác thực email cho tài khoản của bạn";
            String body = "Xin chào " + fullName + ",\n\n" +
                    "Vui lòng nhấp vào liên kết sau để xác thực email và kích hoạt tài khoản của bạn:\n" +
                    verifyLink + "\n\n" +
                    "Nếu bạn không đăng ký tại trang này, hãy bỏ qua email này.";

            // Check SMTP configuration: if not set (using default), don't fail — print link to console (dev fallback)
            // Use empty default so behavior matches controller which checks for empty value
            String smtpHost = System.getProperty("mail.smtp.host", System.getenv().getOrDefault("MAIL_SMTP_HOST", "smtp.gmail.com"));
            String smtpPort = System.getProperty("mail.smtp.port", System.getenv().getOrDefault("MAIL_SMTP_PORT", "587"));
            String smtpUser = System.getProperty("mail.smtp.user", System.getenv().getOrDefault("MAIL_SMTP_USER", "pummenvietnam@gmail.com"));
            String smtpPass = System.getProperty("mail.smtp.pass", System.getenv().getOrDefault("MAIL_SMTP_PASS", "ywye trqk teer rwvk"));

            if (smtpUser == null || smtpUser.isEmpty() || smtpPass == null || smtpPass.isEmpty()) {
                // Credentials missing — fallback to dev mode: print verification link and skip sending
                //System.out.println("[DEV MODE] SMTP credentials not configured. Verification link for user '" + username + "': " + verifyLink);
                return true;
            }

            try {
                // Use the fully-parameterized EmailUtil method
                EmailUtil.sendEmail(smtpHost, smtpPort, smtpUser, smtpPass, email, subject, body);
            } catch (Exception sendEx) {
                // If sending failed for other reasons, bubble up so controller can handle
                sendEx.printStackTrace();
                throw sendEx;
            }

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            throw e; // bubble up so controller can show proper message
        }
    }

     @Override
     public boolean verifyToken(String token) {
         try {
             User user = userDAO.findByVerificationToken(token);
             if (user == null) return false;
             return userDAO.verifyUserEmail(user);
         } catch (Exception e) {
             e.printStackTrace();
             return false;
         }
     }
 }