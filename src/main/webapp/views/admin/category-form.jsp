<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Xác định chế độ form --%>
<c:set var="isEdit" value="${category != null && category.categoryId != null}" />
<c:set var="formTitle" value="${isEdit ? 'Chỉnh sửa Danh mục' : 'Thêm mới Danh mục'}" />
<c:set var="formAction" value="${isEdit ? '/admin/category/edit' : '/admin/category/add'}" />

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
            
            <%-- Cần enctype="multipart/form-data" để xử lý file upload --%>
            <form action="<c:url value="${formAction}"/>" method="post" enctype="multipart/form-data">
                <c:if test="${isEdit}">
                    <input type="hidden" name="categoryId" value="${category.categoryId}">
                </c:if>

                <div class="mb-3">
                    <label for="categoryName" class="form-label">Tên Danh mục (*)</label>
                    <input type="text" class="form-control" id="categoryName" name="categoryName" value="${category.categoryName}" required>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Mô tả</label>
                    <textarea class="form-control" id="description" name="description" rows="3">${category.description}</textarea>
                </div>
                
                <div class="mb-3">
                    <label for="imageFile" class="form-label">Ảnh Đại diện (Poster)</label>
                    <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">
                    
                    <c:if test="${isEdit && category.image != null && category.image != ''}">
                        <p class="mt-2 mb-1">Ảnh hiện tại:</p>
                        <img src="${pageContext.request.contextPath}/${category.image}" 
                             alt="Current Image" class="img-thumbnail" style="max-width: 150px; height: auto;">
                        <input type="hidden" name="oldImage" value="${category.image}">
                    </c:if>
                </div>
                
                <div class="mb-4 form-check form-switch">
                    <input class="form-check-input" type="checkbox" id="status" name="status" value="true"
                        ${category.status || !isEdit ? 'checked' : ''}>
                    <label class="form-check-label" for="status">Danh mục đang Hoạt động (Hiển thị)</label>
                </div>

                <div class="d-flex justify-content-end">
                    <a href="<c:url value="/admin/categories"/>" class="btn btn-secondary me-2">
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