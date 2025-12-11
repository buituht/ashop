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
                        <img src="${pageContext.request.contextPath}/${product.image}" class="card-img-top" alt="${product.productName}" style="height:180px;object-fit:cover;">
                    </c:if>
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">${product.productName}</h5>
                        <p class="card-text text-truncate">${product.shortDescription}</p>
                        <div class="mb-2">
                            <c:choose>
                                <c:when test="${product.salePrice != null && product.salePrice < product.price}">
                                    <span class="text-muted text-decoration-line-through me-2"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" /> VNĐ</span>
                                    <span class="text-danger fw-bold"><fmt:formatNumber value="${product.salePrice}" type="number" maxFractionDigits="0" /> VNĐ</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-primary fw-bold"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" /> VNĐ</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mt-auto d-flex justify-content-between align-items-center">
                            <a href="<c:url value='/product'><c:param name='id' value='${product.productId}'/></c:url>" class="btn btn-outline-primary btn-sm">Xem chi tiết</a>
                            <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-inline">
                                <input type="hidden" name="productId" value="${product.productId}" />
                                <input type="hidden" name="quantity" value="1" />
                                <button type="submit" class="btn btn-success btn-sm"><i class="fas fa-cart-plus"></i> Thêm vào giỏ</button>
                            </form>
                        </div>
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