<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>




<!-- Desktop left nav (vertical menu) -->
<div class="col-sm-3 sidenav d-none d-md-block">
  <h4>Trang Admin</h4>
  <ul class="nav  admin-nav" aria-label="Admin navigation">
    <li><a   href="${pageContext.request.contextPath}/admin/dashboard?view=stats" data-title="Trang chính"><i class="fas fa-home icon me-2" aria-hidden="true"></i> Thống kê</a></li>
    <li ><a   href="${pageContext.request.contextPath}/admin/categories" data-title="Danh mục"><i class="fas fa-list icon me-2" aria-hidden="true"></i> Danh mục</a></li>
    <li><a   href="${pageContext.request.contextPath}/admin/products" data-title="Sản phẩm"><i class="fas fa-box-open icon me-2" aria-hidden="true"></i> Sản phẩm</a></li>
    <li ><a  href="${pageContext.request.contextPath}/admin/orders" data-title="Đơn hàng"><i class="fas fa-receipt icon me-2" aria-hidden="true"></i> Đơn hàng</a></li>
    <li><a   href="${pageContext.request.contextPath}/admin/users" data-title="Người dùng"><i class="fas fa-users icon me-2" aria-hidden="true"></i> Người dùng</a></li>
    <li ><a   href="${pageContext.request.contextPath}/admin/contacts" data-title="Liên hệ"><i class="fas fa-envelope icon me-2" aria-hidden="true"></i> Liên hệ</a></li>
    <li><a  href="${pageContext.request.contextPath}/admin/articles" data-title="Bài viết"><i class="fas fa-newspaper icon me-2" aria-hidden="true"></i> Bài viết</a></li>
    <li><a   href="${pageContext.request.contextPath}/admin/videos" data-title="Video"><i class="fas fa-video icon me-2" aria-hidden="true"></i> Video</a></li>
    <li><a   href="#" data-title="Cài đặt hệ thống"><i class="fas fa-cog icon me-2" aria-hidden="true"></i> Cài đặt hệ thống</a></li>
  </ul>
  <br>
  <div class="input-group">
    <input type="text" class="form-control" placeholder="Tìm kiếm.." aria-label="Tìm kiếm">
    <span class="input-group-text btn-search">
      <i class="fas fa-search" aria-hidden="true"></i>
    </span>
  </div>
</div>


