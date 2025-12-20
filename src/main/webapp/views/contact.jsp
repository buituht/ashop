<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="container py-5">
    <h2 class="mb-4">Liên hệ với chúng tôi</h2>

    <!-- Optional search area (keeps structure consistent with product-list.jsp) -->
    <div class="row mb-4">
        <div class="col-md-6">
            <!-- You can enable a help/topic search here if desired -->
            <!-- <input type="search" class="form-control" placeholder="Tìm kiếm hỗ trợ, câu hỏi thường gặp..."> -->
        </div>
        <div class="col-md-6 text-end">
            <small class="text-muted">Mọi thắc mắc về sản phẩm, đơn hàng hay hợp tác — chúng tôi luôn sẵn sàng hỗ trợ.</small>
        </div>
    </div>

    <!-- Contact info cards (responsive grid like product list) -->
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4 mb-4">
        <div class="col">
            <div class="card h-100 shadow-sm text-center">
                <div class="card-body">
                    <i class="fas fa-map-marker-alt fa-2x mb-2 text-primary"></i>
                    <h6 class="fw-bold">Văn phòng</h6>
                    <p class="text-muted small mb-0">123 Đường A, Quận B, Thành phố C</p>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card h-100 shadow-sm text-center">
                <div class="card-body">
                    <i class="fas fa-phone fa-2x mb-2 text-success"></i>
                    <h6 class="fw-bold">Hotline</h6>
                    <p class="text-muted small mb-0">0123 456 789</p>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card h-100 shadow-sm text-center">
                <div class="card-body">
                    <i class="fas fa-envelope fa-2x mb-2 text-danger"></i>
                    <h6 class="fw-bold">Email</h6>
                    <p class="text-muted small mb-0">support@ashop.example</p>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card h-100 shadow-sm text-center">
                <div class="card-body">
                    <i class="fas fa-clock fa-2x mb-2 text-warning"></i>
                    <h6 class="fw-bold">Giờ làm việc</h6>
                    <p class="text-muted small mb-0">T2 - T6: 8:30 - 18:00</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Main content: form (left) + map/social (right) — using same two-column pattern as product-list's grid -->
    <div class="row">
        <div class="col-lg-7 mb-4">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h5 class="card-title mb-3">Gửi tin nhắn</h5>

                    <c:if test="${not empty message}">
                        <div class="alert alert-success">${message}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/contact" method="post" novalidate>
                        <input type="hidden" name="csrfToken" value="${csrfToken}" />
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Tên <span class="text-danger">*</span></label>
                                <input type="text" name="name" class="form-control" required value="${fn:escapeXml(name)}" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email <span class="text-danger">*</span></label>
                                <input type="email" name="email" class="form-control" required value="${fn:escapeXml(email)}" />
                            </div>
                            <div class="col-12">
                                <label class="form-label">Tiêu đề</label>
                                <input type="text" name="subject" class="form-control" value="${fn:escapeXml(subject)}" />
                            </div>
                            <div class="col-12">
                                <label class="form-label">Nội dung <span class="text-danger">*</span></label>
                                <textarea name="message" class="form-control" rows="6" required>${fn:escapeXml(messageText)}</textarea>
                            </div>
                            <div class="col-12 text-end">
                                <button type="submit" class="btn btn-primary">Gửi tin nhắn</button>
                            </div>
                        </div>
                    </form>

                </div>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="card shadow-sm mb-3 h-100">
                <div class="card-body">
                    <h5 class="card-title">Bản đồ</h5>
                    <div class="ratio ratio-4x3">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d387190.2799075029!2d-74.259865!3d40.6976701!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zMzTCsDQyJzQ2LjciTiA3NMKwMTUnMDQuMiJX!5e0!3m2!1sen!2s!4v1600000000000!5m2!1sen!2s" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h5 class="card-title">Kết nối với chúng tôi</h5>
                    <p class="mb-1"><i class="fab fa-facebook fa-lg me-2"></i><a href="#">Facebook</a></p>
                    <p class="mb-1"><i class="fab fa-instagram fa-lg me-2"></i><a href="#">Instagram</a></p>
                    <p class="mb-0"><i class="fab fa-youtube fa-lg me-2"></i><a href="#">YouTube</a></p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Small inline styles to polish the contact page -->
<style>
.ratio iframe { width:100%; height:100%; }
.card .card-body h5 { margin-bottom: 1rem; }
</style>