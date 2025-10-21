<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<div class="col-sm-9">
            <section class="admin-content">
                <h2>Chào mừng, Admin ${sessionScope.account.fullName}!</h2>
                <p>Đây là bảng điều khiển chính. Tại đây, bạn có thể xem tổng quan về hệ thống và quản lý các chức năng.</p>
                
                <div class="dashboard-widgets">
                    <div class="widget">
                        <h3>Người dùng mới</h3>
                        <p><strong>150</strong></p>
                    </div>
                    <div class="widget">
                        <h3>Sản phẩm đã bán</h3>
                        <p><strong>2,100</strong></p>
                    </div>
                    <div class="widget">
                        <h3>Lượt truy cập</h3>
                        <p><strong>12,500</strong></p>
                    </div>
                </div>

                <div class="dashboard-chart">
                    <h3>Biểu đồ thống kê</h3>
                    <p>Biểu đồ doanh thu hàng tháng sẽ được hiển thị ở đây.</p>
                </div>
            </section>
        </div>


  