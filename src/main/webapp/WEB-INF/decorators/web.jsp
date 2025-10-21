<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="jakarta.tags.core" %>  



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home page</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.8/css/bootstrap.min.css" rel="stylesheet" integrity="sha512-..." crossorigin="anonymous">
<style>
/* Thiết lập chung */
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    line-height: 1.6;
    background-color: #f4f4f4;
    color: #333;
}

.container {
    width: 80%;
    margin: auto;
    overflow: hidden;
}

/* Kiểu cho phần header (đầu trang) */
header {
    background: #333;
    color: #fff;
    padding-top: 30px;
    min-height: 70px;
    border-bottom: #77aaff 3px solid;
    text-align: center;
}

header h1 {
    margin: 0;
    font-size: 2em;
}

header nav ul {
    padding: 0;
    margin: 0;
    list-style: none;
    display: flex;
    justify-content: center;
}

header nav ul li {
    padding: 0 15px 0 15px;
}

header nav a {
    color: #fff;
    text-decoration: none;
    text-transform: uppercase;
    font-size: 16px;
    font-weight: bold;
}

header a:hover {
    color: #77aaff;
}

/* Kiểu cho phần main content (nội dung chính) */
main {
    padding: 20px 0;
}

.hero-section {
    background: #fff;
    padding: 40px;
    border-radius: 8px;
    text-align: center;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.hero-section h2 {
    font-size: 2.5em;
    margin-bottom: 10px;
    color: #007bff;
}

.hero-section p {
    font-size: 1.2em;
    margin-bottom: 20px;
}

.btn {
    display: inline-block;
    padding: 10px 20px;
    background: #007bff;
    color: #fff;
    text-decoration: none;
    border-radius: 5px;
    font-weight: bold;
    transition: background-color 0.3s;
}

.btn:hover {
    background: #0056b3;
}

/* Kiểu cho phần footer (chân trang) */
footer {
    background: #333;
    color: #fff;
    text-align: center;
    padding: 20px 0;
    margin-top: 20px;
}
</style>

</head>
<body>
 
<%@ include file="/common/web/header.jsp"%>

   <div class="container">
   		
   		
   		
   		<hr>
   		<div class="row">
   		
   		<sitemesh:write property="body"/>
   		
   		</div>
   		
   		<div class="row">
   		
   			
   		
   		</div>
   </div>
   
   <%@ include file="/common/footer.jsp"%>
   
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.7/dist/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
  </body>
</html>