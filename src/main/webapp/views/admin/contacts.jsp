<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="col-sm-9">
    <h1><small>Danh sách Liên hệ</small></h1>
    <hr/>

    <c:if test="${sessionScope.message != null}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="table-responsive">
        <table class="table table-bordered table-striped table-hover shadow-sm">
            <thead class="table-dark">
                <tr>
                    <th style="width:5%">ID</th>
                    <th style="width:20%">Tên</th>
                    <th style="width:20%">Email</th>
                    <th style="width:20%">Tiêu đề</th>
                    <th style="width:15%">Ngày</th>
                    <th style="width:20%"></th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${not empty contacts}">
                    <c:forEach var="c" items="${contacts}">
                        <tr>
                            <td>${c.contactId}</td>
                            <td>${c.name}</td>
                            <td>${c.email}</td>
                            <td>${c.subject}</td>
                            <td>${c.createdAtStr}</td>
                            <td class="text-center">
                            
                                <button onclick="confirmDelete(${c.contactId})" class="btn btn-sm btn-danger" title="Xóa">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="6" class="text-muted">${c.message}</td>
                        </tr>
                    </c:forEach>
                </c:if>

                <c:if test="${empty contacts}">
                    <tr>
                        <td colspan="6" class="text-center">Chưa có liên hệ nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Phân trang (nếu controller cung cấp totalPages/currentPage) -->
    <c:if test="${totalPages != null && totalPages > 1}">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/admin/contacts?page=${currentPage - 1}">&laquo;</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/contacts?page=${i}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/admin/contacts?page=${currentPage + 1}">&raquo;</a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<!-- Form xóa ẩn -->
<form id="deleteForm" action="${pageContext.request.contextPath}/admin/contacts/delete" method="post" style="display:none;">
    <input type="hidden" name="id" id="contactIdToDelete" />
</form>

<script>
    function confirmDelete(id) {
        if (confirm('Xác nhận xóa liên hệ #' + id + ' ?')) {
            document.getElementById('contactIdToDelete').value = id;
            document.getElementById('deleteForm').submit();
        }
    }
</script>