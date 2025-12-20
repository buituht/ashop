# 📘 ASHOP - Specialty Product E-Commerce Platform

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