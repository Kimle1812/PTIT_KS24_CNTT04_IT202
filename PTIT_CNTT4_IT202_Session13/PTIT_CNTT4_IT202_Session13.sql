-- bai 1 : 
create database Session13;
use Session13;

create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

create table posts (
    post_id int auto_increment primary key,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id)
);

insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

delimiter $$
create trigger trg_after_insert_posts
after insert on posts
for each row
begin
    update users
    set post_count = post_count + 1
    where user_id = new.user_id;
end $$
delimiter ;

delimiter $$
create trigger trg_after_delete_posts
after delete on posts
for each row
begin
    update users
    set post_count = post_count - 1
    where user_id = old.user_id;
end $$
delimiter ;

insert into posts (user_id, content, created_at) values
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

delete from posts where post_id = 2;
select * from users;

-- bai 2 : 
create table likes (
    like_id int auto_increment primary key,
    user_id int,
    post_id int,
    liked_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id),
    foreign key (post_id) references posts(post_id)
);

insert into likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

delimiter $$
create trigger trg_after_insert_likes
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end $$
delimiter ;

delimiter $$
create trigger trg_after_delete_likes
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end $$
delimiter ;

create view user_statistics as
select u.user_id, u.username, u.post_count, ifnull(sum(p.like_count), 0) as total_likes
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.post_count;

insert into likes (user_id, post_id, liked_at)
values (2, 4, now());

select * from posts where post_id = 4;
select * from user_statistics;

delete from likes
where user_id = 2 and post_id = 4;

select * from posts where post_id = 4;
select * from user_statistics;

-- bai 3 : 
create table post_history (
    history_id int auto_increment primary key,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    foreign key (post_id) references posts(post_id) on delete cascade
);

delimiter $$
create trigger trg_before_update_posts
before update on posts
for each row
begin
    if old.content <> new.content then
        insert into post_history (
            post_id, old_content, new_content, changed_at, changed_by_user_id
        )
        values (
            old.post_id, old.content, new.content, now(), old.user_id
        );
    end if;
end $$
delimiter ;

update posts
set content = 'Noi dung bai viet da duoc chinh sua'
where post_id = 1;

select * from post_history;

insert into likes (user_id, post_id) values (2, 1);
delete from likes where user_id = 2 and post_id = 1;

-- bai 4 ; 
use social_trigger_demo;

create table if not exists post_history (
    history_id int auto_increment primary key,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    foreign key (post_id) references posts(post_id) on delete cascade
);

drop trigger if exists trg_before_update_posts;

delimiter $$
create trigger trg_before_update_posts
before update on posts
for each row
begin
    if old.content <> new.content then
        insert into post_history (
            post_id, old_content, new_content, changed_at, changed_by_user_id
        )
        values (
            old.post_id,
            old.content,
            new.content,
            now(),
            old.user_id
        );
    end if;
end $$
delimiter ;

-- bai 5 : 
use social_trigger_demo;

delimiter $$
create trigger trg_before_insert_users
before insert on users
for each row
begin
    if new.email not like '%_@_%._%' then
        signal sqlstate '45000' 
        set message_text = 'Email không hợp lệ. Phải chứa @ và .';
    end if;

    if new.username regexp '[^a-zA-Z0-9_]' then
        signal sqlstate '45000'
        set message_text = 'Username không hợp lệ. Chỉ dùng chữ, số và _';
    end if;
end $$
delimiter ;

delimiter $$
create procedure add_user(
    in p_username varchar(50),
    in p_email varchar(100),
    in p_created_at date
)
begin
    insert into users (username, email, created_at)
    values (p_username, p_email, p_created_at);
end $$
delimiter ;

select * from users;

-- bai 6 
use social_trigger_demo;

create table if not exists friendships (
    follower_id int,
    followee_id int,
    status enum('pending','accepted') default 'accepted',
    primary key(follower_id, followee_id),
    foreign key(follower_id) references users(user_id) on delete cascade,
    foreign key(followee_id) references users(user_id) on delete cascade
);

delimiter $$
create trigger trg_after_insert_friendships
after insert on friendships
for each row
begin
    if new.status='accepted' then
        update users set follower_count=follower_count+1
        where user_id=new.followee_id;
    end if;
end $$
delimiter ;

delimiter $$
create trigger trg_after_delete_friendships
after delete on friendships
for each row
begin
    if old.status='accepted' then
        update users set follower_count=follower_count-1
        where user_id=old.followee_id;
    end if;
end $$
delimiter ;

delimiter $$
create procedure follow_user(in fid int, in feid int, in st enum('pending','accepted'))
begin
    if fid=feid then
        signal sqlstate '45000' set message_text='Không thể tự follow';
    end if;
    if exists(select 1 from friendships where follower_id=fid and followee_id=feid) then
        signal sqlstate '45000' set message_text='Đã follow trước đó';
    end if;
    insert into friendships(follower_id, followee_id, status) values(fid, feid, st);
end $$
delimiter ;

create or replace view user_profile as
select u.user_id, u.username, u.follower_count, u.post_count, ifnull(sum(p.like_count),0) as total_likes
from users u
left join posts p on u.user_id=p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count;

call follow_user(2,3,'accepted');  
select user_id, username, follower_count from users;

delete from friendships where follower_id=2 and followee_id=3;  
select user_id, username, follower_count from users;

select * from user_profile;
