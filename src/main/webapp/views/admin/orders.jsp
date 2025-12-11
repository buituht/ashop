<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="col-sm-9">
    <h1><small>Danh sách Đơn hàng</small></h1>
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
                    <th style="width:5%">Mã</th>
                    <th style="width:20%">Người</th>
                    <th style="width:20%">Ngày</th>
                    <th style="width:15%">Tổng</th>
                    <th style="width:15%">Trạng thái</th>
                    <th class="text-center" style="width:15%">Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td>${o.orderId}</td>
                        <td><c:out value="${o.receiverName}"/></td>
                        <td>${o.orderDateStr}</td>
                        <td>
                            <fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${o.status == 'PENDING'}">
                                    <span class="badge bg-warning">PENDING</span>
                                </c:when>
                                <c:when test="${o.status == 'PROCESSING'}">
                                    <span class="badge bg-info">PROCESSING</span>
                                </c:when>
                                <c:when test="${o.status == 'SHIPPED'}">
                                    <span class="badge bg-primary">SHIPPED</span>
                                </c:when>
                                <c:when test="${o.status == 'COMPLETED'}">
                                    <span class="badge bg-success">COMPLETED</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">${o.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <a href="<c:url value='/admin/orders/view'><c:param name='id' value='${o.orderId}'/></c:url>" class="btn btn-sm btn-outline-primary me-2">Xem</a>

                            <form action="<c:url value='/admin/orders/updateStatus'/>" method="post" class="d-inline">
                                <input type="hidden" name="id" value="${o.orderId}"/>
                                <select name="status" class="form-select form-select-sm d-inline-block" style="width:auto;">
                                    <option value="PENDING" ${o.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                    <option value="PROCESSING" ${o.status == 'PROCESSING' ? 'selected' : ''}>PROCESSING</option>
                                    <option value="SHIPPED" ${o.status == 'SHIPPED' ? 'selected' : ''}>SHIPPED</option>
                                    <option value="COMPLETED" ${o.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                    <option value="CANCELLED" ${o.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                </select>
                                <button class="btn btn-sm btn-success" type="submit">Cập nhật</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="6" class="text-center">Không tìm thấy đơn hàng nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <%-- Phân trang giống product-list.jsp --%>
    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="<c:url value='/admin/orders'><c:param name='page' value='${currentPage - 1}'/></c:url>" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="<c:url value='/admin/orders'><c:param name='page' value='${i}'/></c:url>">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="<c:url value='/admin/orders'><c:param name='page' value='${currentPage + 1}'/></c:url>" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>