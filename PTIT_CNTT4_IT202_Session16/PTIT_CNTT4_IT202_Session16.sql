-- bài 1 : 


-- 2.1 Viết câu lệnh tạo cơ sở dữ liệu tên quanlybanhang .
create database quanlybanhang;
use quanlybanhang;

-- 2.2 Viết câu lệnh tạo 5 bảng theo mô tả ở trên.
create table customers (
    customer_id int auto_increment primary key,
    customer_name varchar(100) not null,
    phone varchar(20) not null unique,
    address varchar(255)
);

create table products (
    product_id int auto_increment primary key,
    product_name varchar(100) not null unique,
    price decimal(10,2) not null,
    quantity int not null check (quantity >= 0),
    category varchar(50) not null
);

create table employees (
    employee_id int auto_increment primary key,
    employee_name varchar(100) not null,
    birthday date,
    position varchar(50) not null,
    salary decimal(10,2) not null,
    revenue decimal(10,2) default 0
);

create table orders (
    order_id int auto_increment primary key,
    customer_id int,
    employee_id int,
    order_date datetime default current_timestamp,
    total_amount decimal(10,2) default 0,
    foreign key (customer_id) references customers(customer_id),
    foreign key (employee_id) references employees(employee_id)
);

create table orderdetails (
    order_detail_id int auto_increment primary key,
    order_id int,
    product_id int,
    quantity int not null check (quantity > 0),
    unit_price decimal(10,2) not null,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

-- 3.1 Thêm cột email có kiểu dữ liệu varchar(100) not null unique vào bảng Customers
alter table customers
add email varchar(100) not null unique;

-- 3.2 Xóa cột ngày sinh ra khỏi bảng Employees
alter table employees
drop column birthday;

-- PHẦN 2: TRUY VẤN DỮ LIỆU

-- Câu 4 Viết câu lệnh chèn dữ liệu vào bảng (mỗi bảng ít nhất 5 bản ghi phù hợp)
insert into customers (customer_name, phone, address, email) values
('nguyen a', '090000001', 'ha noi', 'a@gmail.com'),
('tran b', '090000002', 'hai phong', 'b@gmail.com'),
('le c', '090000003', 'da nang', 'c@gmail.com'),
('pham d', '090000004', 'hcm', 'd@gmail.com'),
('hoang e', '090000005', 'can tho', 'e@gmail.com');

insert into products (product_name, price, quantity, category) values
('laptop hp', 500, 200, 'laptop'),
('chuot logitech', 20, 500, 'phu kien'),
('ban phim corsair', 50, 300, 'phu kien'),
('man hinh dell', 150, 150, 'man hinh'),
('tai nghe sony', 80, 250, 'am thanh');

insert into employees (employee_name, position, salary) values
('nhan vien 1', 'ban hang', 500),
('nhan vien 2', 'ban hang', 550),
('nhan vien 3', 'quan ly', 1000),
('nhan vien 4', 'ke toan', 700),
('nhan vien 5', 'ban hang', 520);

insert into orders (customer_id, employee_id, total_amount) values
(1, 1, 100),
(2, 2, 200),
(3, 3, 300),
(1, 2, 150),
(4, 1, 400);

insert into orderdetails (order_id, product_id, quantity, unit_price) values
(1, 1, 2, 500),
(1, 2, 5, 20),
(2, 3, 3, 50),
(3, 4, 4, 150),
(4, 5, 6, 80);

-- 5.1 Lấy danh sách tất cả khách hàng từ bảng Customers. Thông tin gồm : mã khách hàng, tên khách hàng, email, số điện thoại và địa chỉ
select customer_id, customer_name, email, phone, address
from customers;

-- 5.2 Sửa thông tin của sản phẩm có product_id = 1 theo yêu cầu : product_name= “Laptop Dell XPS” và price = 99.99
update products set product_name = 'laptop dell xps', price = 99.99
where product_id = 1;

-- 5.3 Lấy thông tin những đơn đặt hàng gồm : mã đơn hàng, tên khách hàng, tên nhân viên, tổng tiền và ngày đặt hàng.
select o.order_id, c.customer_name, e.employee_name, o.total_amount, o.order_date from orders o
join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id;

-- 6.1 Đếm số lượng đơn hàng của mỗi khách hàng. Thông tin gồm : mã khách hàng, tên khách hàng, tổng số đơn
select c.customer_id, c.customer_name, count(o.order_id) as total_orders from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name;

-- 6.2 Thống kê tổng doanh thu của từng nhân viên trong năm hiện tại. Thông tin gồm :mã nhân viên, tên nhân viên, doanh thu
select e.employee_id, e.employee_name, sum(o.total_amount) as revenue from employees e
join orders o on e.employee_id = o.employee_id
where year(o.order_date) = year(current_date)
group by e.employee_id, e.employee_name;

-- 6.3 Thống kê những sản phẩm có số lượng đặt hàng lớn hơn 100 trong tháng hiện tại.Thông tin gồm : mã sản phẩm, tên sản phẩm, số lượt đặt và sắp xếp theo số lượng giảm dần
select p.product_id, p.product_name, sum(od.quantity) as total_quantity from orderdetails od
join orders o on od.order_id = o.order_id
join products p on od.product_id = p.product_id
where month(o.order_date) = month(current_date) and year(o.order_date) = year(current_date)
group by p.product_id, p.product_name
having sum(od.quantity) > 100
order by total_quantity desc;

-- 7.1 Lấy danh sách khách hàng chưa từng đặt hàng. Thông tin gồm : mã khách hàng và tên khách hàng
select c.customer_id, c.customer_name from customers c
left join orders o on c.customer_id = o.customer_id
where o.order_id is null;

-- 7.2 Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
select * from products
where price > (select avg(price) from products);

-- 7.3 Tìm những khách hàng có mức chi tiêu cao nhất. Thông tin gồm : mã khách hàng, tên khách hàng và tổng chi tiêu .(Nếu các khách hàng có cùng mức chi tiêu thì lấy hết)
select c.customer_id, c.customer_name, sum(o.total_amount) as total_spent from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_amount) = (
    select max(t.total_spent)
    from (
        select sum(total_amount) as total_spent
        from orders
        group by customer_id
    )
);

-- 8.1 Tạo view có tên view_order_list hiển thị thông tin đơn hàng gồm : mã đơn hàng, tên khách hàng, tên nhân viên, tổng tiền và ngày đặt. Các bản ghi sắp xếp theo thứ tự ngày đặt mới nhất
create view view_order_list as
select o.order_id, c.customer_name, e.employee_name, o.total_amount, o.order_date from orders o
join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id
order by o.order_date desc;

-- 8.2 Tạo view có tên view_order_detail_product hiển thị chi tiết đơn hàng gồm : Mã chi tiết đơn hàng, tên sản phẩm, số lượng và giá tại thời điểm mua. Thông tin sắp xếp theo số lượng giảm dần
create view view_order_detail_product as
select od.order_detail_id, p.product_name, od.quantity, od.unit_price from orderdetails od
join products p on od.product_id = p.product_id
order by od.quantity desc;

-- 9.1 Tạo thủ tục có tên proc_insert_employee nhận vào các thông tin cần thiết (trừ mã nhân viên và tổng doanh thu) , thực hiện thêm mới dữ liệu vào bảng nhân viên và trả về mã nhân viên vừa mới thêm.
delimiter $$

create procedure proc_insert_employee(
    in p_name varchar(100),
    in p_position varchar(50),
    in p_salary decimal(10,2),
    out new_id int
)
begin
    insert into employees(employee_name, position, salary)
    values (p_name, p_position, p_salary);

    set new_id = last_insert_id();
end$$

delimiter ;

-- 9.2 Tạo thủ tục có tên proc_get_orderdetails lọc những chi tiết đơn hàng dựa theo mã đặt hàng.
delimiter $$

create procedure proc_get_orderdetails(in p_order_id int)
begin
    select *
    from orderdetails
    where order_id = p_order_id;
end$$

delimiter ;

-- 9.3 Tạo thủ tục có tên proc_cal_total_amount_by_order nhận vào tham số là mã đơn hàng và trả về số lượng loại sản phẩm trong đơn hàng đó.
delimiter $$

create procedure proc_cal_total_amount_by_order(
    in p_order_id int,
    out total_products int
)
begin
    select count(distinct product_id)
    into total_products
    from orderdetails
    where order_id = p_order_id;
end$$

delimiter ;

-- Câu 10 Tạo trigger có tên trigger_after_insert_order_details để tự động cập nhật số lượng sản phẩm trong kho mỗi khi thêm một chi tiết đơn hàng mới. Nếu số lượng trong kho không đủ thì ném ra thông báo lỗi “Số lượng sản phẩm trong kho không đủ” và hủy thao tác chèn.
delimiter $$

create trigger trigger_after_insert_order_details
before insert on orderdetails
for each row
begin
    declare current_stock int;

    select quantity into current_stock
    from products
    where product_id = new.product_id;

    if current_stock < new.quantity then
        signal sqlstate '45000'
        set message_text = 'so luong san pham trong kho khong du';
    else
        update products
        set quantity = quantity - new.quantity
        where product_id = new.product_id;
    end if;
end$$

delimiter ;
-- Câu 11: Quản lý transaction
delimiter $$

create procedure proc_insert_order_details(
    in p_order_id int,
    in p_product_id int,
    in p_quantity int,
    in p_unit_price decimal(10,2)
)
begin
    declare order_count int;

    start transaction;

    select count(*) into order_count
    from orders
    where order_id = p_order_id;

    if order_count = 0 then
        signal sqlstate '45000'
        set message_text = 'khong ton tai ma hoa don';
        rollback;
    else
        insert into orderdetails(order_id, product_id, quantity, unit_price)
        values (p_order_id, p_product_id, p_quantity, p_unit_price);

        update orders
        set total_amount = total_amount + (p_quantity * p_unit_price)
        where order_id = p_order_id;

        commit;
    end if;
end$$

delimiter ;
















