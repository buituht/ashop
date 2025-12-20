<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>


<div class="col-sm-9">
    <h1><small>Bảng Điều Khiển Quản Trị (Admin Dashboard)</small></h1>
    <hr/>
    
    <div class="alert alert-info">
        Chào mừng trở lại, ${sessionScope.currentUser.fullName}! 
        Đây là khu vực quản trị.
    </div>

    <div class="row">
        <div class="col-md-4 mb-4">
            <div class="card text-white bg-success shadow" style="
    padding: 5px;
">
                <div class="card-body">
                    <h5 class="card-title">Tổng Đơn Hàng</h5>
                    <p class="card-text fs-3">120</p>
                </div>
                <div class="card-footer">
                    <a href="<c:url value="/admin/order/list"/>" class="text-white">Xem chi tiết <i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>
        
        <div class="col-md-4 mb-4">
            <div class="card text-white bg-warning shadow" style="
    padding: 5px;
">
                <div class="card-body">
                    <h5 class="card-title"><i class="fas fa-cog"></i> Sản Phẩm Đang Bán</h5>
                    <p class="card-text fs-3">55</p>
                </div>
                <div class="card-footer">
                    <a href="<c:url value="/admin/products"/>" class="text-white">Quản lý Sản phẩm <i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-4" >
            <div class="card text-white bg-primary shadow" style="
    padding: 5px;
">
                <div class="card-body">
                    <h5 class="card-title"><i class="fas fa-user"></i> Người Dùng Mới</h5>
                    <p class="card-text fs-3">8</p>
                </div>
                <div class="card-footer">
                    <a href="<c:url value="/admin/users"/>" class="text-white">Quản lý Người dùng <i class="fas fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>
