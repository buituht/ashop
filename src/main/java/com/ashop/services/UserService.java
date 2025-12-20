package com.ashop.services;

import com.ashop.entity.User;
import java.util.List;

public interface UserService {

    /**
     * Lấy danh sách người dùng có phân trang.
     * @param page Số trang hiện tại (bắt đầu từ 1).
     * @param limit Số lượng mục trên mỗi trang.
     * @return Danh sách các đối tượng User.
     */
    List<User> findWithPagination(int page, int limit);

    /**
     * Đếm tổng số lượng người dùng trong hệ thống.
     * @return Tổng số lượng người dùng.
     */
    long countAll();

    /**
     * Tìm người dùng bằng ID.
     * @param id ID của người dùng.
     * @return Đối tượng User, hoặc null nếu không tìm thấy.
     */
    User findById(int id);

    /**
     * Lưu hoặc cập nhật người dùng.
     * @param user Đối tượng User cần lưu.
     * @return Đối tượng User đã được lưu/cập nhật.
     */
    User saveOrUpdate(User user);

    /**
     * Xóa người dùng (thường là khóa/đổi trạng thái).
     * @param id ID của người dùng cần xóa.
     * @return true nếu xóa thành công, false nếu ngược lại.
     */
    boolean delete(int id);
    
    User login(String username, String rawPassword);
    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
    boolean register(String username, String password, String fullName, String email, String phone, String address, String role, Boolean status, String avatar);
    boolean registerWithEmailVerification(String username, String password, String fullName, String email, String phone, String address, String role, Boolean status, String avatar, String appUrl) throws Exception;
    boolean verifyToken(String token);
    User findByUsername(String username);

    /**
     * Khóa hoặc mở khóa người dùng.
     * @param userId ID của người dùng cần khóa/mở khóa.
     * @return true nếu thao tác thành công, false nếu ngược lại.
     */
    boolean lockUser(int userId);

    /**
     * Xóa người dùng nếu không có đơn hàng nào liên quan.
     * @param userId ID của người dùng cần xóa.
     * @return true nếu xóa thành công, false nếu ngược lại.
     */
    boolean deleteIfNoOrders(int userId);
}