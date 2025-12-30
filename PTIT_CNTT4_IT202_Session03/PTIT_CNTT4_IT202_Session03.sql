CREATE DATABASE IT202_Session03;
USE IT202_Session02;

-- Bài 1
CREATE TABLE Student(
	student_id int primary key,
    full_name varchar(100) not null,
    date_of_birth date,
    email varchar(100) unique
);

INSERT INTO Student (student_id, full_name, date_of_birth, email) VALUES 
	(1, 'Nguyen Thi Kim Le', '2006-12-18', 'kimle@gmail.com'),
    (2, 'Doan Ngoc Duy', '2006-01-01', 'doanduy@gmail.com'),
    (3, 'Duong Duc Loc', '2006-01-01', 'ducloc@gmail.com');
    
SELECT * FROM Student;
SELECT student_id, full_name FROM Student;

-- Bài 2
UPDATE Student
SET email = 'ducloc@gmail.com'
WHERE student_id = 3;

UPDATE Student
SET date_of_birth = '2006-01-01'
WHERE student_id = 2;

DELETE FROM Student
WHERE student_id = 5;

SELECT * FROM Student;

-- Bài 3
CREATE TABLE Subject(
	subject_id int primary key,
	subject_name varchar(100) not null,
	credit int check (credit > 0)
);

INSERT INTO Subject(subject_id, subject_name, credit) VALUES
(001, 'Reactjs', 4),
(002, 'Frontend cơ bản', 3),
(003, 'Java', 6);

UPDATE Subject
SET credit = 8
WHERE subject_id = 003;

UPDATE Subject
SET subject_name = 'CSDL'
WHERE subject_id = 002;

SELECT * FROM Subject;

-- Bài 4
CREATE TABLE Student(
	student_id int primary key,
    full_name varchar(100) not null,
    date_of_birth date,
    email varchar(100) unique
);

CREATE TABLE Subject(
	subject_id int primary key,
	subject_name varchar(100) not null,
	credit int check (credit > 0)
);

CREATE TABLE Enrollment(
	student_id int,
    subject_id int,
    enroll_date date not null,
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) references Student(student_id),
    CONSTRAINT fk_enroll_subject FOREIGN KEY (subject_id) references Subject(subject_id)
);

INSERT INTO Student (student_id, full_name, date_of_birth, email) VALUES 
	(1, 'Nguyen Thi Kim Le', '2006-12-18', 'kimle@gmail.com'),
    (2, 'Doan Ngoc Duy', '2006-01-01', 'doanduy@gmail.com'),
    (3, 'Duong Duc Loc', '2006-01-01', 'ducloc@gmail.com');
    
INSERT INTO Subject(subject_id, subject_name, credit) VALUES
	(001, 'Reactjs', 4),
	(002, 'Frontend cơ bản', 3),
	(003, 'Java', 6);

INSERT INTO Enrollment(student_id, subject_id, enroll_date) VALUES
(1, 001, '2025-11-03'),
(2, 002, '2025-12-15'),
(1, 002, '2025-12-03'),
(1, 003, '2026-01-03'),
(2, 001, '2025-11-05');

SELECT * FROM Enrollment;

SELECT student_id, subject_id, enroll_date FROM Enrollment WHERE student_id = 1;
-- Bài 5
CREATE TABLE Score (
    student_id int,
    subject_id int,
    mid_score float check(mid_score>=0 AND mid_score<=10) NOT NULL,
    final_score float check(final_score>=0 AND final_score<=10) NOT NULL,
    primary key (student_id, subject_id),
	foreign key (student_id) references Student(student_id),
    foreign key (subject_id) references Subject(subject_id)
);

INSERT INTO Score(student_id, subject_id, mid_score, final_score) VALUES
(1, 001, 9.8, 9.5),
(2, 002, 8.2, 8);

UPDATE Score
SET final_score = 8.5
WHERE student_id = 2 and subject_id = 002;

SELECT * FROM Score;
SELECT * FROM Score WHERE final_score >= 8;

-- Bài 6
CREATE TABLE Student (
    student_id int primary key,
    student_name varchar(100) NOT NULL
);

CREATE TABLE Course (
    course_id int primary key,
    course_name varchar(100) NOT NULL UNIQUE,
    credit int check(credit > 0)
);

CREATE TABLE Enrollment (
    student_id int,
    course_id int,
    enrollment_date DATE NOT NULL,
    primary key (student_id, course_id),
    CONSTRAINT fk_enroll_student foreign key (student_id) references Student(student_id),
    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) references Course(course_id)
);

CREATE TABLE Score (
    student_id int,
    course_id int,
    course_grade float check(course_grade>=0 AND course_grade<=10) NOT NULL,
    final_exam_grade float check(final_exam_grade>=0 AND final_exam_grade<=10) NOT NULL,
    primary key (student_id, course_id),
	foreign key (student_id) references Student(student_id),
    foreign key (course_id) references Course(course_id)
);

INSERT INTO Student(student_id, student_name) VALUES
(001, 'Nguyễn Thị Kim Lệ'),
(002, 'Doãn Ngọc Duy'),
(003, 'Dương Đức Lộc');

INSERT INTO Course(course_id, course_name, credit) VALUES
(001, 'Reactjs', 4),
(002, 'Java', 6);

INSERT INTO Enrollment(student_id, course_id, enrollment_date) VALUES
(001, 001, '2025-11-03'),
(003, 002, '2025-12-15');

INSERT INTO Score(student_id, course_id, course_grade, final_exam_grade) VALUES
(001, 001, 9.8, 9.5),
(003, 002, 8.2, 8);

UPDATE Score
SET course_grade = 9.5, final_exam_grade = 9.2
WHERE student_id = 001 and course_id = 001;

DELETE FROM Score
WHERE student_id = 003 and course_id = 002;

SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM Enrollment;
SELECT * FROM Score;