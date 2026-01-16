
CREATE DATABASE StudentManagement;
USE StudentManagement;

-- Table: Students
CREATE TABLE Students (
    StudentID CHAR(5) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    TotalDebt DECIMAL(10,2) DEFAULT 0
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID CHAR(5) PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL,
    Credits INT CHECK (Credits > 0)
);

-- Table: Grades
CREATE TABLE Grades (
    StudentID CHAR(5),
    SubjectID CHAR(5),
    Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),
    PRIMARY KEY (StudentID, SubjectID),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Grades_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Table: GradeLog
CREATE TABLE GradeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID CHAR(5),
    OldScore DECIMAL(4,2),
    NewScore DECIMAL(4,2),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert Students
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES 
('SV01', 'Ho Khanh Linh', 5000000),
('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO Subjects (SubjectID, SubjectName, Credits) VALUES 
('SB01', 'Co so du lieu', 3),
('SB02', 'Lap trinh Java', 4),
('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES 
('SV01', 'SB01', 8.5), -- Passed
('SV03', 'SB02', 3.0); -- Failed


-- PHẦN A – CƠ BẢN

-- Câu 1
DELIMITER $$

CREATE TRIGGER tg_CheckScore
BEFORE INSERT ON Grades
FOR EACH ROW
BEGIN
    IF NEW.Score < 0 THEN
        SET NEW.Score = 0;
    END IF;
    IF NEW.Score > 10 THEN
        SET NEW.Score = 10;
    END IF;
END$$

DELIMITER ;

INSERT INTO Grades (StudentID, SubjectID, Score) VALUES ('SV03','SB03',-5);
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES ('SV02','SB01',12);
SELECT * FROM Grades;

-- Câu 2
START TRANSACTION;
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES ('SV02', 'Ha Bich Ngoc', 0);
UPDATE Students SET TotalDebt = 5000000 WHERE StudentID = 'SV02';
COMMIT;

SELECT * FROM Students WHERE StudentID = 'SV04';

-- PHẦN B – KHÁ

-- Câu 3
DELIMITER $$

CREATE TRIGGER tg_LogGradeUpdate
AFTER UPDATE ON Grades
FOR EACH ROW
BEGIN
    IF OLD.Score <> NEW.Score THEN
        INSERT INTO GradeLog (StudentID, OldScore, NewScore, ChangeDate) VALUES (OLD.StudentID, OLD.Score, NEW.Score, NOW());
    END IF;
END$$

DELIMITER ;

UPDATE Grades SET Score = 6.0 WHERE StudentID = 'SV03' AND SubjectID = 'SB02';
SELECT * FROM GradeLog;

-- Câu 4
DELIMITER $$

CREATE PROCEDURE sp_PayTuition()
BEGIN
    DECLARE currentDebt DECIMAL(10,2);
    START TRANSACTION;
    UPDATE Students SET TotalDebt = TotalDebt - 2000000 WHERE StudentID = 'SV01';
    SELECT TotalDebt INTO currentDebt FROM Students WHERE StudentID = 'SV01';
    IF currentDebt < 0 THEN
        ROLLBACK;
    ELSE
        COMMIT; 
    END IF;
END$$

DELIMITER ;

CALL sp_PayTuition();
SELECT * FROM Students WHERE StudentID = 'SV01';

-- PHẦN C – GIỎI

-- Câu 5
DELIMITER $$

CREATE TRIGGER tg_PreventPassUpdate
BEFORE UPDATE ON Grades
FOR EACH ROW
BEGIN
    IF OLD.Score >= 4.0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không được phép sửa điểm của sinh viên đã qua môn!';
    END IF;
END$$

DELIMITER ;

UPDATE Grades SET Score = 9.0 WHERE StudentID = 'SV01' AND SubjectID = 'SB01';

-- Câu 6
DELIMITER $$
CREATE PROCEDURE sp_DeleteStudentGrade(
	IN p_StudentID CHAR(5),
    IN p_SubjectID CHAR(5)
)
BEGIN
	DECLARE v_OldScore DECIMAL(10,2);
    START TRANSACTION;
    SELECT Score INTO v_OldScore FROM Grades WHERE StudentID = p_StudentID AND SubjectID = p_SubjectID;
    INSERT INTO GradeLog (StudentID, OldScore, NewScore, ChangeDate) VALUES (p_StudentID, v_OldScore, NULL, NOW());
    DELETE FROM Grades WHERE StudentID = p_StudentID AND SubjectID = p_SubjectID;
    IF ROW_COUNT() = 0 THEN 
		ROLLBACK; 
    ELSE 
		COMMIT;
    END IF;
END$$

DELIMITER ;

CALL sp_DeleteStudentGrade('SV03','SB02');
SELECT * FROM GradeLog WHERE StudentID='SV03';
SELECT * FROM Grades WHERE StudentID='SV03' AND SubjectID='SB02';


