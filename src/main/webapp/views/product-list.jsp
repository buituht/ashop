<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container mt-4 mb-5">
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="mb-2"><i class="fas fa-boxes text-primary"></i> Danh sách sản phẩm</h2>
            <p class="text-muted">Tổng <strong id="total-items">${totalItems}</strong> sản phẩm</p>
        </div>
    </div>
    
    <!-- Filter Section -->
    <div id="filter-container" class="mb-4 p-4 bg-light rounded-3 border">
        <div class="row align-items-end g-3">
            <!-- Lọc theo danh mục -->
            <div class="col-md-4">
                <label for="categoryFilter" class="form-label fw-bold">
                    <i class="fas fa-layer-group text-info"></i> Danh mục sản phẩm:
                </label>
                <select id="categoryFilter" class="form-select category-filter" style="min-height: 38px;">
                    <option value="0">Tất cả danh mục</option>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.categoryId}" ${selectedCategory == category.categoryId ? 'selected' : ''}>${category.categoryName}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Lọc theo giá -->
            <div class="col-md-4">
                <label class="form-label fw-bold">
                    <i class="fas fa-money-bill text-success"></i> Khoảng giá:
                </label>
                <div class="input-group">
                    <input type="number" id="priceMin" class="form-control price-filter" placeholder="Giá từ" min="0">
                    <span class="input-group-text">đến</span>
                    <input type="number" id="priceMax" class="form-control price-filter" placeholder="Giá đến" min="0">
                </div>
            </div>

            <!-- Sắp xếp -->
            <div class="col-md-4">
                <label for="sortSelect" class="form-label fw-bold">
                    <i class="fas fa-sort-amount-down text-warning"></i> Sắp xếp:
                </label>
                <select id="sortSelect" class="form-select sort-select" style="min-height: 38px;">
                    <option value="">Mặc định</option>
                    <option value="newest">Mới nhất</option>
                    <option value="price-asc">Giá: Thấp → Cao</option>
                    <option value="price-desc">Giá: Cao → Thấp</option>
                    <option value="name-asc">Tên: A → Z</option>
                    <option value="name-desc">Tên: Z → A</option>
                </select>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-12 d-flex gap-2 align-items-center">
                <button id="resetFilters" class="btn btn-outline-secondary btn-sm">
                    <i class="fas fa-redo"></i> Đặt lại bộ lọc
                </button>
                <button id="toggleLazyLoad" class="btn btn-outline-info btn-sm" title="Chuyển đổi giữa phân trang và tải thêm">
                    <i class="fas fa-infinity"></i> Tải thêm
                </button>
                <small class="text-muted ms-auto">
                    <i class="fas fa-info-circle"></i> Chọn danh mục, giá hoặc cách sắp xếp để lọc sản phẩm
                </small>
            </div>
        </div>
    </div>

    <!-- Products Grid -->
    <div class="row g-4" id="products-container">
        <c:forEach var="product" items="${products}">
            <div class="col-6 col-sm-4 col-md-3">
                <div class="card h-100 shadow-sm product-card hover-card">
                    <c:if test="${product.image != null && product.image != ''}">
                        <img src="${pageContext.request.contextPath}/${product.image}" class="card-img-top" alt="${product.productName}" style="height:180px;object-fit:cover;">
                    </c:if>
                    <c:if test="${product.image == null || product.image == ''}">
                        <div class="card-img-top bg-light d-flex align-items-center justify-content-center" style="height:180px;">
                            <i class="fas fa-image text-muted" style="font-size: 3rem;"></i>
                        </div>
                    </c:if>
                    <div class="card-body d-flex flex-column">
                        <h6 class="card-title text-truncate">${product.productName}</h6>
                        <p class="card-text text-muted text-truncate small">${product.shortDescription}</p>
                        <div class="mb-3">
                            <c:choose>
                                <c:when test="${product.salePrice != null && product.salePrice > 0 && product.salePrice < product.price}">
                                    <span class="text-muted text-decoration-line-through me-2 small"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" /> VNĐ</span>
                                    <span class="text-danger fw-bold"><fmt:formatNumber value="${product.salePrice}" type="number" maxFractionDigits="0" /> VNĐ</span>
                                    <c:set var="discountPercent" value="${((product.price - product.salePrice) * 100) / product.price}" />
                                    <div><small class="badge bg-danger">-<fmt:formatNumber value="${discountPercent}" type="number" maxFractionDigits="0" />%</small></div>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-primary fw-bold"><fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0" /> VNĐ</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mt-auto d-flex gap-2 justify-content-between align-items-center">
                            <a href="${pageContext.request.contextPath}/product?id=${product.productId}" class="btn btn-sm btn-outline-primary flex-grow-1">
                                <i class="fas fa-eye"></i> Xem
                            </a>
                            <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-inline">
                                <input type="hidden" name="productId" value="${product.productId}" />
                                <input type="hidden" name="quantity" value="1" />
                                <button type="submit" class="btn btn-sm btn-success" title="Thêm vào giỏ hàng">
                                    <i class="fas fa-cart-plus"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty products}">
            <div class="col-12">
                <div class="alert alert-info text-center py-5">
                    <i class="fas fa-inbox text-muted" style="font-size: 3rem;"></i>
                    <p class="mt-3 mb-0 text-muted">Không có sản phẩm nào phù hợp với lựa chọn của bạn.</p>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Pagination Container -->
    <div id="pagination-container" class="mt-5">
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="#" data-page="${currentPage - 1}" aria-label="Trang trước">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    
                    <c:set var="startPage" value="${currentPage > 3 ? currentPage - 2 : 1}" />
                    <c:set var="endPage" value="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" />
                    
                    <c:if test="${startPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="#" data-page="1">1</a>
                        </li>
                        <c:if test="${startPage > 2}">
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        </c:if>
                    </c:if>
                    
                    <c:forEach begin="${startPage}" end="${endPage}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="#" data-page="${i}">${i}</a>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${endPage < totalPages}">
                        <c:if test="${endPage < totalPages - 1}">
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                        </c:if>
                        <li class="page-item">
                            <a class="page-link" href="#" data-page="${totalPages}">${totalPages}</a>
                        </li>
                    </c:if>
                    
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="#" data-page="${currentPage + 1}" aria-label="Trang tiếp">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
</div>

<!-- Thêm jQuery (nếu chưa có) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Thêm ProductFilter script -->
<script src="${pageContext.request.contextPath}/resources/js/product-filter.js"></script>

<style>
    .product-card {
        transition: all 0.3s ease;
        border: 1px solid #e9ecef;
    }
    
    .product-card:hover {
        box-shadow: 0 8px 24px rgba(0,0,0,0.12) !important;
        transform: translateY(-5px);
        border-color: #007bff;
    }
    
    .hover-card {
        transition: all 0.3s ease;
    }
    
    .hover-card:hover {
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
        transform: translateY(-3px);
    }
    
    #products-container {
        min-height: 500px;
    }
    
    .loading-spinner {
        display: inline-block;
        margin-right: 10px;
    }
</style>

<script>
    // Set context path cho JavaScript
    window.contextPath = '${pageContext.request.contextPath}';
    
    $(document).ready(function() {
        // Khởi tạo ProductFilter
        const productFilter = new ProductFilter({
            containerSelector: '#products-container',
            paginationSelector: '#pagination-container',
            filterSelector: '#filter-container',
            apiUrl: window.contextPath + '/api/products',
            lazyLoadMode: false // false = pagination, true = lazy loading
        });

        // Reset filters button
        $('#resetFilters').on('click', function() {
            productFilter.reset();
        });

        // Toggle lazy load mode
        $('#toggleLazyLoad').on('click', function() {
            const isLazyLoad = productFilter.lazyLoadMode;
            productFilter.setLazyLoadMode(!isLazyLoad);
            $(this).html(isLazyLoad 
                ? '<i class="fas fa-list"></i> Phân trang'
                : '<i class="fas fa-infinity"></i> Tải thêm'
            );
            productFilter.currentPage = 1;
            productFilter.loadProducts();
        });

        // Xử lý lọc giá
        $('.price-filter').on('change', function() {
            // Có thể mở rộng để thêm lọc giá thực tế
            console.log('Price range changed');
        });
    });
</script>
