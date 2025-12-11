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
    <!-- Bootstrap 5 bundle (includes Popper) - required for data-bs-* attributes to work -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <!-- Ensure dropdowns are initialized and add a light debug log in console -->
    <script>
      (function(){
        try {
          if (typeof bootstrap !== 'undefined' && bootstrap.Dropdown) {
            var toggles = document.querySelectorAll('[data-bs-toggle="dropdown"]');
            toggles.forEach(function(el){
              // instantiate only if not already attached
              try { new bootstrap.Dropdown(el); } catch(e) { /* ignore */ }
            });
            // optional debug
            console.log('Bootstrap dropdown init: ' + toggles.length + ' toggles');
          } else {
            console.warn('Bootstrap not loaded or bootstrap.Dropdown missing');
          }
        } catch (err) {
          console.error('Error initializing dropdowns', err);
        }
      })();
    </script>
    <script>
      (function(){
        try {
          var userToggle = document.getElementById('userDropdown');
          if (userToggle) {
            userToggle.addEventListener('click', function(e){
              // prevent default navigation and stop propagation and explicitly toggle
              e.preventDefault();
              e.stopPropagation();
              try {
                var menu = userToggle.parentElement.querySelector('.dropdown-menu');
                if (typeof bootstrap !== 'undefined' && bootstrap.Dropdown) {
                  try {
                    var inst = bootstrap.Dropdown.getOrCreateInstance(userToggle);
                    inst.toggle();
                  } catch (ex) {
                    console.error('Error toggling user dropdown with Bootstrap API', ex);
                  }
                }
                // Fallback: manually toggle .show and aria-expanded
                if (menu) {
                  var isShown = menu.classList.contains('show');
                  if (isShown) {
                    menu.classList.remove('show');
                    userToggle.setAttribute('aria-expanded','false');
                  } else {
                    menu.classList.add('show');
                    userToggle.setAttribute('aria-expanded','true');
                  }
                }
              } catch (err) {
                console.error('Error in user toggle click handler', err);
              }
            });
            // close dropdown when clicking outside
            document.addEventListener('click', function(ev){
              try {
                var menu = userToggle.parentElement.querySelector('.dropdown-menu');
                if (menu && menu.classList.contains('show')) {
                  var within = userToggle.contains(ev.target) || menu.contains(ev.target);
                  if (!within) {
                    // try to hide via bootstrap API first
                    try {
                      if (typeof bootstrap !== 'undefined' && bootstrap.Dropdown) {
                        var inst = bootstrap.Dropdown.getOrCreateInstance(userToggle);
                        inst.hide();
                      }
                    } catch (e) {
                      // ignore
                    }
                    // fallback remove class
                    menu.classList.remove('show');
                    userToggle.setAttribute('aria-expanded','false');
                  }
                }
              } catch(err) { /* ignore */ }
            });
          }
        } catch(err) {
          console.error('Error setting user dropdown click handler', err);
        }
      })();
    </script>
  </body>
</html>