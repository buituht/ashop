<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
header {
    position: relative; /* Cần thiết cho z-index hoạt động */
    z-index: 1000;      /* Đặt một giá trị cao */
}

.navbar .dropdown-menu {
    /* Tăng giá trị z-index lên mức rất cao, ví dụ 9999, và sử dụng !important 
       để đảm bảo nó ghi đè mọi quy tắc khác. */
    z-index: 9999 !important; 
    /* Đảm bảo menu có vị trí tuyệt đối hoặc cố định */
    position: absolute !important; 
}
</style>
<%-- Giả định User Entity được lưu trong session với khóa: "currentUser" --%>
<c:set var="user" value="${sessionScope.currentUser}" />

<ul class="list-inline mb-0">
    <div class="py-3">
        <div class="row align-items-center">

            <div class="col-sm-8 col-lg-9 d-flex justify-content-start">
                <nav class="navbar navbar-expand-lg w-100 p-0">
                    </nav>
            </div>

            <div class="col-sm-4 col-lg-3 d-flex justify-content-end align-items-center">
                <ul class="list-inline mb-0">
                    
                    <c:choose>
                        <%-- TRƯỜNG HỢP 1: ĐÃ ĐĂNG NHẬP (${user != null}) --%>
                        <c:when test="${user != null}">
                            <li class="list-inline-item dropdown">
                                <a class="nav-link dropdown-toggle text-dark fw-bold" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user-circle me-1"></i> 
                                    ${user.fullName} <%-- Xuất hiện tên người dùng --%>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                    <li><h6 class="dropdown-header">Xin chào, ${user.username}</h6></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/myaccount">Tài khoản của tôi</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item text-danger fw-bold" href="${pageContext.request.contextPath}/logout">
                                            <i class="fas fa-sign-out-alt me-1"></i> Đăng Xuất
                                        </a>
                                    </li>
                                </ul>
                            </li>
                        </c:when>
                        
                        <%-- TRƯỜNG HỢP 2: CHƯA ĐĂNG NHẬP (${user == null}) --%>
                        <c:otherwise>
                            <li class="list-inline-item">
                                <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                            </li>
                            <li class="list-inline-item">
                                <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/register">Đăng ký</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                    
                    <%-- Thêm nút Giỏ hàng (Tùy chọn) --%>
                    <li class="list-inline-item ms-3">
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-warning position-relative p-2 rounded-circle">
                            <i class="fas fa-shopping-cart text-dark"></i>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</header>