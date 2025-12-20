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
   


 

    <div class="d-flex flex-column flex-md-row justify-content-between align-items-center small">
      
      <div style="">
        <a href="#top" class="text-muted text-decoration-none me-3">Lên đầu trang</a>
       
      </div>
    </div>
  </div>

  <!-- Keep helper scripts only; do NOT include bootstrap bundle here (decorator handles it) -->
  <script>    // Back to top smooth behaviour    document.addEventListener('DOMContentLoaded', function(){      document.querySelectorAll('a[href="#top"]').forEach(function(a){        a.addEventListener('click', function(e){ e.preventDefault(); window.scrollTo({top:0, behavior:'smooth'}); });      });    });  </script>
</footer>