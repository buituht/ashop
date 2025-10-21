package com.ashop.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "categories")
public class Category implements Serializable {
    
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private Integer categoryId;

    @Column(name = "category_name", nullable = false, length = 100)
    private String categoryName;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "image", length = 255)
    private String image; // Lưu tên file ảnh (poster)

    @Column(name = "status")
    private Boolean status = true;
    
    // Quan hệ One-to-Many với Product
    @OneToMany(mappedBy = "category", cascade = CascadeType.ALL, orphanRemoval = true)
   
    
    private Set<Product> products = new HashSet<>();
	
    // --- Constructors ---

    public Category() {
    }

    /**
     * Constructor dùng để thêm mới (không có ID)
     */
    public Category(String categoryName, String description, String image, Boolean status) {
        this.categoryName = categoryName;
        this.description = description;
        this.image = image;
        this.status = status;
    }

    /**
     * Constructor đầy đủ các trường cơ bản (dùng cho chỉnh sửa hoặc giữ form data)
     */
    public Category(Integer categoryId, String categoryName, String description, String image, Boolean status) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description;
        this.image = image;
        this.status = status;
    }

    // --- Getters and Setters ---

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
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

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }
    
    public Set<Product> getProducts() {
        return products;
    }

    public void setProducts(Set<Product> products) {
        this.products = products;
    }
    
    
}