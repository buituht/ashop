<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- Include site header (navigation, user/login) --%>
<jsp:include page="/common/web/header.jsp" />

<main>
    <section class="bg-light py-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-5 fw-bold">Chào mừng đến với AShop</h1>
                    <p class="lead text-muted">Sản phẩm chất lượng, giá cả cạnh tranh và trải nghiệm mua sắm thân thiện.</p>
                    <p class="mb-4">Khám phá bộ sưu tập mới nhất, khuyến mại hấp dẫn và dịch vụ chăm sóc khách hàng tận tâm.</p>
                    <div>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg me-2">Xem Sản phẩm</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-secondary btn-lg">Tạo tài khoản</a>
                    </div>
                </div>
                <div class="col-lg-6 d-none d-lg-block">
                    <div class="card border-0 shadow-sm">
                        <img src="${pageContext.request.contextPath}/assets/hero-illustration.png" alt="Hero" class="img-fluid">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5">
        <div class="container">
            <div class="row text-center g-4">
                <div class="col-md-4">
                    <div class="p-4">
                        <i class="fas fa-shipping-fast fa-2x mb-3 text-primary"></i>
                        <h5 class="fw-bold">Giao hàng nhanh</h5>
                        <p class="text-muted">Giao hàng toàn quốc, theo dõi đơn hàng dễ dàng.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4">
                        <i class="fas fa-award fa-2x mb-3 text-primary"></i>
                        <h5 class="fw-bold">Sản phẩm chính hãng</h5>
                        <p class="text-muted">Cam kết chất lượng, đổi trả trong 7 ngày.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="p-4">
                        <i class="fas fa-headset fa-2x mb-3 text-primary"></i>
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
                <h3 class="mb-0">Sản phẩm nổi bật</h3>
                <a href="${pageContext.request.contextPath}/products" class="text-decoration-none">Xem tất cả &raquo;</a>
            </div>

            <div class="row g-4">
                <c:choose>
                    <c:when test="${not empty products}">
                        <c:forEach var="p" items="${products}">
                            <div class="col-6 col-sm-4 col-md-3">
                                <div class="card h-100 shadow-sm">
                                    <c:if test="${p.image != null && p.image != ''}">
                                        <img src="${pageContext.request.contextPath}/${p.image}" class="card-img-top" alt="${p.productName}" style="height:180px;object-fit:cover;">
                                    </c:if>
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title mb-2">${p.productName}</h6>
                                        <div class="mt-auto d-flex justify-content-between align-items-center">
                                            <strong class="text-primary"><fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0" /> VNĐ</strong>
                                            <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="btn btn-sm btn-outline-primary">Xem</a>
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
            <h3 class="mb-4">Khám phá theo danh mục</h3>
            <div class="row g-3">
                <c:if test="${not empty categories}">
                    <c:forEach var="c" items="${categories}">
                        <div class="col-6 col-md-3">
                            <a href="${pageContext.request.contextPath}/products?category=${c.categoryId}" class="text-decoration-none">
                                <div class="card text-center shadow-sm p-3">
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
                    <h4 class="mb-1">Đăng ký nhận khuyến mãi</h4>
                    <p class="text-muted mb-0">Nhận thông tin chương trình và ưu đãi mới nhất qua email.</p>
                </div>
                <div class="col-md-4">
                    <form action="${pageContext.request.contextPath}/newsletter" method="post" class="d-flex">
                        <input type="email" name="email" class="form-control me-2" placeholder="Nhập email của bạn" required>
                        <button class="btn btn-primary" type="submit">Đăng ký</button>
                    </form>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/common/footer.jsp" />

<%-- Small inline styles to keep look neat if global CSS not present --%>
<style>
    .hero-section { padding: 3rem 0; }
    .hero-section img { border-radius: .5rem; }
    .card { border-radius: .5rem; }
</style>