CREATE DATABASE mini_Prj;
USE mini_Prj;

CREATE TABLE Student (
    id_stu INT PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Courses (
    id_coures INT PRIMARY KEY,
    name_coures VARCHAR(100) NOT NULL,
    describe_coures VARCHAR(255),
    lession INT NOT NULL CHECK (lession > 0)
);

CREATE TABLE Teacher (
    id_tea INT PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    id_coures INT,
    FOREIGN KEY (id_coures) REFERENCES Courses(id_coures)
);

CREATE TABLE Enrollment (
    id_stu INT,
    id_coures INT,
    date_enrollment DATE NOT NULL,
    PRIMARY KEY (id_stu, id_coures),
    FOREIGN KEY (id_stu) REFERENCES Student(id_stu),
    FOREIGN KEY (id_coures) REFERENCES Courses(id_coures)
);

CREATE TABLE Score (
    midterm_score DECIMAL(4,1) CHECK (midterm_score BETWEEN 0 AND 10),
    last_score DECIMAL(4,1) CHECK (last_score BETWEEN 0 AND 10),
    id_stu INT,
    id_coures INT,
    PRIMARY KEY (id_stu, id_coures),
    FOREIGN KEY (id_stu) REFERENCES Student(id_stu),
    FOREIGN KEY (id_coures) REFERENCES Courses(id_coures)
);

INSERT INTO Student VALUES
(1, 'Nguyen Van A', '2000-04-04', 'a@gmail.com'),
(2, 'Nguyen Van B', '2000-05-04', 'b@gmail.com'),
(3, 'Nguyen Van C', '2000-04-03', 'c@gmail.com'),
(4, 'Nguyen Van D', '2000-09-04', 'd@gmail.com'),
(5, 'Nguyen Van E', '2000-04-01', 'e@gmail.com');

INSERT INTO Courses VALUES
(1, 'Lap trinh C', 'Lam quen voi IT', 10),
(2, 'DSA', 'Giai thuat voi C++', 12),
(3, 'Lap trinh Web ReactJS', 'Lap trinh web nang cao', 13),
(4, 'AI co ban', 'Lam quen voi AI', 14),
(5, 'Lap trinh mang', 'Mang may tinh', 15);

INSERT INTO Teacher VALUES
(1, 'Nguyen Van GV1', 'gv1@gmail.com', 1),
(2, 'Nguyen Van GV2', 'gv2@gmail.com', 2),
(3, 'Nguyen Van GV3', 'gv3@gmail.com', 3),
(4, 'Nguyen Van GV4', 'gv4@gmail.com', 2),
(5, 'Nguyen Van GV5', 'gv5@gmail.com', 1);

INSERT INTO Enrollment VALUES
(1, 1, '2020-02-02'),
(1, 2, '2020-05-02'),
(2, 2, '2020-05-02'),
(2, 4, '2020-02-02'),
(5, 1, '2020-08-02');

INSERT INTO Score VALUES
(8.0, 8.5, 1, 1),
(7.5, 9.0, 1, 2),
(6.0, 7.0, 2, 2),
(8.0, 8.5, 2, 4),
(9.5, 9.5, 5, 1);

UPDATE Student
SET email = 'updated@gmail.com'
WHERE id_stu = 1;

UPDATE Courses
SET describe_coures = 'Cap nhat noi dung khoa hoc'
WHERE id_coures = 1;

UPDATE Score
SET last_score = 10.0
WHERE id_stu = 1 AND id_coures = 1;

DELETE FROM Enrollment
WHERE id_stu = 2 AND id_coures = 4;

DELETE FROM Score
WHERE id_stu = 2 AND id_coures = 4;

SELECT * FROM Student;
SELECT * FROM Teacher;
SELECT * FROM Courses;
SELECT * FROM Enrollment;
SELECT * FROM Score;
