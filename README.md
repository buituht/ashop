Các Công cụ và Công nghệ Cốt lõi

JPA (Hibernate): Được sử dụng cho tầng DAO, thay thế JDBC thủ công, quản lý các Entity (User, Category, Product, Order, Review, Cart) và giao dịch (EntityTransaction).
Servlets: Hoạt động như các Controller, xử lý yêu cầu HTTP.
JSP/JSTL: Được sử dụng cho tầng View (giao diện).
Bootstrap 5: Cung cấp phong cách và bố cục hiện đại, nhất quán cho cả Admin và Front-end.
JavaMail API: Được sử dụng để gửi email xác nhận đơn hàng.

---

# AShop — Tóm tắt dự án và hướng dẫn chỉnh sửa

Tài liệu này giúp bạn nhanh chóng nắm dự án web AShop và biết chính xác nơi cần chỉnh sửa khi cập nhật giao diện hoặc hành vi của trang.

1) Tóm tắt

- Loại dự án: Java web application (WAR) dùng Servlets + JSP + JPA (Hibernate).
- Mục tiêu: Cửa hàng điện tử (AShop) với các trang sản phẩm, giỏ hàng, đăng ký/đăng nhập, quản lý đơn hàng.

2) Công nghệ chính

- Java Servlets (jakarta.servlet)
- JSP + JSTL cho view
- JPA (Hibernate) cho ORM
- MySQL làm DB ( cấu hình trong `src/main/resources/META-INF/persistence.xml` )
- Bootstrap 5, FontAwesome cho UI
- jBCrypt cho băm mật khẩu
- JavaMail (Jakarta Mail) để gửi email

3) Vị trí file quan trọng

- `pom.xml` — dependencies & build (packaging: war, Java source/target = 24)
- `src/main/resources/META-INF/persistence.xml` — cấu hình DataSource (tên persistence-unit = "dataSource").
  - Mặc định trong repo: jdbc:mysql://localhost:3306/ashop  (user=root, password="")
  - Hibernate: hbm2ddl.auto=update
- `src/main/java/com/ashop/configs/JPAConfig.java` — helper tạo EntityManager
- `src/main/java/com/ashop/controllers/` — các Servlet chính (controller)
  - `ProductController` -> mapped: `/products`, `/product`, `/promotions`
  - `CartController` -> `/cart/*` (thêm/xóa/hiển thị giỏ)
  - `AccountController` -> `/account`, `/account/edit`, `/account/changePassword`
  - `LoginController`, `RegisterController`, `OrderController`, `ContactController`, `VerifyController`, v.v.
- `src/main/java/com/ashop/services/` — business logic
- `src/main/java/com/ashop/dao/` — truy xuất persistence
- `src/main/java/com/ashop/entity/` — các Entity: `User`, `Product`, `Category`, `Order`, `OrderDetail`, `Cart`, `Contact`, `Supplier`
- `src/main/webapp/` — Tài nguyên web
  - `index.jsp` — trang chủ (nạp products + categories khi cần)
  - `views/` — các JSP cụ thể: `product-list.jsp`, `product-detail.jsp`, `cart.jsp`, `checkout.jsp`, `account.jsp`, `login.jsp`, `register.jsp`, v.v.
  - `photos/` — hình ảnh tĩnh (hero, product images nếu được lưu đường dẫn tương đối)
  - `common/` — header/footer/partials (nếu có)
  - `WEB-INF/web.xml` — cấu hình web (welcome files, sitemesh filter mapping)
  - `WEB-INF/sitemesh3.xml` and `decorators/` — cấu hình sitemesh layout

4) Các endpoint chính (front-end)
- `/` hoặc `/index.jsp` — trang chủ
- `/products` — danh sách sản phẩm (pagination)
- `/product?id={id}` — chi tiết sản phẩm
- `/promotions` — sản phẩm khuyến mãi
- `/cart` và `/cart/add` — quản lý giỏ hàng (thông thường POST cho thêm)
- `/login`, `/register`, `/account` — tài khoản người dùng
- `/checkout` — trang thanh toán

5) Cấu hình DB và khởi tạo dữ liệu
- File cấu hình: `src/main/resources/META-INF/persistence.xml`.
- Mặc định kết nối tới MySQL local `ashop` (user root, no password). Nếu DB khác, chỉnh `persistence.xml` hoặc sử dụng biến môi trường / JNDI tùy cách triển khai.
- Có file SQL giúp tạo dữ liệu mẫu trong repo gốc: `ashop (1).sql` (root folder) — kiểm tra và import nếu cần.

6) Build & Deploy (quick start trên Windows cmd)

- Build war:

```bash
mvn clean package
```

- Sau khi có file `target/ashop-0.0.1-SNAPSHOT.war`, deploy vào Tomcat (dùng Apache Tomcat 10+ vì project dùng Jakarta namespace). Copy file .war vào thư mục `webapps` của Tomcat và khởi động Tomcat.

- Hoặc chạy trong Eclipse: Run trên server Tomcat được cấu hình.

7) Hướng dẫn nhanh chỉnh sửa giao diện

Khi muốn chỉnh layout/HTML/CSS/JS:
- Các thư mục chính để chỉnh giao diện: `src/main/webapp/views/` (JSP cụ thể) và `src/main/webapp/common/` (partials)
- Hình ảnh: `src/main/webapp/photos/` — thay ảnh hero hoặc ảnh tĩnh ở đây
- CSS/JS: nếu dùng CDN, chỉnh trực tiếp trong layout/partials; nếu chứa file cục bộ, tìm trong `resources/` hoặc `webapp/resources/`.
- Thay đổi logic hiển thị: chỉnh servlet tương ứng trong `src/main/java/com/ashop/controllers/` (ví dụ `ProductController` để thay đổi pagination hoặc số item)

Checklist khi chỉnh giao diện:
- Chỉnh JSP (views) + partials
- Cập nhật đường dẫn ảnh trong thư mục `photos`
- Kiểm tra encoding (UTF-8) và taglib JSTL (`jakarta.tags.core`, `jakarta.tags.fmt`)
- Build & redeploy war để kiểm tra trên Tomcat

8) Bảo mật & lưu ý
- Mật khẩu: sử dụng jBCrypt; code đã kiểm tra và hỗ trợ cả hash và legacy plain-text.
- Không commit thông tin nhạy cảm (DB passwords) vào repo.

9) Gửi email / SMTP
- Có controller `SmtpTestController` và cấu hình JavaMail dependencies trong `pom.xml`.
- Cấu hình SMTP chưa được lưu ở file repo (thường đặt trong properties hoặc environment). Cần bổ sung cấu hình (host, port, user, pass, TLS) để gửi email xác nhận.

10) Debug & logging
- Hibernate show_sql = true trong `persistence.xml` giúp debug các câu SQL.
- Thêm logging (SLF4J + Logback/Log4j) nếu cần để theo dõi lỗi runtime.

11) Các bước gợi ý khi tiến hành chỉnh sửa site
- Bước 1: Tạo branch mới trong git
- Bước 2: Cập nhật JSP / CSS / ảnh trong `src/main/webapp` và commit
- Bước 3: Build: `mvn clean package` và deploy WAR lên Tomcat để thử nghiệm
- Bước 4: Kiểm tra luồng đăng nhập, thêm vào giỏ, checkout
- Bước 5: Viết/Chạy unit tests cho service/dao nếu thêm logic mới

12) Tài liệu tham khảo nhanh
- Cấu hình persistence: `src/main/resources/META-INF/persistence.xml`
- Servlet controllers: `src/main/java/com/ashop/controllers/`
- Views: `src/main/webapp/views/`
- Entities: `src/main/java/com/ashop/entity/`

## 13) Chức năng User (Backend) — mô tả chi tiết và chuẩn bị chỉnh sửa

Mục này mô tả cách chức năng người dùng được triển khai ở backend (authentication, registration, email verification, quản lý user) để bạn biết chính xác nơi cần sửa và những gì cần kiểm tra trước khi deploy.

A. Các endpoint / controllers chính

- `GET /login` -> `LoginController.doGet` (hiển thị form login)
- `POST /login` -> `LoginController.doPost` (xác thực, tạo session, cookie "rememberMe")
- `GET /logout` -> `LogoutController.doGet` (invalidate session, xóa cookie)
- `GET /register` -> `RegisterController.doGet` (hiển thị form)
- `POST /register` -> `RegisterController.doPost` (tạo user, gửi email xác thực khi có SMTP)
- `GET /verify?token=...` -> `VerifyController.doGet` (xác thực token, bật emailVerified)
- Admin user management (file service/dao + admin controllers): `UserService`, `UserDAO`, `UserDAOImpl`, (các servlet admin nếu có) — dùng để duyệt/paging/xóa/khóa user.

B. Luồng chính

- Đăng ký:
  - `RegisterController` nhận dữ liệu và gọi `UserService.registerWithEmailVerification(...)`.
  - `UserServiceImpl` tạo user, hash mật khẩu bằng BCrypt, tạo `verificationToken` (UUID), lưu user (DAO), và gửi email xác thực nếu cấu hình SMTP có sẵn.
  - Nếu SMTP không đầy đủ (dev), controller cố gắng đọc `verificationToken` của user vừa tạo và lưu `verificationLink` vào session để hiển thị cho dev.

- Xác thực email:
  - `VerifyController` gọi `UserService.verifyToken(token)`.
  - `UserServiceImpl` tìm user theo token (`userDAO.findByVerificationToken`) và gọi `userDAO.verifyUserEmail(user)` để set `emailVerified=true` và xóa token.

- Đăng nhập:
  - `LoginController` gọi `userService.findByUsername(username)` để kiểm tra tồn tại và trạng thái `emailVerified`.
  - Sau đó gọi `userService.login(username, password)` để xác thực (BCrypt.checkpw nếu password lưu dạng bcrypt, nếu không thì so sánh plain-text để tương thích legacy).
  - Nếu thành công: lưu `currentUser` vào session, `role` vào session, và nếu rememberMe được check thì tạo cookie `username`.

- Logout:
  - `LogoutController` invalidate session và xóa cookie `username`.

C. Các lớp, file liên quan (điểm cần mở khi chỉnh sửa)

- Entities: `src/main/java/com/ashop/entity/User.java` (fields: `userId, username, password, fullName, email, phone, address, role, createdAt, status, verificationToken, emailVerified`)
- DAO interface: `src/main/java/com/ashop/dao/UserDAO.java` (methods: findRange, countAll, findById, create, update, remove, findByUsername, checkExistEmail, checkExistUsername, findByVerificationToken, verifyUserEmail, findByEmail)
- DAO impl: `src/main/java/com/ashop/dao/impl/UserDAOImpl.java` (JPQL queries; includes `findByUsername`, `findByVerificationToken`, `verifyUserEmail`)
- Service interface: `src/main/java/com/ashop/services/UserService.java` (methods for login, register, verification, pagination, delete)
- Service impl: `src/main/java/com/ashop/services/impl/UserServiceImpl.java` (hashing, registerWithEmailVerification, verifyToken, login logic)
- Controllers: `src/main/java/com/ashop/controllers/{LoginController,RegisterController,LogoutController,VerifyController,AccountController,Account related servlets}`
- Views: `src/main/webapp/views/login.jsp`, `register.jsp`, `views/message.jsp`, `views/account.jsp` (thực hiện hiển thị/feedback), admin user list view nếu có.

D. Contracts — inputs/outputs/behaviour (ngắn)

- registerWithEmailVerification(username,password,fullName,email,phone,address,role,status,avatar,appUrl)
  - Input: form fields, appUrl để sinh link verify
  - Output: boolean (true nếu user được tạo; với gửi-mail có thể throw exception)
  - Side effects: lưu user với hashed password và token
  - Error modes: username/email tồn tại, SMTP lỗi (có thể throw), DB lỗi

- login(username, rawPassword)
  - Input: username + plain password
  - Output: User object (password nulled) khi success, null khi fail
  - Error modes: user not found, password mismatch, account not verified, DB exception

E. Điểm cần chú ý / edge cases

- Email verification: nếu SMTP không cấu hình, code trả về true và controller hiển thị verification link cho dev (đã implement). Cần xóa/ẩn liên kết trong production.
- Password hashing: BCrypt được dùng; legacy plain-text fallback được hỗ trợ (cẩn thận khi mã hóa lại constant). Khi force migrate toàn bộ người dùng, cần reset password hoặc mã hóa lại sau lần đăng nhập.
- Authentication: session lưu `currentUser` và `role`. Nên kiểm tra role (`user.getRole().equals("ADMIN")`) ở các servlet admin.
- Cookie security: cookie `username` không lưu mật khẩu, nhưng cũng không được đánh dấu HttpOnly/Secure trong code hiện tại — cân nhắc set HttpOnly và Secure (HTTPS) khi production.
- Missing/placeholder implementations: `UserDAOImpl.findByEmail` hiện trả `null` (TODO).

F. Cấu hình môi trường (SMTP, DB) — hiện code đang dùng env vars và System properties

- SMTP keys đọc từ environment variables trong nhiều chỗ (ví dụ `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `ADMIN_EMAIL`) hoặc System properties (`mail.smtp.*`).
- DB cấu hình hiện nằm trong `src/main/resources/META-INF/persistence.xml` (JDBC URL, user, password). Bạn có thể thay bằng JNDI/Properties sau khi tách cấu hình.

G. Checklist chuẩn bị để chỉnh sửa (tôi đã tạo file ví dụ cấu hình):

- [ ] Đảm bảo có bản sao DB dev (import `ashop (1).sql`) nếu cần test dữ liệu user.
- [ ] Thiết lập SMTP dev (hoặc dùng dev fallback và đọc `verificationLink` từ session) để test email verification.
- [ ] (Optional) Tạo file `src/main/resources/example.env` để lưu các biến môi trường mẫu (DB, SMTP, ADMIN_EMAIL).
- [ ] Kiểm tra `UserDAOImpl.findByEmail` nếu bạn sẽ search user bằng email (cập nhật nếu cần).
- [ ] Bật logging để debug (SQL + ứng dụng).

H. Các chỉnh sửa phổ biến bạn có thể muốn thực hiện (và file liên quan)

- Thay đổi form đăng ký/validation front-end/back-end: `views/register.jsp`, `RegisterController`, `UserServiceImpl.register*`.
- Thêm captcha / rate-limit cho đăng ký/đăng nhập: các controller `RegisterController`, `LoginController`.
- Thay đổi logic remember-me sang token-based: `LoginController` + cookie logic + tách cookie storage.
- Thay đổi xác thực email để có expiration cho token: thêm field `verificationTokenExpiry` trong `User` và logic trong `UserServiceImpl`.
- Thêm reset password flow: cần controller + service + mail template + DAO methods.

I. Những thay đổi an toàn nhỏ mà tôi có thể làm ngay (hãy chọn để tôi thực hiện):

- Tạo `src/main/resources/example.env` (đã sẵn sàng) với các key mẫu.
- Triển khai `UserDAOImpl.findByEmail` (đã sẵn sàng) nếu bạn muốn tìm kiếm theo email.
- Thêm HttpOnly/Secure lên cookie "username" trong `LoginController`.
- Thêm verify isAdmin checks trong admin controllers.

---

Tôi đã thêm phần mô tả chức năng user vào `README.md` và tạo file cấu hình mẫu `src/main/resources/example.env` (nếu bạn đồng ý). Tiếp theo bạn muốn tôi tiếp tục với mục nào trong phần I?  
- Implement `findByEmail` (dao)  
- Bật HttpOnly/Secure cho cookie remember-me  
- Thêm kiểm tra isAdmin cho controller admin  
- Hoặc tôi thực hiện tất cả các mục nhỏ an toàn trên