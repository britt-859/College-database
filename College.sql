-- part 1 creating tables

CREATE TABLE PROFESSOR (
	ID              char(10)    NOT NULL,    
	first           varchar(25),
	last            varchar(25),
	PRIMARY KEY (ID)
)       CHARACTER SET 'utf8mb4'
        COLLATE 'utf8mb4_unicode_520_ci';

CREATE TABLE STUDENT (
        ID              char(10)    NOT NULL,
        first           varchar(25),
        last            varchar(25),
        major           varchar(255),
        PRIMARY KEY (ID)
)       CHARACTER SET 'utf8mb4'
        COLLATE 'utf8mb4_unicode_520_ci';

CREATE TABLE COURSE (
        catnum          int            NOT NULL,   -- primary key 
        description     varchar(500)  NOT NULL,   -- candidate key
        ge_area         char(1),
        units           int,
        PRIMARY KEY (catnum)
)       CHARACTER SET 'utf8mb4'
        COLLATE 'utf8mb4_unicode_520_ci';

CREATE TABLE PROF_EMAIL (
        ID              char(10)        NOT NULL, -- part of primary key
        email           varchar(185)    NOT NULL, -- part of primary key
        PRIMARY KEY (ID, email),
        FOREIGN KEY (ID) REFERENCES PROFESSOR (ID)
                ON DELETE CASCADE
                ON UPDATE RESTRICT
)       CHARACTER SET 'utf8mb4'
        COLLATE 'utf8mb4_unicode_520_ci';

CREATE TABLE STUDENT_EMAIL (
        ID              char(10)        NOT NULL,
        email           varchar(185)    NOT NULL,
        PRIMARY KEY (ID, email),
        FOREIGN KEY (ID) REFERENCES STUDENT (ID)
                ON DELETE CASCADE
                ON UPDATE RESTRICT
)       CHARACTER SET 'utf8mb4'
        COLLATE 'utf8mb4_unicode_520_ci';

CREATE TABLE SECTION (
        catnum          int             NOT NULL, 
        sectnum         int             NOT NULL, -- part of primary key
        semester        varchar(15)     NOT NULL, -- part of primary key
        room_num        varchar(30),
        prof_ID         char(10),        
        PRIMARY KEY (catnum, sectnum, semester), 
        FOREIGN KEY (catnum) REFERENCES COURSE (catnum)
                ON DELETE CASCADE
                ON UPDATE RESTRICT,
        FOREIGN KEY (prof_ID) REFERENCES PROFESSOR(ID) 
                ON DELETE CASCADE
                ON UPDATE RESTRICT
)       CHARACTER SET 'utf8mb4'
        COLLATE 'utf8mb4_unicode_520_ci';

CREATE TABLE ENROLLED (
        studentid       char(10)        NOT NULL,
        catnum          int             NOT NULL,
        sectnum         int             NOT NULL,
        semester        varchar(15)     NOT NULL,
        grade           char(2),
        rating          float,
        PRIMARY KEY (studentid, catnum, sectnum, semester),
        FOREIGN KEY (studentid) REFERENCES STUDENT(ID)
                ON DELETE CASCADE 
                ON UPDATE RESTRICT,
        FOREIGN KEY (catnum, sectnum, semester) REFERENCES SECTION(catnum, sectnum, semester)
                ON DELETE CASCADE
                ON UPDATE RESTRICT
)       CHARACTER SET 'utf8mb4'
        COLLATE 'utf8mb4_unicode_520_ci';

-- part 2 inserting data

INSERT INTO STUDENT (ID, first, last, major)
        VALUES ('1234567890', 'Brittney', 'Scheven', 'Computer Science'),
               ('0987654321', 'Albert', 'Einstein', 'Physics'),
               ('4444443333', 'Nikola', 'Tesla', 'Physics'),
               ('1029384756', 'John', 'Smith', 'Art');

INSERT INTO PROFESSOR (ID, first, last)
        VALUES ('1112223334', 'Isaac', 'Newton'),
               ('4445556667', 'Galileo', 'Galilei'),
               ('9988776655', 'Leonardo', 'daVinci'),
               ('4567456745', 'William', 'Shakespeare');

INSERT INTO COURSE (catnum, description, ge_area, units) 
        VALUES (3275, 'General Introduction to Astronomy', 'B', 3),
               (4729, 'Physics 1: Mechanical Physics', 'B', 4),
               (8999, 'English Literature', 'A', 3),
               (5567, 'Beginning Painting', 'C', 3);

INSERT INTO SECTION (catnum, sectnum, semester, room_num, prof_ID) 
        VALUES (3275, 2, 'Fall 2020', 'RVR1002', '4445556667'),
               (4729, 1, 'Spring 2021', NULL, '1112223334'),
               (8999, 1, 'Spring 2020', 'RVR1002', '4567456745'),
               (8999, 2, 'Spring 2020', 'RVR 1003', '4567456745'),
               (8999, 3, 'Spring 2020', 'RVR 1002', '4567456745'),
               (5567, 1, 'Fall 2020', 'RVR1002', '9988776655'),
               (5567, 1, 'Spring 2020', 'RVR 1003', '9988776655'),
               (4729, 2, 'Spring 2021', 'RVR 1004', '1112223334');

INSERT INTO ENROLLED (studentid, catnum, sectnum, semester, grade, rating)
        VALUES ('1234567890', 3275, 2, 'Fall 2020', 'A', 3.5),
               ('0987654321', 4729, 1, 'Spring 2021', 'A+', 4),
               ('1234567890', 8999, 3, 'Spring 2020', 'A', 5),
               ('1029384756', 5567, 1, 'Fall 2020', 'B-', 3),
               ('4444443333', 4729, 2, 'Spring 2021', 'B', 4),
               ('0987654321', 3275, 2, 'Fall 2020', 'A+', 5);

INSERT INTO STUDENT_EMAIL (ID, email)
        VALUES ('0987654321', 'alberteinstein@gmail.com'),
               ('1234567890', 'brittneyscheven@csus.edu');

INSERT INTO PROF_EMAIL (ID, email)
        VALUES ('1112223334', 'isaacnewton@yahoo.com'),
               ('1112223334', 'isaacnewton@gmail.com'),
               ('4567456745', 'shakespeare@gmail.com'),
               ('9988776655', 'leonardoDavinci23@gmail.com'),
               ('4445556667', 'galileogalilei@gmail.com'),
               ('4445556667', 'galileigalileo@gmail.com');

-- part 3 querying data

SELECT catnum, description
FROM COURSE NATURAL JOIN SECTION
WHERE room_num = 'RVR1002';

SELECT ID, first, last, catnum, sectnum, description
FROM PROFESSOR JOIN SECTION ON ID = prof_ID
               NATURAL JOIN COURSE
WHERE semester = 'Spring 2020'
GROUP BY catnum, sectnum;

SELECT ID, first, last, AVG(rating)
FROM STUDENT JOIN ENROLLED ON ID = studentid
GROUP BY ID;

SELECT ID, first, last, AVG(rating)
FROM ENROLLED NATURAL JOIN SECTION
     JOIN PROFESSOR ON ID = prof_ID
GROUP BY ID
HAVING COUNT(rating) > 1;

SELECT ID, first, last
FROM STUDENT
WHERE ID NOT IN
      (SELECT ID
       FROM STUDENT_EMAIL);

SELECT ID, first, last
FROM PROFESSOR
WHERE ID NOT IN
      (SELECT prof_ID
       FROM SECTION NATURAL JOIN ENROLLED
            JOIN STUDENT ON ID = studentid
       WHERE major = 'Physics');

-- part 4 dropping tables 
   
DROP TABLE ENROLLED;

DROP TABLE SECTION;

DROP TABLE STUDENT_EMAIL;

DROP TABLE PROF_EMAIL;

DROP TABLE COURSE;

DROP TABLE STUDENT;

DROP TABLE PROFESSOR;