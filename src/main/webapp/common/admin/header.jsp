<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- Font Awesome CDN for professional icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<c:set var="currentUser" value="${sessionScope.currentUser}" />

<style>
    /* Tighter, cleaner admin topbar */
    .admin-topbar {
        background: linear-gradient(90deg, #081224 0%, #0b1630 60%);
        color: #fff;
        box-shadow: 0 6px 18px rgba(2,6,23,0.55);
        border-bottom: 2px solid rgba(255,255,255,0.03);
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial;
    }

    .admin-topbar .container-fluid { padding-left: 1rem; padding-right: 1rem; }

    .admin-topbar .navbar-brand {
        font-weight: 700;
        letter-spacing: 0.6px;
        color: #ffd966 !important;
        display: flex; align-items: center;
        gap: .5rem;
        padding: .35rem .5rem;
    }

    .admin-topbar .brand-badge {
        background: linear-gradient(180deg,#ffd966,#ffb84d);
        color: #081224;
        font-weight: 800;
        width: 36px; height: 36px; display:inline-flex; align-items:center; justify-content:center;
        border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.25);
        font-size: 0.95rem;
    }

    .admin-topbar .nav-link {
        color: rgba(255,255,255,0.88) !important;
        font-weight: 600;
        padding: .5rem .6rem;
        font-size: .95rem;
        transition: all .12s ease-in-out;
        border-radius: 6px;
    }

    .admin-topbar .nav-link:hover { color: #ffd966 !important; transform: translateY(-1px); }

    .admin-topbar .nav-link.active {
        color: #081224 !important;
        background: linear-gradient(90deg,#ffd966,#ffcf7a);
        border-radius: 12px; padding-left: .9rem; padding-right: .9rem;
        box-shadow: 0 6px 14px rgba(0,0,0,0.18);
    }

    .admin-topbar .fa-lg { margin-right: .45rem; }

    .admin-topbar .badge-notify {
        background: #ff4d4f;
        color: #fff;
        font-weight: 700;
        border-radius: 999px;
        padding: 3px 7px;
        font-size: 0.70rem;
        position: relative;
        top: -12px;
        left: -8px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.25);
    }

    .admin-topbar .search-input { width: 220px; padding: .28rem .5rem; }

    /* Ensure toggler is visible on dark bg */
    .admin-topbar .navbar-toggler { border: none; }
    .admin-topbar .navbar-toggler-icon {
        width: 30px; height: 20px; display:inline-block; position: relative;
    }
    .admin-topbar .navbar-toggler-icon::before,
    .admin-topbar .navbar-toggler-icon::after,
    .admin-topbar .navbar-toggler-icon div {
        content: '';
        display: block;
        height: 2px; background: #fff; border-radius:2px; margin: 5px 0; transition: .15s;
    }

    @media (max-width: 768px) {
        .admin-topbar .search-input { width: 120px; }
        .admin-topbar .nav-link { padding: .45rem .45rem; font-size: .92rem; }
        .admin-topbar .brand-badge { width:32px; height:32px; }
    }
</style>

<nav class="navbar navbar-expand-lg admin-topbar py-1">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="brand-badge">AP</span>
            <span style="font-size:1rem;">ADMIN PANEL</span>
        </a>

        <button class="navbar-toggler text-white" type="button" data-bs-toggle="collapse" data-bs-target="#adminTopNav" aria-controls="adminTopNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"><div></div></span>
        </button>

        <div class="collapse navbar-collapse" id="adminTopNav">
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}" data-path="/admin/dashboard">
                        <i class="fas fa-home fa-lg"></i> Trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories" data-path="/admin/categories">
                        <i class="fas fa-list fa-lg"></i> Danh mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/products" data-path="/admin/products">
                        <i class="fas fa-box fa-lg"></i> Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/orders" data-path="/admin/orders">
                        <i class="fas fa-shopping-cart fa-lg"></i> Đơn hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/users" data-path="/admin/users">
                        <i class="fas fa-users fa-lg"></i> Người dùng
                    </a>
                </li>
            </ul>

            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item me-3 d-none d-md-block">
                    <form action="${pageContext.request.contextPath}/admin/search" method="get" class="d-flex align-items-center">
                        <input class="form-control form-control-sm search-input" type="search" name="q" placeholder="Tìm kiếm..." aria-label="Search">
                        <button class="btn btn-sm btn-outline-light ms-2" type="submit"><i class="fas fa-search"></i></button>
                    </form>
                </li>

                <li class="nav-item dropdown me-3">
                    <a class="nav-link position-relative" href="#" id="notifDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-bell fa-lg"></i>
                        <c:if test="${not empty sessionScope.notificationCount}">
                            <span class="badge-notify">${sessionScope.notificationCount}</span>
                        </c:if>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="notifDropdown">
                        <li class="dropdown-header">Thông báo</li>
                        <li><hr class="dropdown-divider"></li>
                        <c:if test="${not empty sessionScope.notifications}">
                            <c:forEach var="n" items="${sessionScope.notifications}">
                                <li><a class="dropdown-item" href="${n.link}">${n.message}</a></li>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty sessionScope.notifications}">
                            <li><span class="dropdown-item text-muted">Không có thông báo</span></li>
                        </c:if>
                    </ul>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user-circle fa-2x me-2"></i>
                        <div class="d-none d-lg-block text-start">
                            <div style="line-height:1; font-weight:700;"> <c:out value="${currentUser.fullName}"/> </div>
                            <div style="font-size:.8rem; color:rgba(255,255,255,.8);"> <c:out value="${currentUser.username}"/> </div>
                        </div>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userDropdown">
                        <li><h6 class="dropdown-header">Xin chào, <c:out value="${currentUser.fullName}"/>!</h6></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/profile"><i class="fas fa-user me-2"></i> Hồ sơ</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/settings"><i class="fas fa-cog me-2"></i> Cài đặt</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i> Đăng xuất</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<script>
    // Highlight active admin nav link based on current pathname (unchanged)
    (function(){
        try{
            var path = window.location.pathname || '';
            var navLinks = document.querySelectorAll('.admin-topbar .nav-link[data-path]');
            navLinks.forEach(function(a){
                var target = a.getAttribute('data-path');
                if(target && path.indexOf(target) === 0){
                    a.classList.add('active');
                }
            });
        }catch(e){ /* silent */ }
    })();
</script>