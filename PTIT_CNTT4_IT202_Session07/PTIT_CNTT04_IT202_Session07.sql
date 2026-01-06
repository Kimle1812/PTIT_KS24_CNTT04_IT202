CREATE DATABASE PTIT_CNTT04_IT202_Session07;


-- BÀI 1 :
USE PTIT_CNTT04_IT202_Session07;

CREATE TABLE customers(
	customer_id int primary key auto_increment,
    name varchar(255) not null,
    email varchar(255) not null
);

CREATE TABLE orders(
	order_id int primary key auto_increment,
    customer_id int,
    order_date date default(current_date()),
    total_amount int not null,
    foreign key (customer_id) references customers(customer_id)
);

INSERT INTO customers (name, email) VALUES
('Nguyễn Văn A', 'nva@example.com'),
('Trần Thị B', 'ttb@example.com'),
('Lê Văn C', 'lvc@example.com'),
('Phạm Thị D', 'ptd@example.com'),
('Hoàng Minh E', 'hme@example.com'),
('Vũ Thị F', 'vtf@example.com'),
('Đỗ Quốc G', 'dqg@example.com');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-08-01', 120000),
(2, '2024-08-03', 85000),
(1, '2024-08-10', 45000),
(3, '2024-08-12', 230000),
(4, '2024-08-15', 99000),
(5, '2024-08-20', 150000),
(6, '2024-08-22', 76000),
(7, '2024-08-25', 300000),
(2, '2024-08-28', 54000);

SELECT * FROM customers WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders WHERE customer_id IS NOT NULL);

-- BÀI 2 : 
USE PTIT_CNTT04_IT202_Session07;

CREATE TABLE products(
	product_id int primary key auto_increment,
    product_name varchar(255) not null,
    price decimal(10,0) not null
);

CREATE TABLE order_items(
	order_id int,
    product_id int,
    quantity int not null,
    primary key(order_id, product_id),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

INSERT INTO products (product_name, price) VALUES
('Áo thun nam', 150000),
('Quần jean', 320000),
('Giày thể thao', 750000),
('Mũ lưỡi trai', 120000),
('Túi xách nữ', 450000),
('Đồng hồ', 1250000),
('Kính mát', 220000),
('Vớ thể thao (3 đôi)', 60000),
('Áo khoác', 680000),
('Balo laptop', 390000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 8, 1),
(2, 3, 1),
(3, 2, 1),
(4, 5, 2),
(5, 6, 1),
(6, 7, 3),
(7, 4, 2),
(8, 9, 1),
(9, 8, 4);

SELECT product_id, product_name FROM products WHERE product_id IN (SELECT DISTINCT product_id FROM order_items WHERE product_id IS NOT NULL);

-- BÀI 3 :
USE PTIT_CNTT04_IT202_Session07;

SELECT order_id, order_date, total_amount FROM orders WHERE total_amount > (SELECT AVG(total_amount) FROM orders);

-- BÀI 4 : 
USE PTIT_CNTT04_IT202_Session07;

SELECT name, (
	SELECT COUNT(*) FROM orders WHERE customer_id = customers.customer_id
) AS 'Số lượng đơn'
FROM customers;
-- BÀI 5 : 
USE PTIT_CNTT04_IT202_Session07;

SELECT (
	SELECT name 
    FROM customers 
    WHERE customer_id = t.customer_id) 
    AS customer_name, t.total_spent
FROM (
	SELECT customer_id, SUM(total_amount) 
    AS total_spent 
    FROM orders 
    GROUP BY customer_id) 
    AS t
WHERE t.total_spent = (
	SELECT MAX(total_per_customer) 
    FROM (
		SELECT SUM(total_amount) 
        AS total_per_customer 
        FROM orders 
        GROUP BY customer_id
  ) AS per_customer_totals
);

-- BÀI 6 : 
USE PTIT_CNTT04_IT202_Session07;

SELECT customer_id, (SELECT name FROM customers WHERE customer_id = orders.customer_id) AS 'Tên khách hàng'
FROM orders 
GROUP BY customer_id
HAVING SUM(total_amount) > (SELECT AVG(total_per_customer) FROM ( 
	SELECT SUM(total_amount) AS total_per_customer FROM orders GROUP BY customer_id 
    ) AS per_customer_totals);