/**
 * ProductFilter.js - Xử lý lọc, phân trang và lazy loading sản phẩm
 */
class ProductFilter {
    constructor(options = {}) {
        this.containerSelector = options.containerSelector || '#products-container';
        this.paginationSelector = options.paginationSelector || '#pagination-container';
        this.filterSelector = options.filterSelector || '#filter-container';
        this.apiUrl = options.apiUrl || '/api/products';
        this.currentPage = 1;
        this.totalPages = 1;
        this.selectedCategory = 0;
        this.selectedSort = '';
        this.isLoading = false;
        this.lazyLoadMode = options.lazyLoadMode || false; // true: lazy load, false: pagination

        this.init();
    }

    /**
     * Khởi tạo event listeners
     */
    init() {
        // Lọc theo danh mục
        $(document).on('change', '.category-filter', (e) => {
            this.selectedCategory = $(e.target).val();
            this.currentPage = 1;
            this.loadProducts();
        });

        // Sắp xếp
        $(document).on('change', '.sort-select', (e) => {
            this.selectedSort = $(e.target).val();
            this.currentPage = 1;
            this.loadProducts();
        });

        // Phân trang
        $(document).on('click', '.pagination a:not(.disabled)', (e) => {
            e.preventDefault();
            if ($(e.currentTarget).attr('data-page')) {
                this.currentPage = parseInt($(e.currentTarget).attr('data-page'));
                this.loadProducts();
                $('html, body').animate({ scrollTop: 0 }, 300);
            }
        });

        // Lazy loading - Tải thêm khi scroll tới cuối trang
        if (this.lazyLoadMode) {
            $(window).on('scroll', () => {
                if (this.shouldLoadMore()) {
                    this.loadMore();
                }
            });
        }

        // Load more button
        $(document).on('click', '.load-more-btn', (e) => {
            e.preventDefault();
            this.loadMore();
        });
    }

    /**
     * Tải sản phẩm
     */
    loadProducts() {
        if (this.isLoading) return;
        this.isLoading = true;

        const params = {
            action: this.lazyLoadMode ? 'load-more' : 'pagination',
            page: this.currentPage,
            categoryId: this.selectedCategory,
            sort: this.selectedSort
        };

        this.showLoadingState();

        $.ajax({
            url: this.apiUrl,
            type: 'GET',
            dataType: 'json',
            data: params,
            success: (response) => {
                if (response.success) {
                    if (this.lazyLoadMode && this.currentPage > 1) {
                        // Lazy load: thêm sản phẩm vào cuối
                        this.appendProducts(response.products);
                    } else {
                        // Pagination: thay thế toàn bộ
                        this.renderProducts(response.products);
                    }

                    this.totalPages = response.totalPages;
                    this.updatePagination(response);
                    this.hideLoadingState();
                } else {
                    this.showError(response.message || 'Lỗi tải sản phẩm');
                }
                this.isLoading = false;
            },
            error: (xhr, status, error) => {
                this.showError('Lỗi kết nối: ' + error);
                this.hideLoadingState();
                this.isLoading = false;
            }
        });
    }

    /**
     * Tải thêm sản phẩm (lazy load)
     */
    loadMore() {
        if (this.currentPage >= this.totalPages || this.isLoading) return;
        this.currentPage++;
        this.loadProducts();
    }

    /**
     * Kiểm tra xem có nên tải thêm không
     */
    shouldLoadMore() {
        if (!this.lazyLoadMode) return false;

        const scrollTop = $(window).scrollTop();
        const documentHeight = $(document).height();
        const windowHeight = $(window).height();

        // Tải thêm khi người dùng scroll tới 80% trang
        return (scrollTop + windowHeight) >= (documentHeight * 0.8);
    }

    /**
     * Hiển thị sản phẩm (thay thế toàn bộ)
     */
    renderProducts(products) {
        const container = $(this.containerSelector);
        container.empty();

        if (!products || products.length === 0) {
            container.html('<div class="col-12 text-center"><p>Không có sản phẩm nào.</p></div>');
            return;
        }

        products.forEach(product => {
            const html = this.createProductCard(product);
            container.append(html);
        });
    }

    /**
     * Thêm sản phẩm vào cuối (lazy load)
     */
    appendProducts(products) {
        const container = $(this.containerSelector);

        if (!products || products.length === 0) return;

        products.forEach(product => {
            const html = this.createProductCard(product);
            container.append(html);
        });
    }

    /**
     * Tạo HTML cho một sản phẩm
     */
    createProductCard(product) {
        // Lấy context path từ window object (được set từ JSP)
        const contextPath = window.contextPath || '';
        
        const salePrice = product.salePrice && product.salePrice > 0 ? product.salePrice : null;
        
        // Tính % giảm giá
        let discountHtml = '';
        if (salePrice) {
            const discountPercent = Math.round(((product.price - salePrice) * 100) / product.price);
            discountHtml = `<small class="badge bg-danger">-${discountPercent}%</small>`;
        }
        
        const priceDisplay = salePrice 
            ? `<span class="text-muted text-decoration-line-through me-2 small">${this.formatPrice(product.price)} VNĐ</span>
               <span class="text-danger fw-bold">${this.formatPrice(salePrice)} VNĐ</span>
               <div>${discountHtml}</div>`
            : `<span class="text-primary fw-bold">${this.formatPrice(product.price)} VNĐ</span>`;

        const imageHtml = product.image 
            ? `<img src="${contextPath}/${product.image}" class="card-img-top" alt="${product.productName}" style="height:180px;object-fit:cover;">`
            : `<div class="card-img-top bg-light d-flex align-items-center justify-content-center" style="height:180px;">
                <i class="fas fa-image text-muted" style="font-size: 3rem;"></i>
              </div>`;

        return `
            <div class="col-6 col-sm-4 col-md-3">
                <div class="card h-100 shadow-sm product-card hover-card">
                    ${imageHtml}
                    <div class="card-body d-flex flex-column">
                        <h6 class="card-title text-truncate">${product.productName}</h6>
                        <p class="card-text text-muted text-truncate small">${product.shortDescription || 'Sản phẩm chất lượng'}</p>
                        <div class="mb-3">
                            ${priceDisplay}
                        </div>
                        <div class="mt-auto d-flex gap-2 justify-content-between align-items-center">
                            <a href="${contextPath}/product?id=${product.productId}" class="btn btn-sm btn-outline-primary flex-grow-1">
                                <i class="fas fa-eye"></i> Xem
                            </a>
                            <form action="${contextPath}/cart/add" method="post" class="d-inline">
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
        `;
    }

    /**
     * Cập nhật phần tử phân trang
     */
    updatePagination(response) {
        const paginationContainer = $(this.paginationSelector);
        
        if (this.lazyLoadMode) {
            // Lazy load mode: hiển thị nút "Tải thêm"
            paginationContainer.empty();
            if (response.hasMore || this.currentPage < response.totalPages) {
                paginationContainer.html(`
                    <div class="text-center mt-4">
                        <button class="btn btn-primary load-more-btn">Tải thêm sản phẩm</button>
                    </div>
                `);
            }
        } else {
            // Pagination mode: hiển thị số trang
            this.renderPaginationButtons(response);
        }
    }

    /**
     * Render pagination buttons
     */
    renderPaginationButtons(response) {
        const paginationContainer = $(this.paginationSelector);
        paginationContainer.empty();

        if (response.totalPages <= 1) return;

        const nav = $('<nav aria-label="Page navigation"><ul class="pagination justify-content-center"></ul></nav>');
        const ul = nav.find('ul');

        // Previous button
        const prevDisabled = response.currentPage === 1 ? 'disabled' : '';
        ul.append(`<li class="page-item ${prevDisabled}">
            <a class="page-link" href="#" data-page="${response.currentPage - 1}">&laquo;</a>
        </li>`);

        // Page numbers
        const startPage = Math.max(1, response.currentPage - 2);
        const endPage = Math.min(response.totalPages, response.currentPage + 2);

        if (startPage > 1) {
            ul.append(`<li class="page-item"><a class="page-link" href="#" data-page="1">1</a></li>`);
            if (startPage > 2) {
                ul.append(`<li class="page-item disabled"><span class="page-link">...</span></li>`);
            }
        }

        for (let i = startPage; i <= endPage; i++) {
            const active = i === response.currentPage ? 'active' : '';
            ul.append(`<li class="page-item ${active}"><a class="page-link" href="#" data-page="${i}">${i}</a></li>`);
        }

        if (endPage < response.totalPages) {
            if (endPage < response.totalPages - 1) {
                ul.append(`<li class="page-item disabled"><span class="page-link">...</span></li>`);
            }
            ul.append(`<li class="page-item"><a class="page-link" href="#" data-page="${response.totalPages}">${response.totalPages}</a></li>`);
        }

        // Next button
        const nextDisabled = response.currentPage === response.totalPages ? 'disabled' : '';
        ul.append(`<li class="page-item ${nextDisabled}">
            <a class="page-link" href="#" data-page="${response.currentPage + 1}">&raquo;</a>
        </li>`);

        paginationContainer.html(nav);
    }

    /**
     * Định dạng giá
     */
    formatPrice(price) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'decimal',
            maximumFractionDigits: 0
        }).format(price);
    }

    /**
     * Hiển thị trạng thái loading
     */
    showLoadingState() {
        $(this.containerSelector).css('opacity', '0.6');
    }

    /**
     * Ẩn trạng thái loading
     */
    hideLoadingState() {
        $(this.containerSelector).css('opacity', '1');
    }

    /**
     * Hiển thị lỗi
     */
    showError(message) {
        alert(message);
    }

    /**
     * Thiết lập loại lazy loading (true) hoặc pagination (false)
     */
    setLazyLoadMode(enable) {
        this.lazyLoadMode = enable;
    }

    /**
     * Đặt lại bộ lọc
     */
    reset() {
        this.selectedCategory = 0;
        this.selectedSort = '';
        this.currentPage = 1;
        $('.category-filter').val(0);
        $('.sort-select').val('');
        this.loadProducts();
    }
}

// Export cho sử dụng ngoài
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ProductFilter;
}
