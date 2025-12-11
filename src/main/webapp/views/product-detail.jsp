<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<div class="container">
    <c:choose>
        <c:when test="${product != null}">
            <div class="row">
                <div class="col-md-6">
                    <c:if test="${product.image != null && product.image != ''}">
                        <img src="${pageContext.request.contextPath}/${product.image}" class="img-fluid rounded-3 shadow" alt="${product.productName}">
                    </c:if>
                </div>
                <div class="col-md-6">
                    <h2 class="fw-bold mb-2">${product.productName}</h2>
                    <div class="mb-2">
                        <c:choose>
                            <c:when test="${product.salePrice != null && product.salePrice.doubleValue() > 0 && product.salePrice.doubleValue() < product.price.doubleValue()}">
                                <span class="text-muted text-decoration-line-through me-2"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" /> VNĐ</span>
                                <span class="text-danger fw-bold"><fmt:formatNumber value="${product.salePrice}" type="number" maxFractionDigits="0" /> VNĐ</span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-primary fw-bold"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" /> VNĐ</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <p class="mb-2">Số lượng còn: <span class="fw-bold">${product.quantity}</span></p>
                    <p class="mb-2 text-secondary">${product.description}</p>
                    <form action="${pageContext.request.contextPath}/cart/add" method="post" class="mb-3">
                        <input type="hidden" name="productId" value="${product.productId}" />
                        <input type="number" name="quantity" value="1" min="1" max="${product.quantity}" class="form-control mb-2" style="width:100px;display:inline-block;">
                        <button type="submit" class="btn btn-success"><i class="fas fa-cart-plus"></i> Thêm vào giỏ hàng</button>
                    </form>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">Quay lại</a>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-danger mt-4">Không tìm thấy sản phẩm hoặc sản phẩm không tồn tại.</div>
        </c:otherwise>
    </c:choose>
</div>