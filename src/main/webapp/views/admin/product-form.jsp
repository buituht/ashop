<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- Xác định chế độ form --%>
<c:set var="isEdit" value="${product != null && product.productId != null}" />
<c:set var="formTitle" value="${isEdit ? 'Chỉnh sửa Sản phẩm' : 'Thêm mới Sản phẩm'}" />
<c:set var="formAction" value="${isEdit ? '/admin/product/edit' : '/admin/product/add'}" />

<div class="col-sm-9">
    <h1><small>${formTitle}</small></h1>
    <hr/>

    <div class="card shadow">
        <div class="card-header bg-secondary text-white">
            <h5 class="mb-0">${formTitle}</h5>
        </div>
        <div class="card-body">
            
            <%-- Hiển thị thông báo LỖI --%>
            <c:if test="${requestScope.error != null}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${requestScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <form action="<c:url value="${formAction}"/>" method="post" enctype="multipart/form-data">
                <c:if test="${isEdit}">
                    <input type="hidden" name="productId" value="${product.productId}">
                </c:if>

                <div class="row">
                    <div class="col-md-9 mb-3">
                        <label for="productName" class="form-label">Tên Sản phẩm (*)</label>
                        <input type="text" class="form-control" id="productName" name="productName" value="${product.productName}" required>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="categoryId" class="form-label">Danh mục (*)</label>
                        <select class="form-select" id="categoryId" name="categoryId" required>
                            <option value="">-- Chọn --</option>
                            <c:forEach var="cate" items="${categories}">
                                <option value="${cate.categoryId}" 
                                    ${product.category.categoryId == cate.categoryId ? 'selected' : ''}>
                                    ${cate.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="price" class="form-label">Giá bán gốc (*)</label>
                        <input type="number" step="0.01" min="0" class="form-control" id="price" name="price" value="${product.price}" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="salePrice" class="form-label">Giá khuyến mãi</label>
                        <input type="number" step="0.01" min="0" class="form-control" id="salePrice" name="salePrice" value="${product.salePrice}">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="quantity" class="form-label">Số lượng tồn (*)</label>
                        <input type="number" min="0" class="form-control" id="quantity" name="quantity" value="${product.quantity}" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="description" class="form-label">Mô tả Sản phẩm</label>
                    <textarea class="form-control" id="description" name="description" rows="5">${product.description}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-8 mb-3">
                        <label for="imageFile" class="form-label">Ảnh Sản phẩm chính</label>
                        <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*" ${isEdit ? '' : 'required'}>
                        
                        <c:if test="${isEdit && product.image != null && product.image != ''}">
                            <p class="mt-2 mb-1">Ảnh hiện tại:</p>
                            <img src="${pageContext.request.contextPath}/${product.image}" 
                                 alt="Current Image" class="img-thumbnail" style="max-width: 150px; height: auto;">
                            <input type="hidden" name="oldImage" value="${product.image}">
                        </c:if>
                    </div>
                    <div class="col-md-4 mb-3 d-flex align-items-end">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="status" name="status" value="true"
                                ${product.status || !isEdit ? 'checked' : ''}>
                            <label class="form-check-label" for="status">Trạng thái: Đang bán (Active)</label>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end mt-4">
                    <a href="<c:url value="/admin/products"/>" class="btn btn-secondary me-2">
                        <i class="fas fa-times-circle"></i> Hủy bỏ
                    </a>
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save"></i> ${isEdit ? 'Cập nhật' : 'Thêm mới'}
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>