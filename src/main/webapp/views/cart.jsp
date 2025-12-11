<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<div class="container">
    <h2>Giỏ hàng của bạn</h2>
    <c:choose>
        <c:when test="${not empty cartItems}">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cartItems}">
                        <c:set var="price" value="${item.product.salePrice != null && item.product.salePrice > 0 ? item.product.salePrice : item.product.price}" />
                        <c:set var="subtotal" value="${price.doubleValue() * item.quantity}" />
                        <tr>
                            <td><img src="${pageContext.request.contextPath}/${item.product.image}" style="height:60px;"></td>
                            <td>${item.product.productName}</td>
                            <td><fmt:formatNumber value="${price}" type="number" maxFractionDigits="0" /> VNĐ</td>
                            <td>${item.quantity}</td>
                            <td><fmt:formatNumber value="${subtotal}" type="number" maxFractionDigits="0" /> VNĐ</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                                    <input type="hidden" name="cartId" value="${item.cartId}" />
                                    <button type="submit" class="btn btn-danger btn-sm"><i class="fas fa-trash"></i> Xóa</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-success">Tiến hành đặt hàng</a>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info">Giỏ hàng của bạn đang trống.</div>
        </c:otherwise>
    </c:choose>
</div>