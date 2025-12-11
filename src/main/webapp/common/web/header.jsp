<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
header {
    position: relative; /* Cần thiết cho z-index hoạt động */
    z-index: 1000;      /* Đặt một giá trị cao */
}

.navbar { position: relative; }

.navbar .dropdown-menu {
    /* Tăng giá trị z-index lên mức rất cao, ví dụ 9999, và sử dụng !important 
       để đảm bảo nó ghi đè mọi quy tắc khác. */
    z-index: 9999 !important; 
    /* Đảm bảo menu có vị trí tuyệt đối hoặc cố định */
    position: absolute !important; 
    background: #ffffff !important; /* ensure menu is white so text is readable */
}

/* Force visible when `.show` is present (fallback) */
.navbar .dropdown-menu.show {
    display: block !important;
}

/* Center main navbar links on desktop without using .container */
@media (min-width: 992px) {
  /* Make the collapsed region a centered flex container */
  .navbar .collapse.navbar-collapse {
    display: flex !important;
    justify-content: center;
    align-items: center;
  }

  /* Position brand on the left */
  .navbar .navbar-brand {
    position: absolute;
    left: 1rem;
    top: 50%;
    transform: translateY(-50%);
  }

  /* Position right-side actions (cart, user) to the right */
  .navbar .navbar-nav.ms-auto {
    position: absolute;
    right: 1rem;
    top: 50%;
    transform: translateY(-50%);
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  /* Ensure the toggler is hidden on desktop (Bootstrap normally hides it) */
  .navbar .navbar-toggler {
    display: none;
  }

  /* Centered nav list styling */
  .navbar .nav-center {
    display: flex;
    gap: 1rem;
  }
}

/* --- Hover-to-open dropdown on desktop ---
   Only enable hover behavior for larger screens (desktop) so mobile/touch
   devices continue to use Bootstrap's click/tap behavior. */
@media (min-width: 992px) {
  .navbar .dropdown:hover > .dropdown-menu {
    display: block;
    transform: none;
    opacity: 1;
    visibility: visible;
    margin-top: 0.25rem; /* small spacing under the nav link */
  }
  /* Keep the toggle visible as active when hovering */
  .navbar .dropdown:hover > .nav-link.user-name,
  .navbar .dropdown.show > .nav-link.user-name {
    /* Force a visible, dark color for username and caret on hover/open */
    color: #212529 !important;
    background: transparent !important;
  }
}

/* Small styling tweak so the username looks clickable */
.navbar .nav-link.user-name {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    color: #212529; /* default dark color */
}

/* Ensure icons inside the username inherit the same color and remain visible */
.navbar .nav-link.user-name i {
    color: inherit !important;
}

/* Also ensure hover state for all screen sizes doesn't make text white */
.navbar .nav-link.user-name:hover,
.navbar .dropdown.show > .nav-link.user-name,
.navbar .nav-link.user-name:focus {
    color: #212529 !important;
    background: transparent !important;
}

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
        <c:choose>
          <c:when test="${user != null}">
            <!-- Combine username and dropdown into a single hoverable element on desktop -->
            <li class="nav-item dropdown">
              <!-- Use a button for dropdown toggle to avoid HTML navigation issues -->
              <button class="nav-link dropdown-toggle user-name btn btn-link" id="userDropdown" type="button" data-bs-toggle="dropdown" aria-expanded="false" aria-haspopup="true" style="text-decoration:none;">
                <i class="fas fa-user-circle"> </i>${user.fullName}
                
               <!-- <i class="fas fa-caret-down" style="font-size:0.85em; margin-left:4px;"> --> 
                
              
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