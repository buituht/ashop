<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<div class="container">
    <h2>Liên hệ (Quản trị)</h2>
    <c:if test="${not empty contacts}">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên</th>
                    <th>Email</th>
                    <th>Tiêu đề</th>
                    <th>Ngày</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="c" items="${contacts}">
                    <tr>
                        <td>${c.contactId}</td>
                        <td>${c.name}</td>
                        <td>${c.email}</td>
                        <td>${c.subject}</td>
                        <td><fmt:formatDate value="${c.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/contacts/delete?id=${c.contactId}" class="btn btn-danger btn-sm" onclick="return confirm('Xác nhận xóa?')">Xóa</a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6">${c.message}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty contacts}">
        <div class="alert alert-info">Chưa có liên hệ nào.</div>
    </c:if>
</div>