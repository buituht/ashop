package com.ashop.services.impl;

import com.ashop.entity.User;
import com.ashop.services.UserService;
import com.ashop.dao.UserDAO; // Giả định
import com.ashop.dao.impl.UserDAOImpl; // Giả định

import java.util.List;

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
        // Có thể thêm logic nghiệp vụ ở đây, ví dụ:
        // - Kiểm tra tính hợp lệ của email/username
        // - Mã hóa mật khẩu nếu là thêm mới/đổi mật khẩu
        if (user.getUserId() == null) {
            // Logic hash mật khẩu sẽ được thêm vào đây
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
    public User login(String username, String rawPassword) {
        // 1. Tìm user trong DB theo username
        User user = userDAO.findByUsername(username); // Giả định DAO có findByUsername
        
        if (user != null) {
            // 2. So sánh mật khẩu (Sử dụng HashingUtil)
            // if (HashingUtil.checkPassword(rawPassword, user.getPassword())) {
            
            // Tạm thời so sánh chuỗi (CHỈ DÙNG TẠM THỜI cho môi trường TEST)
            // THAY THẾ BẰNG LOGIC HASH SỚM NHẤT CÓ THỂ
            if (rawPassword.equals(user.getPassword())) { 
                
                // 3. Đăng nhập thành công, ẩn mật khẩu trước khi trả về
                user.setPassword(null); 
                return user;
            }
        }
        return null; // Đăng nhập thất bại
    }
}