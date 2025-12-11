<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container mt-4">
    <a href="${pageContext.request.contextPath}/orders" class="btn btn-light mb-3">&larr; Quay lại danh sách đơn hàng</a>

    <div class="card p-3">
        <h4>Chi tiết đơn hàng #${order.orderId}</h4>
        <div class="row mt-2">
            <div class="col-md-6">
                <h6>Người nhận</h6>
                <p><strong>${order.receiverName}</strong></p>
                <p>${order.shippingAddress}</p>
                <p>Phone: ${order.phone}</p>
                <p>Phương thức: ${order.paymentMethod}</p>
            </div>
            <div class="col-md-6 text-end">
                <p>Ngày: ${order.orderDateStr}</p>
                <p>Trạng thái: <strong>${order.status}</strong></p>
                <p>Tổng: <strong><fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ</strong></p>
            </div>
        </div>

        <h5 class="mt-3">Sản phẩm</h5>
        <table class="table">
            <thead>
                <tr><th>Ảnh</th><th>Tên</th><th>SL</th><th>Giá</th><th>Thành tiền</th></tr>
            </thead>
            <tbody>
                <c:forEach var="d" items="${order.orderDetails}">
                    <tr>
                        <td><img src="${pageContext.request.contextPath}/${d.product.image}" style="height:48px;"/></td>
                        <td>${d.product.productName}</td>
                        <td>${d.quantity}</td>
                        <td><fmt:formatNumber value="${d.price}" type="number" maxFractionDigits="0"/> VNĐ</td>
                        <td><fmt:formatNumber value="${d.subtotal}" type="number" maxFractionDigits="0"/> VNĐ</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="text-end">
            <c:if test="${order.status == 'PENDING'}">
                <form action="${pageContext.request.contextPath}/orders/cancel" method="post" style="display:inline-block;">
                    <input type="hidden" name="id" value="${order.orderId}"/>
                    <button class="btn btn-danger" type="submit" onclick="return confirm('Bạn có muốn hủy đơn hàng #${order.orderId}?');">Hủy đơn</button>
                </form>
            </c:if>
        </div>
    </div>
</div>