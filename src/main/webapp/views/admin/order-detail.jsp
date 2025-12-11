<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/common/admin/header.jsp" %>
<%@ include file="/common/admin/left.jsp" %>

<div class="admin-container">
  <main class="admin-main">
    <h3>Chi tiết đơn hàng #${order.orderId}</h3>
    <div class="card mt-3 p-3">
      <h5>Thông tin người nhận</h5>
      <p><strong>${order.receiverName}</strong></p>
      <p>${order.shippingAddress}</p>
      <p>Phone: ${order.phone}</p>
      <p>Payment: ${order.paymentMethod}</p>
      <p>Status: ${order.status}</p>
    </div>

    <div class="table-card mt-3">
      <h5>Sản phẩm</h5>
      <table class="table">
        <thead><tr><th>Ảnh</th><th>Tên</th><th>SL</th><th>Giá</th><th>Thành tiền</th></tr></thead>
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
      <div class="text-end mt-3">
        <h5>Tổng: <fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ</h5>
      </div>
    </div>

  </main>
</div>