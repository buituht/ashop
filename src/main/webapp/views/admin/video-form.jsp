<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Xác định chế độ form (Thêm mới hay Chỉnh sửa) --%>
<c:set var="isEdit" value="${video != null && video.id > 0}" />
<c:set var="formTitle" value="${isEdit ? 'Chỉnh sửa Video' : 'Thêm mới Video'}" />
<c:set var="formAction" value="${isEdit ? '/admin/video/edit' : '/admin/video/add'}" />

<%-- Thay đổi cấu trúc ngoài để sử dụng cột và tiêu đề đồng bộ --%>
<div class="col-sm-9">
    <h1><small>${formTitle}</small></h1>
    <hr/>

    <div class="card shadow">
        <div class="card-header bg-secondary text-white">
            <h5 class="mb-0">${formTitle}</h5>
        </div>
        <div class="card-body">
            
            <%-- Hiển thị thông báo (Message) --%>
            <c:if test="${sessionScope.message != null}">
                <div class="alert ${sessionScope.message.contains('Lỗi') ? 'alert-danger' : 'alert-success'} alert-dismissible fade show" role="alert">
                    ${sessionScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>

            <form action="<c:url value="${formAction}"/>" method="post" enctype="multipart/form-data">
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${video.id}">
                    <%-- Trường Views chỉ hiển thị, không cho sửa --%>
                    <input type="hidden" name="views" value="${video.views}">
                </c:if>
                
                <div class="row">
                    <div class="col-md-8 mb-3">
                        <label for="title" class="form-label">Tiêu đề Video (*)</label>
                        <input type="text" class="form-control" id="title" name="title" value="${video.title}" required>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label for="categoryId" class="form-label">Danh mục (*)</label>
                        <select class="form-select" id="categoryId" name="category.id" required>
                            <option value="">-- Chọn Danh mục --</option>
                            <%-- Giả định Controller đã đặt danh sách Categories vào scope với tên "categories" --%>
                            <c:forEach var="cate" items="${categories}">
                                <option value="${cate.id}" 
                                    ${isEdit && video.category.id == cate.id ? 'selected' : ''}>
                                    ${cate.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Mô tả</label>
                    <textarea class="form-control" id="description" name="description" rows="3">${video.description}</textarea>
                </div>
                
                <div class="mb-3">
                    <label for="posterFile" class="form-label">Poster (Ảnh đại diện)</label>
                    <input type="file" class="form-control" id="posterFile" name="posterFile">
                    
                    <c:if test="${isEdit && video.poster != null && video.poster != ''}">
                        <p class="mt-2 mb-1">Poster hiện tại:</p>
                        <img src="${pageContext.request.contextPath}/${video.poster}" 
                             alt="Current Poster" class="img-thumbnail" style="max-width: 150px; height: auto;">
                        <input type="hidden" name="poster" value="${video.poster}">
                    </c:if>
                </div>
                
                <div class="mb-4 form-check form-switch">
                    <input class="form-check-input" type="checkbox" id="active" name="active" value="true"
                        ${video.active ? 'checked' : ''}>
                    <label class="form-check-label" for="active">Video đang Hoạt động (Public)</label>
                    <%-- Nếu không check, đảm bảo giá trị 'false' được gửi đi --%>
                    <input type="hidden" name="_active" value="on"/> 
                </div>

                <div class="d-flex justify-content-end">
                    <a href="<c:url value="/admin/videos"/>" class="btn btn-secondary me-2">
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