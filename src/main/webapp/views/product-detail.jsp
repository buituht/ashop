<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container">
    <div class="row">
        <div class="col-md-6">
            <c:if test="${product.image != null && product.image != ''}">
                <img src="${pageContext.request.contextPath}/${product.image}" class="img-fluid" alt="${product.productName}">
            </c:if>
        </div>
        <div class="col-md-6">
            <h2>${product.productName}</h2>
            <p>
                <strong><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" /> VNĐ</strong>
                <c:if test="${product.salePrice != null && product.salePrice.doubleValue() > 0}">
                    <br/><span class="text-danger"><fmt:formatNumber value="${product.salePrice}" type="number" maxFractionDigits="0" /> VNĐ (Sale)</span>
                </c:if>
            </p>
            <p>Số lượng: ${product.quantity}</p>
            <hr/>
            <div>${product.description}</div>
            <br/>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">Quay lại</a>
        </div>
    </div>
</div>
