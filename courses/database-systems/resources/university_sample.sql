-- Sample Database for SQL Fundamentals
-- Tables: department, student, course, enrollment
-- Table and column names: English
-- Data (names, descriptions): Turkish

DROP DATABASE IF EXISTS university_sample;
CREATE DATABASE university_sample
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE university_sample;

-- =========================
-- 1) DEPARTMENT
-- =========================

CREATE TABLE department (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  short_name VARCHAR(20) NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

INSERT INTO department (name, short_name) VALUES
  ('Bilgisayar Mühendisliği', 'CENG'),
  ('Elektrik-Elektronik Mühendisliği', 'EE'),
  ('Makine Mühendisliği', 'ME');

-- =========================
-- 2) STUDENT
-- =========================

CREATE TABLE student (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_no VARCHAR(20) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  department_id INT UNSIGNED NOT NULL,
  gpa DECIMAL(3,2) NULL,
  registration_year INT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_student_student_no (student_no),
  CONSTRAINT fk_student_department
    FOREIGN KEY (department_id) REFERENCES department(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

INSERT INTO student (student_no, first_name, last_name, department_id, gpa, registration_year) VALUES
  ('2023001', 'Ali',     'Yılmaz', 1, 3.10, 2023),
  ('2023002', 'Ayşe',    'Demir',  1, 3.45, 2023),
  ('2023003', 'Mehmet',  'Kaya',   2, 2.80, 2022),
  ('2023004', 'Zeynep',  'Yıldız', 1, 3.75, 2021),
  ('2023005', 'Can',     'Çelik',  2, 2.40, 2023),
  ('2023006', 'Elif',    'Arslan', 3, 3.05, 2022),
  ('2023007', 'Burak',   'Şahin',  1, 2.95, 2021),
  ('2023008', 'Deniz',   'Acar',   3, 2.60, 2023),
  ('2023009', 'Fatma',   'Kurt',   1, 3.20, 2022),
  ('2023010', 'Onur',    'Koç',    2, 2.10, 2021);

-- =========================
-- 3) COURSE
-- =========================

CREATE TABLE course (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(20) NOT NULL,
  name VARCHAR(100) NOT NULL,
  department_id INT UNSIGNED NOT NULL,
  credit TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_course_code (code),
  CONSTRAINT fk_course_department
    FOREIGN KEY (department_id) REFERENCES department(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

INSERT INTO course (code, name, department_id, credit) VALUES
  ('CENG101', 'Programlamaya Giriş',                1, 4),
  ('CENG201', 'Veritabanı Sistemleri',             1, 4),
  ('CENG202', 'Veri Yapıları',                     1, 4),
  ('EE101',   'Devre Analizi',                     2, 4),
  ('EE202',   'Sayısal Elektronik',                2, 3),
  ('ME101',   'Statik',                            3, 4),
  ('ME202',   'Makine Elemanları',                 3, 4),
  ('UNI101',  'Üniversiteye Giriş ve Oryantasyon', 1, 2);

-- =========================
-- 4) ENROLLMENT (Student-Course Many-to-Many)
-- =========================

CREATE TABLE enrollment (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_id INT UNSIGNED NOT NULL,
  course_id INT UNSIGNED NOT NULL,
  semester VARCHAR(10) NOT NULL,
  grade VARCHAR(2) NULL,
  PRIMARY KEY (id),
  KEY idx_enrollment_student (student_id),
  KEY idx_enrollment_course (course_id),
  CONSTRAINT fk_enrollment_student
    FOREIGN KEY (student_id) REFERENCES student(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_enrollment_course
    FOREIGN KEY (course_id) REFERENCES course(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

INSERT INTO enrollment (student_id, course_id, semester, grade) VALUES
  (1, 1, '2023F', 'BA'),
  (1, 2, '2024S', NULL),
  (2, 1, '2023F', 'AA'),
  (2, 2, '2024S', NULL),
  (3, 4, '2023F', 'CB'),
  (3, 5, '2024S', NULL),
  (4, 1, '2021F', 'BB'),
  (4, 2, '2022S', 'BA'),
  (4, 3, '2022S', 'CB'),
  (5, 4, '2023F', 'CC'),
  (6, 6, '2022F', 'BA'),
  (6, 7, '2023S', 'BB'),
  (7, 1, '2021F', 'CC'),
  (7, 3, '2022S', 'BB'),
  (8, 6, '2023F', NULL),
  (9, 2, '2023F', 'AA'),
  (9, 3, '2023F', 'BA'),
  (10, 4, '2021F', 'DC'),
  (10, 5, '2022S', 'DD'),
  (1, 8, '2023F', 'AA'),
  (2, 8, '2023F', 'AA'),
  (3, 8, '2023F', 'BA'),
  (4, 8, '2021F', 'BB');
