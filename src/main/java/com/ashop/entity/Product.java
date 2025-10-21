package com.ashop.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal; 
import java.time.LocalDateTime;


@Entity
@Table(name = "products")
public class Product implements Serializable {
    
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private Integer productId;

    @Column(name = "product_name", nullable = false, length = 255)
    private String productName;

    @Column(name = "slug", nullable = false, length = 255, unique = true)
    private String slug; // Dùng cho URL thân thiện

    @Column(name = "price", nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Column(name = "sale_price", precision = 10, scale = 2)
    private BigDecimal salePrice = BigDecimal.ZERO;

    @Column(name = "quantity")
    private Integer quantity = 0;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "image", length = 255)
    private String image; // Ảnh chính (main image)

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "status")
    private Boolean status = true; // True: Đang bán, False: Ẩn/Ngừng bán

    // --- Quan hệ Many-to-One với Category ---
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;
    /*
    // --- Quan hệ One-to-Many với Cart (Chi tiết giỏ hàng) ---
    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Cart> carts = new HashSet<>();

    // --- Quan hệ One-to-Many với Review ---
    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Review> reviews = new HashSet<>();
    */
    // --- Constructors ---

    public Product() {
    }

    /**
     * Constructor dùng cho việc giữ lại dữ liệu form khi có lỗi.
     * Cần phải set Category và các trường khác bằng tay sau khi tạo
     */
    public Product(Integer productId, String productName, String slug, BigDecimal price, BigDecimal salePrice, Integer quantity, String description, String image, Boolean status) {
        this.productId = productId;
        this.productName = productName;
        this.slug = slug;
        this.price = price;
        this.salePrice = salePrice;
        this.quantity = quantity;
        this.description = description;
        this.image = image;
        this.status = status;
    }

    // --- Getters and Setters ---

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(BigDecimal salePrice) {
        this.salePrice = salePrice;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }
/*
    public Set<Cart> getCarts() {
        return carts;
    }

    public void setCarts(Set<Cart> carts) {
        this.carts = carts;
    }

    public Set<Review> getReviews() {
        return reviews;
    }

    public void setReviews(Set<Review> reviews) {
        this.reviews = reviews;
    }
    */
    // @PreUpdate để tự động cập nhật trường updatedAt
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}