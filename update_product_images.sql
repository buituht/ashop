-- SQL Script để cập nhật đường dẫn hình ảnh sản phẩm
-- Lưu trong project: src/main/webapp/photos/products/

-- Cập nhật slug (nếu chưa có)
UPDATE products SET slug = 'muc-kho-cau' WHERE product_id = 1;
UPDATE products SET slug = 'tom-kho-loai-lon' WHERE product_id = 2;
UPDATE products SET slug = 'xoai-say-deo' WHERE product_id = 3;
UPDATE products SET slug = 'banh-pia-trung-muoi' WHERE product_id = 4;
UPDATE products SET slug = 'nuoc-mam-ca-com' WHERE product_id = 5;
UPDATE products SET slug = 'keo-dua-ben-tre' WHERE product_id = 6;

-- Cập nhật short_description (nếu chưa có)
UPDATE products SET short_description = 'Mực khô loại 1, được câu và phơi khô tự nhiên' WHERE product_id = 1;
UPDATE products SET short_description = 'Tôm khô ngon, ngọt thịt, thích hợp nấu canh' WHERE product_id = 2;
UPDATE products SET short_description = 'Xoài cát Hòa Lộc sấy dẻo, không đường' WHERE product_id = 3;
UPDATE products SET short_description = 'Bánh pía Sóc Trăng truyền thống, nhân đậu xanh' WHERE product_id = 4;
UPDATE products SET short_description = 'Nước mắm nhỉ cốt cá cơm, độ đạm cao' WHERE product_id = 5;
UPDATE products SET short_description = 'Kẹo dừa béo ngậy, làm thủ công tại Bến Tre' WHERE product_id = 6;

-- Cập nhật đường dẫn hình ảnh (lưu trong project)
UPDATE products SET image = 'photos/products/muc-kho-cau.jpg' WHERE product_id = 1;
UPDATE products SET image = 'photos/products/tom-kho.jpg' WHERE product_id = 2;
UPDATE products SET image = 'photos/products/xoai-say.jpg' WHERE product_id = 3;
UPDATE products SET image = 'photos/products/banh-pia.jpg' WHERE product_id = 4;
UPDATE products SET image = 'photos/products/nuoc-mam.jpg' WHERE product_id = 5;
UPDATE products SET image = 'photos/products/keo-dua.jpg' WHERE product_id = 6;

-- Kiểm tra
SELECT product_id, product_name, slug, short_description, image FROM products;
