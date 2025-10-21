<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Xác định chế độ form (Thêm mới hay Chỉnh sửa) --%>
<c:set var="isEdit" value="${user != null && user.userId != null}" />
<c:set var="formTitle" value="${isEdit ? 'Chỉnh sửa Người dùng' : 'Thêm mới Người dùng'}" />
<c:set var="formAction" value="${isEdit ? '/admin/user/edit' : '/admin/user/add'}" />

<div class="col-sm-9">
    <h1><small>${formTitle}</small></h1>
    <hr/>

    <div class="card shadow">
        <div class="card-header bg-secondary text-white">
            <h5 class="mb-0">${formTitle}</h5>
        </div>
        <div class="card-body">
            
            <%-- Hiển thị thông báo LỖI (từ Controller) --%>
            <c:if test="${requestScope.error != null}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${requestScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <form action="<c:url value="${formAction}"/>" method="post">
                <c:if test="${isEdit}">
                    <input type="hidden" name="userId" value="${user.userId}">
                    <%-- Giữ lại mật khẩu cũ nếu không nhập mật khẩu mới --%>
                    <input type="hidden" name="password" value="${user.password}"> 
                </c:if>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="username" class="form-label">Tài khoản (Username) (*)</label>
                        <input type="text" class="form-control" id="username" name="username" value="${user.username}" 
                            ${isEdit ? 'readonly' : 'required'}>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="password" class="form-label">Mật khẩu (*)</label>
                        <input type="${isEdit ? 'text' : 'password'}" class="form-control" id="password" name="password" 
                            ${isEdit ? 'placeholder="Bỏ trống nếu không đổi mật khẩu"' : 'required'}>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="fullName" class="form-label">Họ và Tên</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName}">
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" value="${user.email}">
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="phone" class="form-label">Điện thoại</label>
                        <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}">
                    </div>
                    
                    <div class="col-md-3 mb-3">
                        <label for="role" class="form-label">Quyền (*)</label>
                        <select class="form-select" id="role" name="role" required>
                            <option value="USER" ${user.role == 'USER' ? 'selected' : ''}>Người dùng (USER)</option>
                            <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Quản trị viên (ADMIN)</option>
                        </select>
                    </div>

                    <div class="col-md-3 mb-3 d-flex align-items-end">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="status" name="status" value="true"
                                ${user.status || !isEdit ? 'checked' : ''}>
                            <label class="form-check-label" for="status">Hoạt động (Status)</label>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">Địa chỉ</label>
                    <textarea class="form-control" id="address" name="address" rows="3">${user.address}</textarea>
                </div>
                
                <div class="d-flex justify-content-end">
                    <a href="<c:url value="/admin/users"/>" class="btn btn-secondary me-2">
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