<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-4">
            <div class="card shadow">
                <div class="card-header bg-primary text-white text-center">
                    <h5>Đăng Nhập Hệ Thống</h5>
                </div>
                <div class="card-body">
                    
                    <%-- Hiển thị thông báo LỖI --%>
                    <c:if test="${not empty requestScope.error}">
                        <div class="alert alert-danger">${requestScope.error}</div>
                    </c:if>
                    
                    <%-- Form Đăng Nhập --%>
                    <form action="<c:url value="/login"/>" method="post">
                        
                        <div class="mb-3">
                            <label for="username" class="form-label">Tên đăng nhập:</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="password" class="form-label">Mật khẩu:</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe" value="on">
                            <label class="form-check-label" for="rememberMe">Ghi nhớ đăng nhập</label>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success">Đăng Nhập</button>
                            <a href="<c:url value="/register"/>" class="btn btn-outline-secondary">Đăng Ký Tài Khoản Mới</a>
                        </div>
                        
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>