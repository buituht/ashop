<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <div class="col-sm-3 sidenav">
      <h4>Trang Admin</h4>
      <ul class="nav nav-pills nav-stacked">
        <li class="active"><a href="${pageContext.request.contextPath}/admin/home">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/admin/categories">Danh mục</a></li>
		<li><a href="${pageContext.request.contextPath}/admin/products">Sản phẩm</a></li>
		<li><a href="${pageContext.request.contextPath}/admin/orders">Đơn hàng</a></li>
		<li><a href="${pageContext.request.contextPath}/admin/users">Người dùng</a></li>
		<li><a href="${pageContext.request.contextPath}/admin/articles">Bài viết</a></li>
		<li><a href="${pageContext.request.contextPath}/admin/videos">Video</a></li>
		
		<li><a href="#">Cài đặt hệ thống</a></li>
      </ul><br>
      <div class="input-group">
        <input type="text" class="form-control" placeholder="Tìm kiếm..">
        <span class="input-group-btn">
          <button class="btn btn-default" type="button">
            <span class="glyphicon glyphicon-search"></span>
          </button>
        </span>
      </div>
</div>