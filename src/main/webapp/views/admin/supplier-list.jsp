<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách nhà cung cấp</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/common/css/admin.css" />
</head>
<body>
<div class="container">
    <h1>Danh sách nhà cung cấp</h1>

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success">${sessionScope.message}</div>
        <c:remove var="message" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger">${sessionScope.error}</div>
        <c:remove var="error" scope="session" />
    </c:if>

    <p><a href="${pageContext.request.contextPath}/admin/supplier/add">Thêm nhà cung cấp mới</a></p>

    <table class="table table-striped">
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên</th>
                <th>Liên hệ</th>
                <th>Email</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="s" items="${suppliers}">
                <tr>
                    <td>${s.supplierId}</td>
                    <td>${s.name}</td>
                    <td>${s.contact}</td>
                    <td>${s.email}</td>
                    <td><c:choose>
                        <c:when test="${s.status}">Hoạt động</c:when>
                        <c:otherwise>Không hoạt động</c:otherwise>
                    </c:choose></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/supplier/edit?id=${s.supplierId}">Sửa</a> |
                        <a href="${pageContext.request.contextPath}/admin/supplier/delete?id=${s.supplierId}" onclick="return confirm('Bạn có chắc muốn xóa?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
