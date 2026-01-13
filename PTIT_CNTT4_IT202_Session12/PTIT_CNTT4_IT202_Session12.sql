CREATE DATABASE StudentDBS;
USE StudentDBS;

-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID CHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID CHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID CHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID CHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID CHAR(6),
    CourseID CHAR(6),
    Score FLOAT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Thêm dữ liệu
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course VALUES
('C00001','Database Systems',3),
('C00002','C Programming',3),
('C00003','Microeconomics',2),
('C00004','Financial Accounting',3);

INSERT INTO Enrollment VALUES
('S00001','C00001',8.5),
('S00001','C00002',7.0),
('S00002','C00001',6.5),
('S00003','C00003',7.5),
('S00004','C00004',8.0),
('S00005','C00001',9.0),
('S00006','C00003',6.0),
('S00007','C00004',7.0),
('S00008','C00001',5.5),
('S00008','C00002',6.5);

-- PHẦN A – CƠ BẢN
-- Câu 1: View hiển thị StudentID, FullName, DeptName
CREATE VIEW View_StudentBasic AS 
SELECT S.StudentID, S.FullName, D.DeptName 
FROM Student S
JOIN Department D ON S.DeptID = D.DeptID;

SELECT * FROM View_StudentBasic;

-- Câu 2: Index cho FullName
CREATE INDEX IDX_Student_FullName
ON Student(FullName);

-- Câu 3: Stored Procedure GetStudentsIT
DELIMITER $$
CREATE PROCEDURE GetStudentsIT()
BEGIN 
    SELECT S.StudentID, S.FullName, D.DeptName 
    FROM Student S
    JOIN Department D ON S.DeptID = D.DeptID
    WHERE D.DeptName = 'Information Technology';
END $$
DELIMITER ;

CALL GetStudentsIT();

-- PHẦN B – KHÁ
-- Câu 4a: View đếm số sinh viên theo khoa
CREATE VIEW View_StudentCountByDept AS
SELECT D.DeptName, COUNT(S.StudentID) AS TotalStudents 
FROM Department D
LEFT JOIN Student S ON S.DeptID = D.DeptID
GROUP BY D.DeptName;

-- Câu 4b: Khoa có nhiều sinh viên nhất
SELECT * FROM View_StudentCountByDept 
ORDER BY TotalStudents DESC
LIMIT 1;

-- Câu 5a: Stored Procedure GetTopScoreStudent
DELIMITER $$
CREATE PROCEDURE GetTopScoreStudent(
    IN p_CourseID CHAR(6)
)
BEGIN 
    SELECT S.StudentID, S.FullName, E.Score  
    FROM Enrollment E
    JOIN Student S ON E.StudentID = S.StudentID
    WHERE E.CourseID = p_CourseID
      AND E.Score = (
          SELECT MAX(Score) 
          FROM Enrollment
          WHERE CourseID = p_CourseID
      );
END $$
DELIMITER ;

-- Câu 5b: Gọi thủ tục cho môn Database Systems
CALL GetTopScoreStudent('C00001');

-- PHẦN C – GIỎI
-- Bài 6a: View sinh viên IT học Database Systems


-- Bài 6b: Stored Procedure UpdateScore_IT_DB

-- Bài 6c: Gọi thủ tục để sửa điểm

-- Kiểm tra lại kết quả
