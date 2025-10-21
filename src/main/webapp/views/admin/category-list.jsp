<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="col-sm-9">
    <h1><small>Danh sách Danh mục Sản phẩm</small></h1>
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
        <a href="<c:url value="/admin/category/add"/>" class="btn btn-primary mb-3">
            <i class="bi bi-plus-circle"></i> Thêm Danh mục mới
        </a>
    </p>
    <br/>
    
    <div class="table-responsive">
        <table class="table table-bordered table-striped table-hover shadow-sm">
            <thead class="table-dark">
                <tr>
                    <th style="width: 5%;">ID</th>
                    <th style="width: 20%;">Tên Danh mục</th>
                    <th style="width: 15%;">Ảnh</th>
                    <th style="width: 40%;">Mô tả</th>
                    <th style="width: 10%;">Trạng thái</th>
                    <th class="text-center" style="width: 10%;">Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="cate" items="${categories}">
                    <tr>
                        <td>${cate.categoryId}</td>
                        <td>${cate.categoryName}</td>
                        <td>
                            <c:if test="${cate.image != null && cate.image != ''}">
                                <img src="${pageContext.request.contextPath}/${cate.image}" 
                                     alt="Category Image" class="img-thumbnail" style="max-width: 80px; height: auto;">
                            </c:if>
                        </td>
                        <td>${cate.description}</td>
                        <td>
                            <span class="badge ${cate.status ? 'bg-success' : 'bg-warning'}">
                                ${cate.status ? 'Hoạt động' : 'Đã ẩn'}
                            </span>
                        </td>
                        <td class="text-center">
                            <a href="<c:url value="/admin/category/edit?id=${cate.categoryId}"/>" class="btn btn-sm btn-primary me-2" title="Chỉnh sửa">
                                <i class="fas fa-edit"></i>
                            </a>
                            <button onclick="confirmDelete(${cate.categoryId}, '${cate.categoryName}')" class="btn btn-sm btn-danger" title="Khóa/Xóa">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty categories}">
                    <tr>
                        <td colspan="6" class="text-center">Không tìm thấy danh mục nào.</td>
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
                    <a class="page-link" href="<c:url value="/admin/categories"><c:param name="page" value="${currentPage - 1}"/></c:url>" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="<c:url value="/admin/categories"><c:param name="page" value="${i}"/></c:url>">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="<c:url value="/admin/categories"><c:param name="page" value="${currentPage + 1}"/></c:url>" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<%-- Script Xóa (Soft Delete) --%>
<form id="deleteForm" action="<c:url value="/admin/category/delete"/>" method="post" style="display: none;">
    <input type="hidden" name="id" id="categoryIdToDelete">
</form>

<script>
    function confirmDelete(id, name) {
        if (confirm('Bạn có chắc chắn muốn KHÓA/ẨN danh mục "' + name + '" không? (Nên ẩn thay vì xóa cứng)')) {
            document.getElementById('categoryIdToDelete').value = id;
            document.getElementById('deleteForm').submit();
        }
    }
</script>