CREATE DATABASE IF NOT EXISTS college_db;
USE college_db;


CREATE TABLE IF NOT EXISTS SubjectAllotments (
    StudentId VARCHAR(50),
    SubjectId VARCHAR(50),
    Is_valid BOOLEAN
);

CREATE TABLE IF NOT EXISTS SubjectRequest (
    StudentId VARCHAR(50),
    SubjectId VARCHAR(50)
);

-- Existing subject history of student
INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid)
VALUES
('159103036', 'PO1491', 1),
('159103036', 'PO1492', 0),
('159103036', 'PO1493', 0),
('159103036', 'PO1494', 0),
('159103036', 'PO1495', 0);

-- New subject change request
INSERT INTO SubjectRequest (StudentId, SubjectId)
VALUES
('159103036', 'PO1496');

DELIMITER $$

CREATE PROCEDURE ProcessSubjectRequests()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_StudentId VARCHAR(50);
    DECLARE v_RequestedSubjectId VARCHAR(50);
    DECLARE v_CurrentSubjectId VARCHAR(50);

    DECLARE cur CURSOR FOR
        SELECT StudentId, SubjectId FROM SubjectRequest;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_StudentId, v_RequestedSubjectId;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Check if student exists
        IF EXISTS (SELECT 1 FROM SubjectAllotments WHERE StudentId = v_StudentId) THEN

            -- Get current subject
            SELECT SubjectId INTO v_CurrentSubjectId
            FROM SubjectAllotments
            WHERE StudentId = v_StudentId AND Is_valid = TRUE
            LIMIT 1;

            -- If requested subject is different
            IF v_RequestedSubjectId <> v_CurrentSubjectId THEN
                -- Invalidate current
                UPDATE SubjectAllotments
                SET Is_valid = FALSE
                WHERE StudentId = v_StudentId AND Is_valid = TRUE;

                -- Insert new subject
                INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid)
                VALUES (v_StudentId, v_RequestedSubjectId, TRUE);
            END IF;

        ELSE
            -- If student is new
            INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid)
            VALUES (v_StudentId, v_RequestedSubjectId, TRUE);
        END IF;

    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;

SET SQL_SAFE_UPDATES = 0;
CALL ProcessSubjectRequests();
SET SQL_SAFE_UPDATES = 1;

CALL ProcessSubjectRequests();

SELECT * FROM SubjectAllotments WHERE StudentId = '159103036';

