<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="col-sm-9">
    <h1><small>Danh sách Người dùng</small></h1>
    <hr/>
    
    <%-- Hiển thị thông báo (Message) --%>
    <c:if test="${sessionScope.message != null}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <p>
        <%-- Link thêm người dùng mới (nếu có) --%>
        <a href="<c:url value="/admin/user/add"/>" class="btn btn-primary mb-3">
            <i class="bi bi-plus-circle"></i> Thêm Người dùng mới
        </a>
    </p>
    <br/>
    
    <div class="table-responsive">
        <table class="table table-bordered table-striped table-hover shadow-sm">
            <thead class="table-dark">
                <tr>
                    <th style="width: 5%;">ID</th>
                    <th style="width: 15%;">Tài khoản</th>
                    <th style="width: 20%;">Họ & Tên</th>
                    <th style="width: 20%;">Email</th>
                    <th style="width: 10%;">Quyền</th>
                    <th style="width: 10%;">Trạng thái</th>
                    <th class="text-center" style="width: 15%;">Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td>${user.userId}</td>
                        <td>${user.username}</td>
                        <td>${user.fullName}</td>
                        <td>${user.email}</td>
                        <td>
                            <span class="badge ${user.role == 'ADMIN' ? 'bg-danger' : 'bg-info'}">
                                ${user.role}
                            </span>
                        </td>
                        <td>
                            <span class="badge ${user.status ? 'bg-success' : 'bg-warning'}">
                                ${user.status ? 'Hoạt động' : 'Đã khóa'}
                            </span>
                        </td>
                        <td class="text-center">
                            <a href="<c:url value="/admin/user/edit?id=${user.userId}"/>" class="btn btn-sm btn-primary me-2" title="Chỉnh sửa thông tin">
                                <i class="fas fa-edit"></i>
                            </a>
                            <%-- Chỉ cho phép xóa/khóa tài khoản không phải ADMIN --%>
                            <c:if test="${user.role != 'ADMIN'}">
                                <button onclick="confirmDelete(${user.userId}, '${user.username}')" class="btn btn-sm btn-danger" title="Khóa/Xóa tài khoản">
                                    <i class="fas fa-user-slash"></i>
                                </button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty users}">
                    <tr>
                        <td colspan="7" class="text-center">Không tìm thấy người dùng nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <%-- Logic phân trang --%>
    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                
                <%-- Nút Previous --%>
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="<c:url value="/admin/users"><c:param name="page" value="${currentPage - 1}"/></c:url>" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>

                <%-- Các nút số trang --%>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="<c:url value="/admin/users"><c:param name="page" value="${i}"/></c:url>">${i}</a>
                    </li>
                </c:forEach>

                <%-- Nút Next --%>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="<c:url value="/admin/users"><c:param name="page" value="${currentPage + 1}"/></c:url>" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<%-- Form ẩn và Script cho việc xóa (POST) --%>
<form id="deleteForm" action="<c:url value="/admin/user/delete"/>" method="post" style="display: none;">
    <input type="hidden" name="id" id="userIdToDelete">
</form>

<script>
    function confirmDelete(id, username) {
        if (confirm('Bạn có chắc chắn muốn KHÓA/XÓA tài khoản "' + username + '" không?')) {
            document.getElementById('userIdToDelete').value = id;
            document.getElementById('deleteForm').submit();
        }
    }
</script>