<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>  
 


    <header>
    
         <core1:choose>

		<core1:when test="${sessionScope.account == null}">
		<div class="col-sm-4">
		<ul class="list-inline right-topbar pull-right">
		<li><a href="${pageContext.request.contextPath }/login">Đăng nhập</a>
		| <a href="${pageContext.request.contextPath }/register">Đăng ký</a></li>
		
		<li><i class="search fa fa-search search-button"></i></li>
		</ul>
		</div>
		</core1:when>
		
		<core1:otherwise>
		<div class="col-sm-4">
		<ul class="list-inline right-topbar pull-right">
		<li><a href="${pageContext.request.contextPath
		}/member/myaccount">${sessionScope.account.fullName}</a> | <a
		href="${pageContext.request.contextPath }/logout">Đăng Xuất</a></li>
		<li><i class="search fa fa-search search-button"></i></li>
		</ul>
		</div>
		</core1:otherwise>
		
		</core1:choose>
        <div class="container">
   

            <h1>Trang Web Bán Hàng</h1>
            <nav>
                <ul>
                    <li><a href="${pageContext.request.contextPath }">Trang Chủ</a></li>
                    <li><a href="${pageContext.request.contextPath }/products">Sản phẩm</a></li>
                    <li><a href="#">Giới Thiệu</a></li>
                    <li><a href="#">Dịch Vụ</a></li>
                    <li><a href="#">Liên Hệ</a></li>
                    <li><a href="${pageContext.request.contextPath }/login">Đăng nhập</a></li>
                </ul>
            </nav>
        </div>
    </header>
