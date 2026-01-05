CREATE DATABASE Homework;


-- BÀI 1 :
USE Homework;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    city VARCHAR(255)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, full_name, city) VALUES
(1, 'Nguyễn Văn A', 'Hà Nội'),
(2, 'Trần Thị B', 'TP. Hồ Chí Minh'),
(3, 'Lê Văn C', 'Đà Nẵng'),
(4, 'Phạm Minh D', 'Cần Thơ'),
(5, 'Hoàng Anh E', 'Hải Phòng');

INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(101, 1, '2023-10-01', 'completed'),
(102, 1, '2023-10-05', 'pending'),
(103, 2, '2023-10-10', 'completed'),
(104, 3, '2023-10-12', 'cancelled'),
(105, 5, '2023-10-15', 'completed');

	-- Hiển thị danh sách đơn hàng kèm tên khách hàng
SELECT o.order_id, c.full_name, o.order_date, o.status 
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id;

	-- Hiển thị mỗi khách hàng đã đặt bao nhiêu đơn hàng (bao gồm cả khách chưa đặt đơn nào)
SELECT c.full_name, COUNT(o.order_id) AS total_orders 
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id 
GROUP BY c.customer_id, c.full_name;

	-- Chỉ hiển thị các khách hàng có ít nhất 1 đơn hàng
SELECT DISTINCT c.full_name 
FROM customers c 
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- BÀI 2 : 
USE Homework;

ALTER TABLE orders ADD COLUMN total_amount DECIMAL(10,2);

UPDATE orders SET total_amount = 150.00 WHERE order_id = 101;
UPDATE orders SET total_amount = 200.50 WHERE order_id = 102;
UPDATE orders SET total_amount = 500.00 WHERE order_id = 103;
UPDATE orders SET total_amount = 75.25  WHERE order_id = 104;
UPDATE orders SET total_amount = 320.00 WHERE order_id = 105;

	-- Hiển thị tổng tiền mà mỗi khách hàng đã chi tiêu
SELECT c.full_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

	-- Hiển thị giá trị đơn hàng cao nhất của từng khách
SELECT c.full_name, MAX(o.total_amount) AS highest_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

	-- Sắp xếp danh sách khách hàng theo tổng tiền giảm dần
SELECT c.full_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;

-- BÀI 3 :
USE Homework;

SELECT 
    order_date AS 'Ngày',
    SUM(total_amount) AS 'Tổng doanh thu',
    COUNT(order_id) AS 'Số lượng đơn hàng'
FROM orders
WHERE status = 'completed'
GROUP BY order_date
HAVING SUM(total_amount) > 10000000;

-- BÀI 4 : 
USE Homework;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'iPhone 15 Pro', 28000000),
(2, 'Sạc dự phòng 20W', 500000),
(3, 'Ốp lưng Silicon', 200000),
(4, 'Tai nghe Airpods 3', 4500000),
(5, 'Chuột không dây', 800000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(101, 1, 1), -- Đơn 101 mua 1 iPhone
(102, 2, 2), -- Đơn 102 mua 2 sạc
(103, 1, 2), -- Đơn 103 mua 2 iPhone (Doanh thu > 5tr)
(104, 4, 1), -- Đơn 104 mua 1 tai nghe
(105, 5, 10); -- Đơn 105 mua 10 chuột (Doanh thu 8tr > 5tr)

SELECT 
    p.product_name AS 'Tên sản phẩm',
    SUM(oi.quantity) AS 'Số lượng đã bán',
    SUM(oi.quantity * p.price) AS 'Doanh thu sản phẩm'
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity * p.price) > 5000000;

-- BÀI 5 : 
USE Homework;

SELECT 
    c.full_name AS 'Tên khách hàng',
    COUNT(o.order_id) AS 'Tổng số đơn hàng',
    SUM(o.total_amount) AS 'Tổng số tiền đã chi',
    AVG(o.total_amount) AS 'Giá trị đơn hàng trung bình'
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 3 
   AND SUM(o.total_amount) > 10000000
ORDER BY SUM(o.total_amount) DESC;

-- BÀI 6 : 
USE Homework;

SELECT 
    p.product_name AS 'Tên sản phẩm',
    SUM(oi.quantity) AS 'Tổng số lượng bán',
    SUM(oi.quantity * p.price) AS 'Tổng doanh thu',
    AVG(p.price) AS 'Giá bán trung bình' 
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) >= 10
ORDER BY SUM(oi.quantity * p.price) DESC
LIMIT 5;