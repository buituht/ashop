<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container mt-5 mb-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-lg">
                <div class="card-header bg-success text-white text-center">
                    <h4 class="mb-0">Đăng Ký Tài Khoản Mới</h4>
                </div>
                <div class="card-body p-4">
                    
                    <%-- Hiển thị thông báo LỖI từ Controller (ví dụ: Tên tài khoản đã tồn tại) --%>
                    <c:if test="${not empty requestScope.alert}">
                        <div class="alert alert-danger">${requestScope.alert}</div>
                    </c:if>
                    
                    <%-- Hiển thị thông báo LỖI HỆ THỐNG --%>
                    <c:if test="${not empty requestScope.errorMessage}">
                        <div class="alert alert-danger">${requestScope.errorMessage}</div>
                    </c:if>

                    <form action="<c:url value="/register"/>" method="post">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="username" class="form-label">Tên đăng nhập (*)</label>
                                <input type="text" class="form-control" id="username" name="username" required 
                                       placeholder="Tên đăng nhập" value="${param.username}">
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="password" class="form-label">Mật khẩu (*)</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="fullname" class="form-label">Họ và Tên</label>
                            <input type="text" class="form-control" id="fullname" name="fullname" 
                                   placeholder="Nguyễn Văn A" value="${param.fullname}">
                        </div>
                        
                        <div class="mb-3">
                            <label for="email" class="form-label">Email (*)</label>
                            <input type="email" class="form-control" id="email" name="email" required
                                   placeholder="example@mail.com" value="${param.email}">
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="phone" class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       placeholder="09xx.xxx.xxx" value="${param.phone}">
                            </div>

                            <div class="col-md-6 mb-3 d-none" >
                                <label for="roleid" class="form-label"></label>
                                <input type="text" class="form-control" id="roleid" name="roleid" value="2" readonly>
                            </div>
                            
                            <input type="hidden" name="avatar" value="default.png"> 
                        </div>

                        <hr>
                        
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success btn-lg">Đăng Ký</button>
                        </div>
                        
                        <p class="text-center mt-3 mb-0">
                            Đã có tài khoản? <a href="<c:url value="/login"/>">Đăng nhập ngay</a>
                        </p>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>