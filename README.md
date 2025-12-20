# 📘 ASHOP - Specialty Product E-Commerce Platform

<<<<<<< HEAD
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
=======
**Status**: ✅ Production Ready  
**Last Updated**: 20/12/2025  
**Version**: 2.0  

This is a comprehensive guide for understanding, setting up, and developing the ASHOP e-commerce platform.

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [System Architecture](#system-architecture)
3. [Quick Start Guide](#quick-start-guide)
4. [Complete Features](#complete-features)
5. [Installation & Setup](#installation--setup)
6. [How Features Work](#how-features-work)
7. [Image Upload System](#image-upload-system)
8. [API Documentation](#api-documentation)
9. [Testing Guide](#testing-guide)
10. [Troubleshooting](#troubleshooting)
11. [Code Structure](#code-structure)
12. [Deployment](#deployment)

---

## 🎯 Project Overview

**ASHOP** is a modern e-commerce platform built with **Jakarta EE** and **Hibernate ORM**, specializing in Vietnamese specialty products (seafood, dried fruits, candies, sauces).

### Key Features
- 🔍 **Smart Product Filtering** - Filter by category with database-side optimization
- 📊 **Advanced Sorting** - 6 sort options working across all pages
- 📄 **AJAX Pagination** - Seamless page navigation without refresh
- ⚡ **Lazy Loading** - Auto-load products on scroll or manual click
- 🖼️ **Image Upload** - Admin can upload product images directly
- 📱 **Responsive Design** - Works on desktop, tablet, and mobile
- 🛒 **Shopping Cart** - Add products, manage cart
- 📦 **Order Management** - Track orders, view history
- 👤 **User Accounts** - Register, login, manage profile

---

## 🏗️ System Architecture

### Technology Stack

```
Frontend Layer:
├── JSP (Jakarta Server Pages)
├── HTML5, CSS3, Bootstrap 5
├── JavaScript (ES6 Classes)
└── jQuery 3.6.0

API Layer:
├── Servlets (HTTP Controllers)
├── REST Endpoints (/api/products)
└── JSON Response Format

Business Logic Layer:
├── Service Classes
├── Business Rules
└── Data Validation

Data Access Layer:
├── JPA/Hibernate ORM
├── DAO Pattern
└── Database Queries

Database:
├── MySQL 10.4.32
├── 8 Tables with relationships
└── Optimized Indexes
```

### Layered Architecture

```
┌─────────────────────────────────────────┐
│       USER INTERFACE LAYER              │
│   JSP Views, HTML, CSS, JavaScript      │
└────────────────────┬────────────────────┘
                     │
┌────────────────────▼────────────────────┐
│    SERVLET/CONTROLLER LAYER             │
│  Handle HTTP Requests, Route to Services│
└────────────────────┬────────────────────┘
                     │
┌────────────────────▼────────────────────┐
│     SERVICE LAYER (Business Logic)      │
│  Process Data, Apply Rules, Validation  │
└────────────────────┬────────────────────┘
                     │
┌────────────────────▼────────────────────┐
│      DAO LAYER (Data Access)            │
│  Query Database, CRUD Operations        │
└────────────────────┬────────────────────┘
                     │
┌────────────────────▼────────────────────┐
│       DATABASE (MySQL)                  │
│  Persistent Data Storage                │
└─────────────────────────────────────────┘
```

---

## 🚀 Quick Start Guide (For Newcomers)

### Prerequisites
- ✅ Java 24+
- ✅ Maven 3.9+
- ✅ MySQL 10.4+
- ✅ Eclipse IDE or Visual Studio Code
- ✅ Tomcat 10.1

### Step 1: Setup Database (5 minutes)

```bash
# Open MySQL CLI
mysql -u root -p

# Create database
CREATE DATABASE ashop;
USE ashop;

# Import data
source ashop\ \(1\).sql

# Verify
SELECT COUNT(*) FROM products;  # Should return 6
SELECT COUNT(*) FROM categories;  # Should return 5
```

**Database includes**:
- 📦 6 specialty products
- 🏷️ 5 categories
- 👥 Users (admin, customers)
- 🛒 Cart & Orders tables
- ⭐ Reviews

### Step 2: Build & Deploy (3 minutes)

```bash
# Build
cd C:\Users\son.ba\eclipse-workspace\ashop
mvn clean compile

# Start Tomcat (in Eclipse)
# Servers view > Tomcat > Start

# Access
http://localhost:8080/ashop/products
```

### Step 3: Test (1 minute)

```
✅ See product list with images
✅ Filter by category (dropdown)
✅ Sort products (6 options)
✅ Click page 2 (AJAX - no refresh)
✅ Try lazy loading ("Tải thêm")
✅ Admin upload image (/admin/product/add)
```

---

## ✨ Complete Features

### 1️⃣ Category Filter

**Filters products by category instantly**

```
1. Open http://localhost:8080/ashop/products
2. Click "Danh mục" dropdown
3. Select "Hải Sản Khô"
4. AJAX loads results ✅
```

**Categories**:
- Hải Sản Khô (Seafood)
- Trái Cây Sấy (Dried Fruits)
- Bánh Kẹo Đặc Sản (Pastries)
- Gia Vị & Nước Chấm (Sauces)

**Technical**: Uses LEFT JOIN FETCH to prevent N+1 queries

---

### 2️⃣ Advanced Sorting ✅

**6 Sort Methods**:
1. Mặc định (Default)
2. Mới nhất (Newest)
3. Giá: Thấp → Cao (Price ASC)
4. Giá: Cao → Thấp (Price DESC)
5. Tên: A → Z (Name ASC)
6. Tên: Z → A (Name DESC)

**✨ Key Fix**: Sorts ALL products at database, not just 12 on page

```sql
ORDER BY p.price ASC, p.productId DESC LIMIT 12
```

---

### 3️⃣ AJAX Pagination

**Navigate pages without refresh**

```
User clicks "Page 2"
  → AJAX request
  → JSON response
  → Render products
  → Auto scroll top
  → No refresh ✅
```

**Features**:
- Previous/Next buttons
- Dynamic page numbers
- Smart pagination (shows "...")
- Disabled states at boundaries

---

### 4️⃣ Lazy Loading

**Auto-load products as you scroll**

```
User clicks "Tải thêm"
  → Enable lazy load mode
  → User scrolls down
  → At 80% scroll → Auto-load next page
  → Products append (not replace)
  → Continue for infinite scroll ✅
```

**Two modes**:
- Auto-load: Scroll triggers load
- Manual: Click buttons to load

---

### 5️⃣ Image Upload System ✅

**Admin uploads images via web**

```
Admin fills product info
  → Click "Choose File"
  → Select image
  → Click "Lưu sản phẩm"
  → Filename auto-generated from slug
  → Saved to: src/main/webapp/photos/products/
  → Database updated
  → Web displays ✅
```

**Example**:
```
Input: "Mực Khô Câu" + "squid.jpg"
  ↓
Slug: "muc-kho-cau"
  ↓
Final: "muc-kho-cau.jpg"
  ↓
URL: /ashop/photos/products/muc-kho-cau.jpg
```

**Limits**:
- Max: 10MB per image
- Max request: 50MB
- Location: src/main/webapp/photos/products/

---

## 📦 Installation & Setup

### Full Setup

#### 1. Database (5 minutes)

```bash
# Verify MySQL
mysql --version

# Create database
mysql -u root -p
mysql> source /path/to/ashop\ \(1\).sql

# Check
mysql> USE ashop;
mysql> SHOW TABLES;  # Should show 8 tables
```

#### 2. Project Build (3 minutes)

```bash
cd C:\Users\son.ba\eclipse-workspace\ashop
mvn clean compile  # Should see: BUILD SUCCESS
```

#### 3. Configure Database

**File**: `src/main/resources/META-INF/persistence.xml`

```xml
<property name="jakarta.persistence.jdbc.url" 
          value="jdbc:mysql://localhost:3306/ashop"/>
<property name="jakarta.persistence.jdbc.user" value="root"/>
<property name="jakarta.persistence.jdbc.password" value="your_password"/>
```

#### 4. Deploy (1 minute)

```bash
# Eclipse: Servers > Tomcat > Start
# Or terminal: catalina run

# Access
http://localhost:8080/ashop/products
```

### Directory Structure

```
ashop/
├── src/main/java/com/ashop/
│   ├── controllers/        (Handle requests)
│   ├── services/           (Business logic)
│   ├── dao/                (Database access)
│   ├── entity/             (JPA models)
│   └── configs/            (Configuration)
├── src/main/webapp/
│   ├── views/              (JSP pages)
│   ├── resources/          (CSS, JS)
│   ├── photos/products/    (Uploaded images)
│   └── WEB-INF/
├── src/main/resources/
│   └── META-INF/persistence.xml
├── pom.xml                 (Maven config)
└── README.md              (This file)
```

---

## 🎯 How Features Work

### Feature 1: Filter & Sort

**Flow**:
```
User selects category
  ↓
AJAX: GET /api/products?categoryId=1&sort=price-asc
  ↓
ProductApiServlet.handleFilter()
  ↓
ProductService.findByCategorySorted()
  ↓
ProductDAO executes HQL with ORDER BY
  ↓
Return JSON with products
  ↓
JavaScript renders
```

**Database**:
```sql
SELECT p FROM Product p 
LEFT JOIN FETCH p.category 
WHERE p.status = true AND p.category.categoryId = 1 
ORDER BY p.price ASC
LIMIT 12 OFFSET 0
```

### Feature 2: Pagination

**Click page → AJAX → Products render → No refresh ✅**

- Works with filters
- Works with sorting
- Maintains state

### Feature 3: Lazy Loading

**Scroll 80% → Auto-load → Append products ✅**

- Infinite scroll experience
- Manual button option
- Toggle anytime

---

## 📸 Image Upload System

### Upload Workflow

```
Admin Form → ProductFormController.doPost()
  ↓
Generate slug from name
  ↓
Get file upload
  ↓
Extract extension
  ↓
Create filename: slug + ext
  ↓
Write to: /photos/products/
  ↓
Save to database
  ↓
Display on web ✅
```

### Code Example

```java
// ProductFormController.java
private static final String UPLOAD_DIR = "/photos/products/";

if (filePart != null && filePart.getSize() > 0) {
    String slug = toSlug(productName);  // "muc-kho-cau"
    String ext = ".jpg";
    String fileName = slug + ext;       // "muc-kho-cau.jpg"
    
    Path uploadPath = Paths.get(getRealPath(UPLOAD_DIR));
    Files.createDirectories(uploadPath);
    filePart.write(uploadPath.resolve(fileName).toString());
    
    imagePath = UPLOAD_DIR + fileName;  // "/photos/products/muc-kho-cau.jpg"
}
```

---

## 📡 API Documentation

### Endpoint
```
GET http://localhost:8080/ashop/api/products
```

### Parameters

| Parameter | Type | Example | Description |
|-----------|------|---------|-------------|
| action | string | pagination | Operation type |
| page | int | 1 | Page number |
| categoryId | int | 1 | Category filter |
| sort | string | price-asc | Sort method |

### Response

```json
{
  "success": true,
  "currentPage": 1,
  "totalPages": 5,
  "totalItems": 50,
  "products": [
    {
      "productId": 1,
      "productName": "Mực Khô Câu",
      "price": 750000.0,
      "image": "photos/products/muc-kho-cau.jpg",
      "categoryName": "Hải Sản Khô"
    }
  ]
}
```

### Examples

```
All products:
GET /api/products?action=pagination&page=1

Filter + Sort:
GET /api/products?action=filter&categoryId=1&sort=price-asc&page=1

Lazy load:
GET /api/products?action=load-more&page=2
```

---

## 🧪 Testing Guide

### Test 1: Filter
```
Select category → Only that category shown ✅
```

### Test 2: Sort
```
Select sort → Page 1 sorted, Page 2 also sorted ✅
```

### Test 3: Pagination
```
F12 > Network > Click page 2
→ AJAX request (200 OK)
→ Products changed
→ No page refresh ✅
```

### Test 4: Lazy Load
```
Click "Tải thêm" → Scroll 80% → Auto-load ✅
```

### Test 5: Image Upload
```
Admin > Add Product > Upload → Check photos/products/ folder
→ File saved ✅
```

### Test 6: Combined
```
Category + Sort + Page 2 → All work together ✅
```

---

## 🛠️ Troubleshooting

### AJAX 404

**Check**:
```
1. F12 > Network > /api/products
2. Status code
3. Response body
4. ProductApiServlet exists
5. Rebuild: mvn clean compile
```

### Sorting Wrong

**Check**:
```
1. Database: SELECT * FROM products ORDER BY price;
2. Product.price not null
3. URL has ?sort=price-asc
4. Rebuild + Restart
```

### Images Not Showing

**Check**:
```
1. Database: SELECT image FROM products;
2. File exists: photos/products/{name}
3. Path correct: /ashop/photos/products/
4. F12 > Network > Image status 200
```

### Lazy Load Fails

**Check**:
```
1. Scroll to 80% bottom
2. F12 > Console errors
3. ProductFilter class loaded
4. product-filter.js file exists
```

### Upload Directory Error

**Check**:
```
1. Folder exists: src/main/webapp/photos/products/
2. Write permissions: Properties > Security
3. File size < 10MB
4. Total < 50MB
```

### Database Connection Error

**Check**:
```
1. MySQL running: mysql -u root -p
2. Database exists: SHOW DATABASES;
3. persistence.xml credentials correct
4. Restart MySQL service
```

---

## 💻 Code Structure

### Key Classes

**Controllers** (Handle HTTP requests):
```
ProductController → /products page
ProductApiServlet → /api/products AJAX
ProductFormController → /admin/product/add upload
```

**Services** (Business logic):
```
ProductService → Interface
ProductServiceImpl → Implementation
CategoryService → Category logic
```

**DAOs** (Database access):
```
ProductDAO → Product queries
ProductDAOImpl → Hibernate implementation
CategoryDAO → Category queries
```

**Entities** (JPA models):
```
Product → product table
Category → categories table
User → users table
```

---

## 🚀 Deployment

### Build

```bash
mvn clean package
# Creates: target/ashop-0.0.1-SNAPSHOT.war
```

### Deploy

```bash
# Copy to Tomcat
copy target/ashop-*.war C:\path\to\tomcat\webapps\

# Restart Tomcat
C:\path\to\tomcat\bin\catalina.bat restart

# Access
http://localhost:8080/ashop/products
```

### Checklist

- [x] Database setup
- [x] Code compiled
- [x] Tests passed
- [x] Images uploaded
- [x] Tomcat restarted
- [x] URL accessible

---

## 📊 Database Schema

```
products (6 items)
├── product_id (PK)
├── category_id (FK → categories)
├── product_name
├── price
├── sale_price
├── image → photos/products/{slug}.jpg
└── status

categories (5 items)
├── category_id (PK)
├── category_name
└── status

Relationship: Product N:1 Category
```

---

## ✅ For New Developers

### Key Concepts

1. **MVC Pattern**: Controllers → Views → Models
2. **Layered Architecture**: Controller → Service → DAO → DB
3. **ORM**: Hibernate handles object-to-database mapping
4. **AJAX**: jQuery handles async requests
5. **Database**: MySQL with proper relationships

### Common Tasks

**View database**:
```sql
USE ashop;
SELECT * FROM products;
SELECT * FROM categories;
```

**Rebuild**: `mvn clean compile`
**Restart**: Tomcat > Restart in Eclipse
**Debug**: F12 DevTools in browser
**Logs**: catalina.out in Tomcat folder

### Learning Path

1. Week 1: Understand architecture (read this README)
2. Week 2: Test features (follow Testing Guide)
3. Week 3: Understand code (explore classes)
4. Week 4: Make changes (follow Code Structure)

---

## 🎉 Conclusion

You now have complete understanding of ASHOP platform:
- ✅ Architecture explained
- ✅ All features documented
- ✅ Setup instructions
- ✅ Testing guide
- ✅ Troubleshooting
- ✅ Code structure

**Start with Quick Start Guide above. Good luck! 🚀**

---

Made with ❤️ using Jakarta EE, Hibernate & MySQL
>>>>>>> a8f0ae44645885b88118b6756f2378ee208cdf17
