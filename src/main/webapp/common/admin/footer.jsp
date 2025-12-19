<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
/* Scoped footer styles for admin area (kept minimal and specific) */
.admin-footer {
  background: #333;
  color: #f8f9fa;
}
.admin-footer a { color: #dfe6ee; }
.admin-footer a:hover { color: #ffffff; text-decoration: underline; }
.admin-footer .text-muted { color: rgba(255,255,255,0.72); }
.admin-footer .small { color: rgba(255,255,255,0.78); }
.admin-footer .form-control { background: rgba(255,255,255,0.03); color: #fff; border-color: rgba(255,255,255,0.08); }
.admin-footer .form-control::placeholder { color: rgba(255,255,255,0.5); }
.admin-footer .footer-logo { height:36px; margin-right:10px; }
.admin-footer .social-icons a { color: #f1f3f5; margin-right: .6rem; }
@media (max-width: 575px) {
  .admin-footer .col-quick, .admin-footer .col-admin { margin-top: 1rem; }
}
</style>

<footer class="admin-footer site-footer pt-4 pb-3" role="contentinfo" aria-labelledby="adminFooterTitle">
  <div class="container">
    <h2 id="adminFooterTitle" class="visually-hidden">Admin footer</h2>
    <div class="row gy-4">
      <!-- About / Brand -->
      <div class="col-12 col-md-4">
        <div class="d-flex align-items-center mb-2">
          <img src="${pageContext.request.contextPath}/assets/img/logo-footer.png" alt="AShop" class="footer-logo" onerror="this.style.display='none'" />
          <span class="h6 mb-0 text-white fw-bold">AShop Admin</span>
        </div>
        <p class="small text-muted mb-2">Bảng quản trị AShop — quản lý sản phẩm, đơn hàng và nội dung website. Truy cập an toàn và theo dõi hoạt động hệ thống.</p>
        <ul class="list-unstyled small mb-0 text-muted">
          <li><i class="fas fa-map-marker-alt me-2" aria-hidden="true"></i>123 Đường A, Quận B</li>
          <li><i class="fas fa-clock me-2" aria-hidden="true"></i>Giờ hỗ trợ: 9:00 - 18:00</li>
        </ul>
      </div>

      <!-- Quick links (site) -->
      <div class="col-6 col-md-2 col-quick">
        <h6 class="text-white">Khám phá</h6>
        <ul class="list-unstyled">
          <li><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Trang chủ</a></li>
          <li><a href="${pageContext.request.contextPath}/products" class="text-decoration-none">Sản phẩm</a></li>
          <li><a href="${pageContext.request.contextPath}/orders" class="text-decoration-none">Đơn hàng</a></li>
          <li><a href="${pageContext.request.contextPath}/reports" class="text-decoration-none">Báo cáo</a></li>
        </ul>
      </div>

      <!-- Admin links -->
      <div class="col-6 col-md-2 col-admin">
        <h6 class="text-white">Quản trị</h6>
        <ul class="list-unstyled">
          <li><a href="${pageContext.request.contextPath}/admin/products" class="text-decoration-none">Sản phẩm</a></li>
          <li><a href="${pageContext.request.contextPath}/admin/categories" class="text-decoration-none">Danh mục</a></li>
          <li><a href="${pageContext.request.contextPath}/admin/users" class="text-decoration-none">Người dùng</a></li>
          <li><a href="${pageContext.request.contextPath}/admin/settings" class="text-decoration-none">Cấu hình</a></li>
        </ul>
      </div>

      <!-- Support & Tools -->
      <div class="col-12 col-md-4">
        <h6 class="text-white">Hỗ trợ & Công cụ</h6>
        <p class="small text-muted">Tài liệu nội bộ, hỗ trợ kỹ thuật và các liên kết nhanh cho quản trị viên.</p>
        <ul class="list-unstyled">
          <li><a href="${pageContext.request.contextPath}/admin/docs" class="text-decoration-none">Tài liệu hướng dẫn</a></li>
          <li><a href="${pageContext.request.contextPath}/admin/logs" class="text-decoration-none">Xem logs</a></li>
          <li><a href="${pageContext.request.contextPath}/admin/backup" class="text-decoration-none">Sao lưu & Khôi phục</a></li>
        </ul>

        <div class="mt-3 d-flex align-items-center">
          <div class="social-icons me-3" aria-hidden="true">
            <a href="#" title="Facebook" aria-label="Facebook"><i class="fab fa-facebook fa-lg"></i></a>
            <a href="#" title="LinkedIn" aria-label="LinkedIn"><i class="fab fa-linkedin fa-lg"></i></a>
          </div>
          <div class="ms-auto small text-muted">&copy; <%= java.time.Year.now().getValue() %> AShop</div>
        </div>
      </div>
    </div>

    <hr class="border-secondary mt-4">

    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center small">
      <div class="text-muted">AShop &middot; Bản quyền &nbsp;|&nbsp; <a href="${pageContext.request.contextPath}/privacy" class="text-muted">Quyền riêng tư</a></div>
      <div>
        <a href="#top" class="text-muted text-decoration-none me-3">Lên đầu trang</a>
        <a href="${pageContext.request.contextPath}/contact" class="text-muted text-decoration-none">Liên hệ</a>
      </div>
    </div>
  </div>

  <!-- Keep helper scripts only; do NOT include bootstrap bundle here (decorator handles it) -->
  <script>    // Back to top smooth behaviour    document.addEventListener('DOMContentLoaded', function(){      document.querySelectorAll('a[href="#top"]').forEach(function(a){        a.addEventListener('click', function(e){ e.preventDefault(); window.scrollTo({top:0, behavior:'smooth'}); });      });    });  </script>
</footer>