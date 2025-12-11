<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="container mt-4">
    <h3>Đổi mật khẩu</h3>
    <c:if test="${not empty message}">
        <div class="alert alert-danger">${message}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/account/changePassword" method="post">
        <div class="mb-2">
            <label>Mật khẩu hiện tại</label>
            <input class="form-control" type="password" name="currentPassword" />
        </div>
        <div class="mb-2">
            <label>Mật khẩu mới</label>
            <input class="form-control" type="password" name="newPassword" />
        </div>
        <div class="mb-2">
            <label>Xác nhận mật khẩu mới</label>
            <input class="form-control" type="password" name="confirmPassword" />
        </div>
        <button class="btn btn-primary" type="submit">Đổi mật khẩu</button>
        <a class="btn btn-light" href="${pageContext.request.contextPath}/account">Hủy</a>
    </form>
</div>
