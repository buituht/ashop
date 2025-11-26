<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container">
    <h2>Sản phẩm</h2>
    <div class="row">
        <c:forEach var="product" items="${products}">
            <div class="col-md-3 mb-4">
                <div class="card h-100 shadow-sm">
                    <c:if test="${product.image != null && product.image != ''}">
                        <img src="${pageContext.request.contextPath}/${product.image}" class="card-img-top" alt="${product.productName}">
                    </c:if>
                    <div class="card-body">
                        <h5 class="card-title">${product.productName}</h5>
                        <p class="card-text">
                            <strong><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" /> VNĐ</strong>
                        </p>
                        <a href="<c:url value='/product'><c:param name='id' value='${product.productId}'/></c:url>" class="btn btn-primary">Xem chi tiết</a>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty products}">
            <div class="col-12 text-center">Không có sản phẩm nào.</div>
        </c:if>
    </div>

    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="<c:url value='/products'><c:param name='page' value='${currentPage - 1}'/></c:url>">&laquo;</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="<c:url value='/products'><c:param name='page' value='${i}'/></c:url>">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="<c:url value='/products'><c:param name='page' value='${currentPage + 1}'/></c:url>">&raquo;</a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>
