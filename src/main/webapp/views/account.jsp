<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<div class="container mt-4">
    <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
    </c:if>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card text-center p-4">
                <div class="mb-3">
                    <!-- User entity currently has no avatar field; use icon fallback -->
                    <div style="width:140px;height:140px;border-radius:50%;background:#f0f0f0;display:flex;align-items:center;justify-content:center;">
                        <i class="fas fa-user-circle" style="font-size:84px;color:#9aa0a6"></i>
                    </div>
                </div>
                <h5 class="card-title mb-0">${user.fullName != null ? user.fullName : user.username}</h5>
                <small class="text-muted">@${user.username}</small>
                <p class="mt-2 mb-1"><span class="badge bg-primary">${user.role}</span></p>
                <div class="d-grid gap-2 mt-3">
                    <a href="${pageContext.request.contextPath}/account/edit" class="btn btn-outline-primary">Chỉnh sửa hồ sơ</a>
                    <a href="${pageContext.request.contextPath}/account/changePassword" class="btn btn-outline-secondary">Đổi mật khẩu</a>
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-link">Xem đơn hàng</a>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="card p-3">
                <ul class="nav nav-tabs" id="accountTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile" type="button" role="tab">Hồ sơ</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="orders-tab" data-bs-toggle="tab" data-bs-target="#orders" type="button" role="tab">Đơn hàng</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="security-tab" data-bs-toggle="tab" data-bs-target="#security" type="button" role="tab">Đổi mật khẩu</button>
                    </li>
                </ul>
                <div class="tab-content mt-3">
                    <div class="tab-pane fade show active" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                        <h5>Thông tin cá nhân</h5>
                        <dl class="row">
                            <dt class="col-sm-4 text-muted">Họ tên</dt>
                            <dd class="col-sm-8">${user.fullName}</dd>

                            <dt class="col-sm-4 text-muted">Email</dt>
                            <dd class="col-sm-8">${user.email}</dd>

                            <dt class="col-sm-4 text-muted">Số điện thoại</dt>
                            <dd class="col-sm-8">${user.phone}</dd>

                            <dt class="col-sm-4 text-muted">Địa chỉ</dt>
                            <dd class="col-sm-8">${user.address}</dd>

                            <dt class="col-sm-4 text-muted">Ngày tạo</dt>
                            <dd class="col-sm-8">${user.createdAt}</dd>
                        </dl>
                        <div class="mt-3">
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/account/edit">Chỉnh sửa thông tin</a>
                            <a class="btn btn-outline-secondary ms-2" href="${pageContext.request.contextPath}/orders">Đơn hàng của tôi</a>
                        </div>
                    </div>

                    <div class="tab-pane fade" id="orders" role="tabpanel" aria-labelledby="orders-tab">
                        <h5>Đơn hàng của bạn</h5>
                        <c:if test="${not empty ordersPage}">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Mã đơn</th>
                                            <th>Ngày</th>
                                            <th>Tổng tiền</th>
                                            <th>Trạng thái</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="o" items="${ordersPage}">
                                            <tr>
                                                <td>${o.orderId}</td>
                                                <td>${o.orderDateStr}</td>
                                                <td><fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ</td>
                                                <td>${o.status}</td>
                                                <td>
                                                    <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/orders/view?id=${o.orderId}">Xem</a>
                                                    <c:if test="${o.status == 'PENDING'}">
                                                        <form action="${pageContext.request.contextPath}/orders/cancel" method="post" style="display:inline-block;margin-left:.4rem;">
                                                            <input type="hidden" name="id" value="${o.orderId}" />
                                                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn hủy đơn hàng #${o.orderId}?');">Hủy</button>
                                                        </form>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination controls -->
                            <nav aria-label="Trang đơn hàng">
                                <ul class="pagination">
                                    <c:set var="cur" value="${ordersPageNumber}" />
                                    <c:set var="totalP" value="${ordersTotalPages}" />
                                    <li class="page-item ${cur <= 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/account?page=${cur-1}&size=${ordersPageSize}#orders">«</a>
                                    </li>
                                    <c:forEach var="p" begin="1" end="${ordersTotalPages}">
                                        <li class="page-item ${p == ordersPageNumber ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/account?page=${p}&size=${ordersPageSize}#orders">${p}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${cur >= totalP ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/account?page=${cur+1}&size=${ordersPageSize}#orders">»</a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                        <c:if test="${empty ordersPage}">
                            <div class="alert alert-info">Bạn chưa có đơn hàng nào.</div>
                            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/orders">Đi tới trang Đơn hàng</a>
                        </c:if>
                     </div>

                    <div class="tab-pane fade" id="security" role="tabpanel" aria-labelledby="security-tab">
                        <h5>Đổi mật khẩu</h5>
                        <c:if test="${not empty message}">
                            <div class="alert alert-info">${message}</div>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/account/changePassword" method="post" class="row g-3" style="max-width:520px;">
                            <div class="col-12">
                                <label class="form-label">Mật khẩu hiện tại</label>
                                <input class="form-control" type="password" name="currentPassword" required />
                            </div>
                            <div class="col-12">
                                <label class="form-label">Mật khẩu mới</label>
                                <input class="form-control" type="password" name="newPassword" minlength="6" required />
                            </div>
                            <div class="col-12">
                                <label class="form-label">Xác nhận mật khẩu mới</label>
                                <input class="form-control" type="password" name="confirmPassword" minlength="6" required />
                            </div>
                            <div class="col-12">
                                <button class="btn btn-primary" type="submit">Đổi mật khẩu</button>
                                <button class="btn btn-light" type="reset">Xóa</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Make tabs respect hash navigation (optional)
(function(){
    if(window.location.hash) {
        var hash = window.location.hash;
        var tabEl = document.querySelector('#accountTabs button[data-bs-target="'+hash+'"]');
        if(tabEl) new bootstrap.Tab(tabEl).show();
    }
})();
</script>