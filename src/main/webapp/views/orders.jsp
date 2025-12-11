<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<div class="container">
    <h2>Đơn hàng của tôi</h2>
    <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
    </c:if>
    <c:choose>
        <c:when test="${not empty orders}">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Ngày</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>${o.orderId}</td>
                            <td>${o.orderDateStr}</td>
                            <td><fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ</td>
                            <td>${o.status}</td>
                            <td>
                                <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/orders/view?id=${o.orderId}">Xem</a>
                                <c:if test="${o.status == 'PENDING'}">
                                    <form action="${pageContext.request.contextPath}/orders/cancel" method="post" style="display:inline-block;margin-left:.5rem;">
                                        <input type="hidden" name="id" value="${o.orderId}"/>
                                        <button class="btn btn-sm btn-danger" type="submit" onclick="return confirm('Bạn có chắc muốn hủy đơn hàng #${o.orderId}?');">Hủy</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info">Bạn chưa có đơn hàng nào.</div>
        </c:otherwise>
    </c:choose>
</div>