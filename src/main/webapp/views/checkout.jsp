<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<div class="container">
    <h2>Đặt hàng</h2>
    <form action="${pageContext.request.contextPath}/checkout" method="post">
        <div class="mb-3">
            <label>Địa chỉ nhận hàng</label>
            <input type="text" name="shippingAddress" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Số điện thoại</label>
            <input type="text" name="phone" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Tên người nhận</label>
            <input type="text" name="receiverName" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Phương thức thanh toán</label>
            <select name="paymentMethod" class="form-control">
                <option value="COD">Thanh toán khi nhận hàng (COD)</option>
                <option value="BANK">Chuyển khoản ngân hàng</option>
            </select>
        </div>
        <div class="mb-3">
            <label>Ghi chú</label>
            <textarea name="note" class="form-control"></textarea>
        </div>
        <h4>Giỏ hàng</h4>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${cartItems}">
                    <c:choose>
                        <c:when test="${not empty item.cartId}">
                            <tr>
                                <td><img src="${pageContext.request.contextPath}/${item.product.image}" style="height:60px;"></td>
                                <td>${item.product.productName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty priceMap[item.cartId]}">
                                            <fmt:formatNumber value="${priceMap[item.cartId]}" type="number" maxFractionDigits="0" /> VNĐ
                                        </c:when>
                                        <c:otherwise>
                                            0 VNĐ
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${item.quantity}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty subtotalMap[item.cartId]}">
                                            <fmt:formatNumber value="${subtotalMap[item.cartId]}" type="number" maxFractionDigits="0" /> VNĐ
                                        </c:when>
                                        <c:otherwise>
                                            0 VNĐ
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="text-danger">Lỗi dữ liệu giỏ hàng!</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </tbody>
        </table>
        <button type="submit" class="btn btn-success">Đặt hàng</button>
    </form>
</div>