-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 20, 2025 at 09:28 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ashop`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT 1,
  `added_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`cart_id`, `user_id`, `product_id`, `quantity`, `added_at`) VALUES
(1, 2, 4, 2, '2025-10-20 08:30:49'),
(7, 5, 5, 1, '2025-12-20 13:42:21');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `description`, `image`, `status`) VALUES
(1, 'Hải Sản Khô', 'Các loại mực, cá khô, tôm khô từ biển', '/images/categories/unnamed.webp', 1),
(2, 'Trái Cây Sấy', 'Các loại trái cây được sấy khô tự nhiên, giữ nguyên vị', '/images/categories/unnamed.webp', 1),
(3, 'Bánh Kẹo Đặc Sản', 'Các loại bánh, kẹo truyền thống, đặc trưng vùng miền', '/images/categories/unnamed.webp', 1),
(4, 'Gia Vị & Nước Chấm', 'Các loại gia vị, mắm đặc biệt', '/images/categories/unnamed.webp', 1),
(5, 'Nông sản, dược liệu', 'mô tả danh mục 1', '/images/categories/unnamed.webp', 1);

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `contact_id` int(11) NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `order_date` datetime DEFAULT current_timestamp(),
  `total_amount` decimal(10,2) DEFAULT 0.00,
  `shipping_address` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `receiver_name` varchar(100) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `order_date`, `total_amount`, `shipping_address`, `phone`, `receiver_name`, `payment_method`, `status`, `note`) VALUES
(1, 2, '2025-10-20 08:30:49', 865000.00, '456 Đường Đặc Sản, Hà Nội', '0987654321', 'Trần Thị Khách', 'COD', 'COMPLETED', NULL),
(2, 5, '2025-12-01 14:16:01', 1350000.00, '940a tổ 15 ấp quan 1', '0917607635', 'Bùi Thanh Tú', 'COD', 'SHIPPED', 'nhan hang tai nha'),
(3, 5, '2025-12-08 14:09:16', 2100000.00, '01 La Quán Trung, Quận Bến Thành, Hồ Chí Minh', '0917607635', 'Tú', 'COD', 'PENDING', ''),
(4, 4, '2025-12-09 10:44:42', 450000.00, 'Quận 1, Hồ Chí Minh', '0917607635', 'Bùi Thanh Tú', 'COD', 'PENDING', ''),
(5, 5, '2025-12-20 09:27:38', 450000.00, 'số 1 Võ Vân Ngân, Thủ Đức', '0326517755', 'Son Ba', 'COD', 'PENDING', 'ok');

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `order_detail_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_details`
--

INSERT INTO `order_details` (`order_detail_id`, `order_id`, `product_id`, `quantity`, `price`, `subtotal`) VALUES
(1, 1, 1, 1, 700000.00, 700000.00),
(2, 1, 3, 1, 165000.00, 165000.00);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `vendor_id` int(11) DEFAULT NULL,
  `product_name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `discount_price` decimal(10,2) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `origin` varchar(100) DEFAULT NULL,
  `unit` varchar(20) DEFAULT 'kg',
  `featured` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `status` tinyint(1) DEFAULT 1,
  `quantity` int(11) DEFAULT NULL,
  `sale_price` decimal(10,2) DEFAULT NULL,
  `slug` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `short_description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `category_id`, `vendor_id`, `product_name`, `description`, `price`, `discount_price`, `stock_quantity`, `image`, `origin`, `unit`, `featured`, `created_at`, `status`, `quantity`, `sale_price`, `slug`, `updated_at`, `short_description`) VALUES
(1, 1, NULL, 'Mực Khô Câu', 'Mực khô loại 1, được câu và phơi khô tự nhiên tại Phú Quốc.', 750000.00, 700000.00, 50, '/images/products/Mực Khô Câu.jpeg', 'Phú Quốc', 'kg', 1, '2025-10-20 08:30:49', 1, 1000, 700000.00, 'muckhocau', '2025-12-20 14:44:24.000000', NULL),
(2, 1, NULL, 'Tôm Khô Loại Lớn', 'Tôm khô ngon, ngọt thịt, thích hợp nấu canh hoặc làm quà.', 450000.00, NULL, 100, '/images/products/Tôm Khô Loại Lớn.jpeg', 'Cà Mau', 'kg', 0, '2025-10-20 08:30:49', 1, 100, 400000.00, 'tomkholoailon', '2025-12-20 14:44:03.000000', NULL),
(3, 2, NULL, 'Xoài Sấy Dẻo', 'Xoài cát Hòa Lộc sấy dẻo, không đường, giữ vị chua ngọt tự nhiên.', 180000.00, 165000.00, 200, '/images/products/Xoài Sấy Dẻo.jpeg', 'Đồng Tháp', 'hộp 500g', 1, '2025-10-20 08:30:49', 1, 1000, 170000.00, 'xoaisaydeo', '2025-12-20 14:43:40.000000', NULL),
(4, 3, NULL, 'Bánh Pía Trứng Muối', 'Bánh pía Sóc Trăng truyền thống nhân đậu xanh, trứng muối.', 65000.00, NULL, 300, '/images/products/Bánh Pía Trứng Muối.jpeg', 'Sóc Trăng', 'hộp 4 cái', 1, '2025-10-20 08:30:49', 1, 100, 60000.00, 'banhpiatrungmuoi', '2025-12-20 14:43:15.000000', NULL),
(5, 4, NULL, 'Nước Mắm Cá Cơm', 'Nước mắm nhỉ cốt cá cơm, độ đạm cao, thơm ngon.', 120000.00, 100000.00, 80, '/images/products/Nước Mắm Cá Cơm.jpeg', 'Phan Thiết', 'chai 500ml', 0, '2025-10-20 08:30:49', 1, 2000, 110000.00, 'nuocmamcacom', '2025-12-20 14:42:49.000000', NULL),
(6, 3, NULL, 'Kẹo Dừa Bến Tre', 'Kẹo dừa béo ngậy, làm thủ công tại Bến Tre.', 45000.00, NULL, 400, '/photos/products/keoduabentre.jpeg', 'Bến Tre', 'gói 300g', 0, '2025-10-20 08:30:49', 1, 1000, 35000.00, 'keoduabentre', '2025-12-20 14:42:19.000000', NULL),
(7, 3, NULL, 'Bánh flan yến sấy', 'Bánh flan yến sấy thăng hoa, đặc sản Yumsea x Langfarm\r\nTổ yến nguyên chất, bánh ngon, bổ dưỡng, tan trong miệng', 88000.00, NULL, 0, '/photos/products/banhflanyensay.webp', NULL, 'kg', 0, '2025-12-20 14:50:10', 1, 100, 86000.00, 'banhflanyensay', NULL, NULL),
(8, 2, NULL, 'Cam sấy dẻo', 'Cam sấy dẻo, đặc sản Langfarm\r\nĂn vặt nông sản, hương vị tự nhiên, dẻo ngon, ít ngọt', 108000.00, NULL, 0, '/photos/products/camsaydeo.webp', NULL, 'kg', 0, '2025-12-20 14:56:15', 1, 1000, 107000.00, 'camsaydeo', NULL, NULL),
(9, 1, NULL, 'Granola siêu hạt', 'Granola siêu hạt đặc sản Langfarm\r\nHạt chất lượng, trái cây tuyển lựa, nướng phủ mật ong, healthy, eat clean', 165000.00, NULL, 0, '/photos/products/granolasieuhat.webp', NULL, 'kg', 0, '2025-12-20 14:58:17', 1, 100, 160000.00, 'granolasieuhat', NULL, NULL),
(10, 2, NULL, 'Ngũ hạt thập cẩm', 'Ngũ hạt thập cẩm, đặc sản Langfarm\r\nĂn vặt dinh dưỡng, giòn ngon, bắt miệng, an toàn vệ sinh', 67000.00, NULL, 0, '/photos/products/nguhatthapcam.webp', NULL, 'kg', 0, '2025-12-20 14:59:59', 1, 100, 65000.00, 'nguhatthapcam', NULL, NULL),
(11, 5, NULL, 'Bông atisô sấy khô', 'Bông atisô sấy khô, đặc sản Langfarm\r\nThảo mộc cho sức khoẻ, thơm dịu vị thiên nhiên, hàng loại 1', 250000.00, NULL, 0, '/photos/products/bongatisosaykho.webp', NULL, 'kg', 0, '2025-12-20 15:05:25', 1, 100, 240000.00, 'bongatisosaykho', NULL, NULL),
(12, 5, NULL, 'Bột diếp cá, đặc sản Bột Lá', 'Bột diếp cá, đặc sản Bột Lá x Langfarm\r\nTừ nông trại Đà Lạt, bột nguyên chất, công nghệ sấy nhiệt độ thấp, xay chậm siêu mịn', 120000.00, NULL, 0, '/photos/products/botdiepcaacsanbotla.webp', NULL, 'kg', 0, '2025-12-20 15:07:03', 1, 100, 11000.00, 'botdiepcaacsanbotla', NULL, NULL),
(13, 5, NULL, 'Bột cần tây, đặc sản Bột Lá', 'Bột cần tây, đặc sản Bột Lá x Langfarm\r\nTừ nông trại Đà Lạt, bột nguyên chất, công nghệ sấy nhiệt độ thấp, xay chậm siêu mịn', 102000.00, NULL, 0, '/photos/products/botcantayacsanbotla.webp', NULL, 'kg', 0, '2025-12-20 15:08:10', 1, 100, 100000.00, 'botcantayacsanbotla', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `comment` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`review_id`, `product_id`, `user_id`, `rating`, `comment`, `created_at`) VALUES
(1, 1, 2, 5, 'Mực rất tươi và thơm, nướng lên ăn ngon tuyệt!', '2025-10-20 08:30:49');

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` int(11) NOT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `status` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `role` varchar(20) DEFAULT 'USER',
  `created_at` datetime DEFAULT current_timestamp(),
  `status` tinyint(1) DEFAULT 1,
  `email_verified` bit(1) DEFAULT NULL,
  `verification_token` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `full_name`, `email`, `phone`, `address`, `role`, `created_at`, `status`, `email_verified`, `verification_token`) VALUES
(1, 'admin', '123456', 'Nguyễn Văn Admin', 'admin@ashop.com', '0901234567', '123 Đường Quản Trị, TP.HCM', 'ADMIN', '2025-10-20 08:30:49', 1, NULL, NULL),
(2, 'user1', '$2a$10$xxxxxxxxxxxxxxxxxxxxxx', 'Trần Thị Khách', 'khachhang1@mail.com', '0987654321', '456 Đường Đặc Sản, Hà Nội', 'USER', '2025-10-20 08:30:49', 1, NULL, NULL),
(3, 'user2', '123456', 'Lê Văn Mua', 'khachhang2@mail.com', '0919191919', '789 Đường Thử Nghiệm, Đà Nẵng', 'USER', '2025-10-20 08:30:49', 1, NULL, NULL),
(4, 'buituht', '$2a$10$IiadnDNRbJk6tbUmhIIGCORaqiIszPWHRkK9rvd2vD0SUfEphOqV2', 'Tú Bùi', 'pummenvietnam@gmail.com', '0917607635', '940a tổ 15 ấp bình thung 1', 'USER', '2025-10-20 10:05:36', 1, NULL, NULL),
(5, 'tubui', '123456', 'Bùi Thanh Tú', 'tubui@gmail.com', '0917607635', 'Địa chỉ', 'ADMIN', '2025-11-26 19:30:04', 1, NULL, NULL),
(6, 'son.ba', '$2a$10$XQh/1P1fU7Xqs2lBRlaBXeXthWYFH5p80ufdhEpwMrP4h6nlcyw6i', 'Bá Hoài Sơn', 'bason1610@outlook.com', '0326517755', NULL, 'USER', '2025-12-20 09:20:13', 1, b'1', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `vendors`
--

CREATE TABLE `vendors` (
  `vendor_id` int(11) NOT NULL,
  `vendor_name` varchar(150) NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `status` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`contact_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`order_detail_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `fk_product_vendor` (`vendor_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `vendors`
--
ALTER TABLE `vendors`
  ADD PRIMARY KEY (`vendor_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `contact_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `order_details`
--
ALTER TABLE `order_details`
  MODIFY `order_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `vendors`
--
ALTER TABLE `vendors`
  MODIFY `vendor_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_product_vendor` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`vendor_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
