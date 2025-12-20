<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
.btn-outline-secondary{
color:#fff;
}
.btn{
color:#fff;
}
/* Replace the broad rule with a targeted hover for the user dropdown only.
   Hover behavior enabled only on desktop (min-width:992px). Mobile/touch still uses click. */
@media (min-width: 992px) {
  /* When hovering or keyboard-focusing the user dropdown, show its menu */
  .user-dropdown:hover > .dropdown-menu,
  .user-dropdown:focus-within > .dropdown-menu,
  .user-dropdown .user-name:hover + .dropdown-menu,
  .user-dropdown .btn:hover + .dropdown-menu {
    display: block !important;
    margin-top: 0.15rem; /* small offset so menu sits under the button */
  }
}

/* Keep user button appearance tidy */
.user-name {
  border: none;
  background: none;
  padding: 0;
}
.user-name:focus { box-shadow: none; outline: none; }

/* Recent items styling inside the dropdown (unchanged) */
.recent-item { display:flex; align-items:center; gap:0.5rem; }
.recent-item img { width:48px; height:48px; object-fit:cover; border-radius:4px; }
</style>

<c:set var="user" value="${sessionScope.currentUser}" />

<header>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm ">
  <div class="container"> <!-- container -->
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/"><i class="fas fa-store"></i> AShop</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="mainNavbar">
      <ul class="navbar-nav nav-center mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Trang chủ</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/products"><i class="fas fa-box"></i> Sản phẩm</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/promotions"><i class="fas fa-tags"></i> Khuyến mãi</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/contact"><i class="fas fa-envelope"></i> Liên hệ</a>
        </li>
      </ul>
      <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/cart" class="nav-link position-relative">
            <i class="fas fa-shopping-cart"></i> Giỏ hàng
          </a>
        </li>
        <!-- Recently viewed dropdown (shows when user has session items) -->
        <c:if test="${not empty sessionScope.recentlyViewedIds}">
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="recentDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
              <i class="fas fa-clock"></i> Đã xem
            </a>
            <ul class="dropdown-menu dropdown-menu-end p-2" aria-labelledby="recentDropdown" style="min-width:260px;">
              <c:forEach var="pid" items="${sessionScope.recentlyViewedIds}">
                <c:set var="p" value="${pageContext.request.contextPath}" />
                <!-- We'll render each item by looking up product in request scope (if provided) or link by id -->
                <li>
                  <a class="dropdown-item recent-item" href="${pageContext.request.contextPath}/product?id=${pid}">
                    <c:choose>
                      <c:when test="${not empty requestScope.recentlyViewed}">
                        <c:forEach var="rp" items="${requestScope.recentlyViewed}">
                          <c:if test="${rp.productId == pid}">
                            <c:choose>
                              <c:when test="${not empty rp.image}">
                                <img src="${pageContext.request.contextPath}/${rp.image}" alt="${fn:escapeXml(rp.productName)}" />
                              </c:when>
                              <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/img/no-image.png" alt="${fn:escapeXml(rp.productName)}" />
                              </c:otherwise>
                            </c:choose>
                            <div class="meta">
                              <div class="fw-bold">${fn:escapeXml(rp.productName)}</div>
                              <div class="text-muted"><fmt:formatNumber value="${rp.price}" type="number" maxFractionDigits="0" /> VNĐ</div>
                            </div>
                          </c:if>
                        </c:forEach>
                      </c:when>
                      <c:otherwise>
                        <img src="${pageContext.request.contextPath}/assets/img/no-image.png" alt="${fn:escapeXml('Sản phẩm')}" />
                        <div class="meta"><div class="fw-bold">Sản phẩm</div></div>
                      </c:otherwise>
                    </c:choose>
                  </a>
                </li>
              </c:forEach>
              <li><hr class="dropdown-divider" /></li>
              <li><a class="dropdown-item text-center" href="${pageContext.request.contextPath}/products">Xem tất cả sản phẩm</a></li>
            </ul>
          </li>
        </c:if>
        <c:choose>
          <c:when test="${user != null}">
            <!-- User dropdown: add user-dropdown class so hover only affects this menu -->
            <li class="nav-item dropdown user-dropdown">
              <!-- Use a button for dropdown toggle to avoid HTML navigation issues -->
              <button class="nav-link dropdown-toggle user-name btn btn-link" id="userDropdown" type="button" data-bs-toggle="dropdown" aria-expanded="false" aria-haspopup="true" style="text-decoration:none;">
                <i class="fas fa-user-circle"> </i>${user.fullName}
              </button>
               <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                 <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account"><i class="fas fa-user"></i> Tài khoản của tôi</a></li>
                 <li><hr class="dropdown-divider"></li>
                 <li><a class="dropdown-item text-danger fw-bold" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a></li>
               </ul>
             </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt"></i> Đăng nhập</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus"></i> Đăng ký</a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

</header>