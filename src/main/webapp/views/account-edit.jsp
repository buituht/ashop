<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="container mt-4">
    <h3>Chỉnh sửa thông tin</h3>
    <form action="${pageContext.request.contextPath}/account/edit" method="post">
        <div class="mb-2">
            <label>Họ tên</label>
            <input class="form-control" name="fullName" value="${user.fullName}" />
        </div>
        <div class="mb-2">
            <label>Email</label>
            <input class="form-control" name="email" value="${user.email}" />
        </div>
        <div class="mb-2">
            <label>Phone</label>
            <input class="form-control" name="phone" value="${user.phone}" />
        </div>
        <div class="mb-2">
            <label>Địa chỉ</label>
            <textarea class="form-control" name="address">${user.address}</textarea>
        </div>
        <button class="btn btn-primary" type="submit">Lưu</button>
        <a class="btn btn-light" href="${pageContext.request.contextPath}/account">Hủy</a>
    </form>
</div>
