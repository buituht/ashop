<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
/* Footer-specific color overrides so text is readable on dark/black background */
.site-footer {
  background: #333 !important; /* updated to #333 for consistency */
  color: #f8f9fa !important; /* light text color */
}
.site-footer .text-muted {
  color: rgba(255,255,255,0.72) !important; /* slightly muted but readable */
}
.site-footer a, .site-footer a.text-muted, .site-footer .link-muted {
  color: #f1f3f5 !important; /* links visible */
}
.site-footer a:hover {
  color: #ffffff !important;
  text-decoration: underline;
}
/* Inputs inside footer: light text on dim background for contrast */
.site-footer .form-control {
  background: rgba(255,255,255,0.04) !important;
  color: #fff !important;
  border-color: rgba(255,255,255,0.12) !important;
}
.site-footer .form-control::placeholder {
  color: rgba(255,255,255,0.6) !important;
}
.site-footer .btn-primary {
  background-color: #0d6efd !important;
  border-color: #0d6efd !important;
}
/* Ensure social/payment icons have enough contrast */
.site-footer .social-links a { color: #f8f9fa !important; }
.site-footer .payment-icons { color: rgba(255,255,255,0.85) !important; }
</style>

<footer class="site-footer bg-dark text-light pt-5 pb-3" aria-labelledby="footerHeading">
  <div class="container">
    <h2 id="footerHeading" class="visually-hidden">AShop Footer</h2>
    <div class="row gy-4">
      <!-- Brand / About -->
      <div class="col-12 col-md-4">
        <a href="${pageContext.request.contextPath}/" class="d-inline-flex align-items-center text-decoration-none mb-3">
          <!-- optional logo, fallback to text if image missing -->
          <img src="${pageContext.request.contextPath}/assets/img/logo-footer.png" alt="AShop" onerror="this.style.display='none'" style="height:40px; margin-right:8px;" />
          <span class="h5 mb-0 text-white fw-bold">AShop</span>
        </a>
        <p class="small text-muted">Sản phẩm chất lượng, dịch vụ tận tâm. Giao hàng nhanh, đổi trả dễ dàng — mua sắm an tâm tại AShop.</p>
        <ul class="list-unstyled small text-muted mb-0">
          <li><i class="fas fa-map-marker-alt me-2" aria-hidden="true"></i>123 Đường A, Quận B, TP. C</li>
          <li><i class="fas fa-phone me-2" aria-hidden="true"></i><a href="tel:0123456789" class="link-muted text-decoration-none">0123 456 789</a></li>
          <li><i class="fas fa-envelope me-2" aria-hidden="true"></i><a href="mailto:support@ashop.example" class="link-muted text-decoration-none">support@ashop.example</a></li>
        </ul>
      </div>

      <!-- Quick links -->
      <div class="col-6 col-md-2">
        <h6 class="text-white">Khám phá</h6>
        <ul class="list-unstyled">
          <li><a href="${pageContext.request.contextPath}/" class="text-muted text-decoration-none">Trang chủ</a></li>
          <li><a href="${pageContext.request.contextPath}/products" class="text-muted text-decoration-none">Sản phẩm</a></li>
          <li><a href="${pageContext.request.contextPath}/about" class="text-muted text-decoration-none">Giới thiệu</a></li>
          <li><a href="${pageContext.request.contextPath}/contact" class="text-muted text-decoration-none">Liên hệ</a></li>
        </ul>
      </div>

      <!-- Support -->
      <div class="col-6 col-md-2">
        <h6 class="text-white">Hỗ trợ</h6>
        <ul class="list-unstyled">
          <li><a href="${pageContext.request.contextPath}/faq" class="text-muted text-decoration-none">FAQ</a></li>
          <li><a href="${pageContext.request.contextPath}/shipping" class="text-muted text-decoration-none">Giao hàng & trả hàng</a></li>
          <li><a href="${pageContext.request.contextPath}/terms" class="text-muted text-decoration-none">Điều khoản</a></li>
          <li><a href="${pageContext.request.contextPath}/privacy" class="text-muted text-decoration-none">Quyền riêng tư</a></li>
        </ul>
      </div>

      <!-- Newsletter & Social -->
      <div class="col-12 col-md-4">
        <h6 class="text-white">Đăng ký nhận tin</h6>
        <p class="small text-muted">Nhận mã giảm giá và tin tức sản phẩm mới nhất trực tiếp vào email của bạn.</p>

        <form id="newsletterForm" class="d-flex mb-2" onsubmit="return handleNewsletterSubmit(event);" novalidate>
          <input type="email" id="newsletterEmail" name="newsletterEmail" class="form-control me-2" placeholder="Email của bạn" aria-label="Email" required>
          <button class="btn btn-primary" type="submit">Đăng ký</button>
        </form>
        <div id="newsletterFeedback" class="alert alert-success d-none p-2" role="status" aria-live="polite"></div>

        <div class="mt-3 d-flex align-items-center gap-3">
          <div class="social-links" aria-label="Mạng xã hội">
            <a href="#" class="text-light me-2" aria-label="Facebook" title="Facebook"><i class="fab fa-facebook fa-lg"></i></a>
            <a href="#" class="text-light me-2" aria-label="Instagram" title="Instagram"><i class="fab fa-instagram fa-lg"></i></a>
            <a href="#" class="text-light me-2" aria-label="YouTube" title="YouTube"><i class="fab fa-youtube fa-lg"></i></a>
            <a href="#" class="text-light" aria-label="LinkedIn" title="LinkedIn"><i class="fab fa-linkedin fa-lg"></i></a>
          </div>
          <div class="payment-icons text-muted" aria-hidden="true">
            <i class="fab fa-cc-visa fa-2x me-2"></i>
            <i class="fab fa-cc-mastercard fa-2x me-2"></i>
            <i class="fab fa-cc-paypal fa-2x"></i>
          </div>
        </div>
      </div>
    </div>

    <hr class="border-secondary mt-4">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center small">      <div class="text-muted">&copy; <%= java.time.Year.now().getValue() %> AShop. Bảo lưu mọi quyền.</div>      <div>        <a href="#top" class="text-muted text-decoration-none me-3">Lên đầu trang</a>        <a href="${pageContext.request.contextPath}/contact" class="text-muted text-decoration-none">Hỗ trợ</a>      </div>    </div>  </div>

  <!-- Scripts: keep lightweight helper scripts here. Do NOT include Bootstrap JS again (already included by page decorator). -->
  <script>    // Newsletter submit handler: show inline success message and use mailto fallback.    function handleNewsletterSubmit(e) {      e.preventDefault();      var email = document.getElementById('newsletterEmail').value;      var feedback = document.getElementById('newsletterFeedback');      if (!email) {        feedback.className = 'alert alert-danger p-2';        feedback.textContent = 'Vui lòng nhập email hợp lệ.';        feedback.classList.remove('d-none');        return false;      }      // Simulate success (replace with real AJAX call to backend if available)      feedback.className = 'alert alert-success p-2';      feedback.textContent = 'Cảm ơn! Email của bạn đã được ghi nhận.';      feedback.classList.remove('d-none');      // Hide after 4s      setTimeout(function(){ feedback.classList.add('d-none'); }, 4000);      // Optionally fallback to mailto if no backend exists (commented)      // window.location.href = 'mailto:support@ashop.example?subject=' + encodeURIComponent('Đăng ký nhận tin') + '&body=' + encodeURIComponent(email);      return false;    }
    // Smooth scroll to top for links to #top (defensive: attach only if available)    (function(){      try {        document.querySelectorAll('a[href="#top"]').forEach(function(a){          a.addEventListener('click', function(ev){ ev.preventDefault(); window.scrollTo({top:0, behavior:'smooth'}); });        });      } catch (err) { /* ignore */ }    })();  </script>
</footer>