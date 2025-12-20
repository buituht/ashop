<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- Nếu request chưa chứa 'products' (sản phẩm nổi bật) hoặc 'categories', nạp chúng bằng service --%>
<%
    if (request.getAttribute("products") == null) {
        try {
            com.ashop.services.impl.ProductServiceImpl ps = new com.ashop.services.impl.ProductServiceImpl();
            java.util.List<com.ashop.entity.Product> featured = null;
            long countDiscounted = ps.countDiscountedActive();
            if (countDiscounted > 0) {
                featured = ps.findDiscountedActiveWithPagination(1, 8); // lấy tối đa 8 sản phẩm nổi bật
            } else {
                featured = ps.findActiveWithPagination(1, 8); // fallback: lấy sản phẩm mới nhất
            }
            request.setAttribute("products", featured);
        } catch (Exception e) {
            // Nếu có lỗi, đặt attribute rỗng để JSP xử lý phần hiển thị
            request.setAttribute("products", java.util.Collections.emptyList());
            e.printStackTrace();
        }
    }

    if (request.getAttribute("categories") == null) {
        try {
            com.ashop.services.impl.CategoryServiceImpl cs = new com.ashop.services.impl.CategoryServiceImpl();
            java.util.List<com.ashop.entity.Category> cats = cs.findActive();
            request.setAttribute("categories", cats);
        } catch (Exception e) {
            request.setAttribute("categories", java.util.Collections.emptyList());
            e.printStackTrace();
        }
    }
    
%>

<main>
    <section class="bg-light py-5 hero-section animate__animated animate__fadeIn">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-5 fw-bold text-gradient">Chào mừng đến với <span class="text-primary">AShop</span></h1>
                    <p class="lead text-muted">Sản phẩm chất lượng, giá cả cạnh tranh và trải nghiệm mua sắm thân thiện.</p>
                    <p class="mb-4">Khám phá bộ sưu tập mới nhất, khuyến mại hấp dẫn và dịch vụ chăm sóc khách hàng tận tâm.</p>
                    <div>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg me-2 animate__animated animate__pulse animate__infinite">Xem Sản phẩm <i class="fas fa-arrow-right"></i></a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-secondary btn-lg">Tạo tài khoản <i class="fas fa-user-plus"></i></a>
                    </div>
                </div>
                <div class="col-lg-6 d-none d-lg-block">
                    <div class="card border-0 shadow-sm animate__animated animate__zoomIn">
                        <img src="${pageContext.request.contextPath}/photos/hero-illustration.png" alt="Hero" class="img-fluid rounded-4">
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section class="py-5">
        <div class="container">
            <div class="row text-center g-4">
                <div class="col-md-4">
                    <div class="p-4 card shadow-sm h-100 hover-card">
                        <i class="fas fa-shipping-fast fa-2x mb-3 text-primary"></i>
                        <h5 class="fw-bold">Giao hàng nhanh</h5>
                        <p class="text-muted">Giao hàng toàn quốc, theo dõi đơn hàng dễ dàng.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4 card shadow-sm h-100 hover-card">
                        <i class="fas fa-award fa-2x mb-3 text-warning"></i>
                        <h5 class="fw-bold">Sản phẩm chính hãng</h5>
                        <p class="text-muted">Cam kết chất lượng, đổi trả trong 7 ngày.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4 card shadow-sm h-100 hover-card">
                        <i class="fas fa-headset fa-2x mb-3 text-success"></i>
                        <h5 class="fw-bold">Hỗ trợ 24/7</h5>
                        <p class="text-muted">Đội ngũ chăm sóc khách hàng luôn sẵn sàng hỗ trợ.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section class="py-5 bg-white">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="mb-0"><i class="fas fa-star text-warning"></i> Sản phẩm nổi bật</h3>
                <a href="${pageContext.request.contextPath}/products" class="text-decoration-none">Xem tất cả &raquo;</a>
            </div>
            <div class="row g-4">
                <c:choose>
                    <c:when test="${not empty products}">
                        <c:forEach var="p" items="${products}">
                            <div class="col-6 col-sm-4 col-md-3">
                                <div class="card h-100 shadow-sm product-card animate__animated animate__fadeInUp">
                                    <c:if test="${p.image != null && p.image != ''}">
                                        <img src="${pageContext.request.contextPath}/${p.image}" class="card-img-top" alt="${p.productName}" style="height:180px;object-fit:cover;">
                                    </c:if>
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title mb-2">${p.productName}</h6>
                                        <div class="mt-auto d-flex justify-content-between align-items-center">
                                            <div>
                                                <c:choose>
                                                    <c:when test="${p.salePrice != null && p.salePrice < p.price}">
                                                        <div class="mb-1">
                                                            <span class="text-muted text-decoration-line-through me-2"><fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0" /> VNĐ</span>
                                                            <span class="text-danger fw-bold"><fmt:formatNumber value="${p.salePrice}" type="number" maxFractionDigits="0" /> VNĐ</span>
                                                        </div>
                                                        <c:set var="discountPercent" value="${((p.price - p.salePrice) * 100) / p.price}" />
                                                        <small class="text-success">Giảm <fmt:formatNumber value="${discountPercent}" type="number" maxFractionDigits="0" />%</small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <strong class="text-primary"><fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0" /> VNĐ</strong>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                             <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="btn btn-sm btn-outline-primary">Xem <i class="fas fa-eye"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center text-muted">Chưa có sản phẩm nổi bật. Hãy kiểm tra lại sau.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>
    <section class="py-5 bg-light">
        <div class="container">
            <h3 class="mb-4"><i class="fas fa-th-large text-primary"></i> Khám phá theo danh mục</h3>
            <div class="row g-3">
                <c:if test="${not empty categories}">
                    <c:forEach var="c" items="${categories}">
                        <div class="col-6 col-md-3">
                            <a href="${pageContext.request.contextPath}/products?category=${c.categoryId}" class="text-decoration-none">
                                <div class="card text-center shadow-sm p-3 hover-card">
                                    <i class="fas fa-box fa-2x text-muted mb-2"></i>
                                    <div class="fw-bold">${c.categoryName}</div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${empty categories}">
                    <div class="col-12 text-muted">Không có danh mục nào.</div>
                </c:if>
            </div>
        </div>
    </section>
    <section class="py-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h4 class="mb-1"><i class="fas fa-envelope-open-text text-info"></i> Đăng ký nhận khuyến mãi</h4>
                    <p class="text-muted mb-0">Nhận thông tin chương trình và ưu đãi mới nhất qua email.</p>
                </div>
                <div class="col-md-4">
                    <form action="${pageContext.request.contextPath}/newsletter" method="post" class="d-flex">
                        <input type="email" name="email" class="form-control me-2" placeholder="Nhập email của bạn" required>
                        <button class="btn btn-primary" type="submit">Đăng ký <i class="fas fa-paper-plane"></i></button>
                    </form>
                </div>
            </div>
        </div>
    </section>
</main>
<!-- Thêm hiệu ứng animate.css và custom style cho sinh động -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" />
<style>
.text-gradient {
    background: linear-gradient(90deg, #007bff, #00c6ff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    text-fill-color: transparent;
}
.hover-card:hover {
    box-shadow: 0 0 20px #007bff33;
    transform: translateY(-5px) scale(1.03);
    transition: all 0.3s;
}
.product-card:hover {
    box-shadow: 0 0 20px #ffc10755;
    transform: scale(1.04);
    transition: all 0.3s;
}
.hero-section {
    background: linear-gradient(90deg, #f8fafc 60%, #e3f2fd 100%);
}
</style>