<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="col-sm-9">
    <h1><small>Danh sách Sản phẩm</small></h1>
    <hr/>
    
    <c:if test="${sessionScope.message != null}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <p>
        <a href="<c:url value="/admin/product/add"/>" class="btn btn-primary mb-3">
            <i class="bi bi-plus-circle"></i> Thêm Sản phẩm mới
        </a>
    </p>
    <br/>
    
    <div class="table-responsive">
        <table class="table table-bordered table-striped table-hover shadow-sm">
            <thead class="table-dark">
                <tr>
                    <th style="width: 5%;">ID</th>
                    <th style="width: 15%;">Ảnh</th>
                    <th style="width: 25%;">Tên Sản phẩm</th>
                    <th style="width: 15%;">Danh mục</th>
                    <th style="width: 15%;">Giá</th>
                    <th style="width: 5%;">SL</th>
                    <th style="width: 10%;">Trạng thái</th>
                    <th class="text-center" style="width: 10%;">Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td>${product.productId}</td>
                        <td>
                            <c:if test="${product.image != null && product.image != ''}">
                                <img src="${pageContext.request.contextPath}/${product.image}" 
                                     alt="${product.productName}" class="img-thumbnail" style="max-width: 60px; height: auto;">
                            </c:if>
                        </td>
                        <td>${product.productName}</td>
                        <td>${product.category.categoryName}</td>
                        <td>
                            <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" /> VNĐ
                            <c:if test="${product.salePrice.intValue() > 0}">
                                <br/> <span class="text-danger"><fmt:formatNumber value="${product.salePrice}" type="number" maxFractionDigits="0" /> VNĐ (Sale)</span>
                            </c:if>
                        </td>
                        <td>${product.quantity}</td>
                        <td>
                            <span class="badge ${product.status ? 'bg-success' : 'bg-warning'}">
                                ${product.status ? 'Đang bán' : 'Ngừng bán'}
                            </span>
                        </td>
                        <td class="text-center">
                            <a href="<c:url value="/admin/product/edit?id=${product.productId}"/>" class="btn btn-sm btn-primary me-2" title="Chỉnh sửa">
                                <i class="fas fa-edit"></i>
                            </a>
                            <button onclick="confirmDelete(${product.productId}, '${product.productName}')" class="btn btn-sm btn-danger" title="Khóa/Ẩn sản phẩm">
                                <i class="fas fa-eye-slash"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty products}">
                    <tr>
                        <td colspan="8" class="text-center">Không tìm thấy sản phẩm nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <%-- Logic phân trang --%>
    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="<c:url value="/admin/products"><c:param name="page" value="${currentPage - 1}"/></c:url>" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="<c:url value="/admin/products"><c:param name="page" value="${i}"/></c:url>">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="<c:url value="/admin/products"><c:param name="page" value="${currentPage + 1}"/></c:url>" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<%-- Script Xóa (Soft Delete) --%>
<form id="deleteForm" action="<c:url value="/admin/product/delete"/>" method="post" style="display: none;">
    <input type="hidden" name="id" id="productIdToDelete">
</form>

<script>
    function confirmDelete(id, name) {
        if (confirm('Bạn có chắc chắn muốn ẨN/NGỪNG BÁN sản phẩm "' + name + '" không?')) {
            document.getElementById('productIdToDelete').value = id;
            document.getElementById('deleteForm').submit();
        }
    }
</script>