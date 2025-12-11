<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<footer class="site-footer pt-5 pb-3">
  <div class="container">
    <div class="row gy-4">
      <!-- About -->
      <div class="col-md-4">
        <h5 class="mb-3">AShop</h5>
        <p class="small text-muted">Cung cấp sản phẩm chất lượng với dịch vụ tận tâm. Theo dõi chúng tôi để nhận nhiều ưu đãi và tin tức mới nhất.</p>
        <ul class="list-unstyled small">
          <li><i class="fas fa-map-marker-alt me-2"></i>123 Đường A, Quận B, Thành phố C</li>
          <li><i class="fas fa-phone me-2"></i><a href="tel:0123456789" class="text-light">0123 456 789</a></li>
          <li><i class="fas fa-envelope me-2"></i><a href="mailto:support@ashop.example" class="text-light">support@ashop.example</a></li>
        </ul>
      </div>

      <!-- Quick links -->
      <div class="col-6 col-md-2">
        <h6>Khám phá</h6>
        <ul class="list-unstyled">
          <li><a href="${pageContext.request.contextPath}/" class="text-muted text-decoration-none">Trang chủ</a></li>
          <li><a href="${pageContext.request.contextPath}/products" class="text-muted text-decoration-none">Sản phẩm</a></li>
          <li><a href="${pageContext.request.contextPath}/about" class="text-muted text-decoration-none">Giới thiệu</a></li>
          <li><a href="${pageContext.request.contextPath}/contact" class="text-muted text-decoration-none">Liên hệ</a></li>
        </ul>
      </div>

      <!-- Support -->
      <div class="col-6 col-md-2">
        <h6>Hỗ trợ</h6>
        <ul class="list-unstyled">
          <li><a href="${pageContext.request.contextPath}/faq" class="text-muted text-decoration-none">FAQ</a></li>
          <li><a href="${pageContext.request.contextPath}/shipping" class="text-muted text-decoration-none">Giao hàng & trả hàng</a></li>
          <li><a href="${pageContext.request.contextPath}/terms" class="text-muted text-decoration-none">Điều khoản</a></li>
          <li><a href="${pageContext.request.contextPath}/privacy" class="text-muted text-decoration-none">Quyền riêng tư</a></li>
        </ul>
      </div>

      <!-- Newsletter & Social -->
      <div class="col-md-4">
        <h6>Nhận tin khuyến mãi</h6>
        <p class="small text-muted">Đăng ký nhận thông tin khuyến mãi và tin mới.</p>
        <form class="d-flex mb-2" onsubmit="return subscribeByMail(this);">
          <input type="email" name="newsletterEmail" class="form-control me-2" placeholder="Email của bạn" required>
          <button class="btn btn-primary" type="submit">Đăng ký</button>
        </form>
        <div class="mt-3">
          <a href="#" class="text-light me-3" aria-label="Facebook" title="Facebook"><i class="fab fa-facebook fa-lg"></i></a>
          <a href="#" class="text-light me-3" aria-label="Instagram" title="Instagram"><i class="fab fa-instagram fa-lg"></i></a>
          <a href="#" class="text-light me-3" aria-label="YouTube" title="YouTube"><i class="fab fa-youtube fa-lg"></i></a>
          <a href="#" class="text-light" aria-label="LinkedIn" title="LinkedIn"><i class="fab fa-linkedin fa-lg"></i></a>
        </div>
      </div>
    </div>

    <hr class="border-secondary mt-4">

    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center small">
      <div class="text-muted">&copy; <%= java.time.Year.now().getValue() %> AShop. Bảo lưu mọi quyền.</div>
      <div>
        <a href="#top" class="text-muted text-decoration-none me-3">Lên đầu trang</a>
        <a href="${pageContext.request.contextPath}/contact" class="text-muted text-decoration-none">Hỗ trợ</a>
      </div>
    </div>
  </div>

  <!-- Optional: include Bootstrap JS if layout doesn't already include it -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
    crossorigin="anonymous"></script>

  <script>
    // newsletter fallback: open default mail client with subject
    function subscribeByMail(form) {
      var email = form.newsletterEmail.value;
      if (!email) return false;
      var subject = encodeURIComponent('Đăng ký nhận tin từ AShop');
      var body = encodeURIComponent('Vui lòng đăng ký email này: ' + email);
      window.location.href = 'mailto:support@ashop.example?subject=' + subject + '&body=' + body;
      return false; // prevent actual submission
    }

    // Back to top smooth
    document.addEventListener('DOMContentLoaded', function(){
      document.querySelectorAll('a[href="#top"]').forEach(function(a){
        a.addEventListener('click', function(e){
          e.preventDefault(); window.scrollTo({top:0, behavior:'smooth'});
        });
      });
    });
  </script>
  
</footer>