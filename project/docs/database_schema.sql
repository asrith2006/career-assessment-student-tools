-- Career Assessment System Database Schema

-- Create database
CREATE DATABASE IF NOT EXISTS career_assessment_db;
USE career_assessment_db;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role ENUM('STUDENT', 'ADMIN') NOT NULL DEFAULT 'STUDENT',
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Questions table
CREATE TABLE IF NOT EXISTS questions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    question_text LONGTEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    description LONGTEXT,
    difficulty INT NOT NULL DEFAULT 1,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_active (active),
    INDEX idx_difficulty (difficulty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Answers table
CREATE TABLE IF NOT EXISTS answers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    question_id BIGINT NOT NULL,
    answer_text LONGTEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT FALSE,
    display_order INT NOT NULL,
    career_mapping VARCHAR(500),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    INDEX idx_question (question_id),
    INDEX idx_is_correct (is_correct)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Test results table
CREATE TABLE IF NOT EXISTS test_results (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    test_name VARCHAR(255) NOT NULL,
    total_questions INT NOT NULL,
    correct_answers INT NOT NULL,
    score_percentage DECIMAL(5, 2) NOT NULL,
    answer_details LONGTEXT,
    recommended_careers LONGTEXT,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP,
    admin_notes LONGTEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_completed (completed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Career recommendations table
CREATE TABLE IF NOT EXISTS career_recommendations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    career_name VARCHAR(255) NOT NULL UNIQUE,
    description LONGTEXT,
    required_skills VARCHAR(1000),
    salary_range VARCHAR(100),
    job_outlook VARCHAR(500),
    related_universities VARCHAR(1000),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_career_name (career_name),
    INDEX idx_active (active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Courses table
CREATE TABLE IF NOT EXISTS courses (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description LONGTEXT,
    duration VARCHAR(100) NOT NULL,
    category VARCHAR(100),
    instructor VARCHAR(255),
    max_students INT DEFAULT 50,    
    current_students INT DEFAULT 0,
    price DECIMAL(10, 2) DEFAULT 0.00,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_title (title),
    INDEX idx_category (category),
    INDEX idx_active (active),
    INDEX idx_instructor (instructor)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Course registrations table
CREATE TABLE IF NOT EXISTS course_registrations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('REGISTERED', 'COMPLETED', 'DROPPED') NOT NULL DEFAULT 'REGISTERED',
    completion_date TIMESTAMP NULL,
    grade VARCHAR(10),
    notes LONGTEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_registration (user_id, course_id),
    INDEX idx_user (user_id),
    INDEX idx_course (course_id),
    INDEX idx_status (status),
    INDEX idx_registration_date (registration_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Student programs table
CREATE TABLE IF NOT EXISTS student_programs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description LONGTEXT,
    duration VARCHAR(100) NOT NULL,
    requirements LONGTEXT,
    benefits LONGTEXT,
    category VARCHAR(100),
    coordinator VARCHAR(255),
    max_participants INT DEFAULT 100,
    current_participants INT DEFAULT 0,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_active (active),
    INDEX idx_coordinator (coordinator)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Student program enrollments table
CREATE TABLE IF NOT EXISTS student_program_enrollments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    program_id BIGINT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ENROLLED', 'COMPLETED', 'WITHDRAWN') NOT NULL DEFAULT 'ENROLLED',
    completion_date TIMESTAMP NULL,
    progress_percentage INT DEFAULT 0,
    notes LONGTEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (program_id) REFERENCES student_programs(id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (user_id, program_id),
    INDEX idx_user (user_id),
    INDEX idx_program (program_id),
    INDEX idx_status (status),
    INDEX idx_enrollment_date (enrollment_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample admin user (password: admin123)
INSERT INTO users (email, password, full_name, role, active) VALUES 
('admin@assessment.com', '$2a$10$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5EQMnwk0dJ3Zm', 'Admin User', 'ADMIN', TRUE);

-- Insert sample student users (password: student123)
INSERT INTO users (email, password, full_name, role, active) VALUES 
('student1@assessment.com', '$2a$10$8K3.6RnugtMyzVd3L8X9Oe6IUBcH3fBlnIcLkTBaXlPK/FtkLQtm', 'John Doe', 'STUDENT', TRUE),
('student2@assessment.com', '$2a$10$8K3.6RnugtMyzVd3L8X9Oe6IUBcH3fBlnIcLkTBaXlPK/FtkLQtm', 'Jane Smith', 'STUDENT', TRUE),
('student3@assessment.com', '$2a$10$8K3.6RnugtMyzVd3L8X9Oe6IUBcH3fBlnIcLkTBaXlPK/FtkLQtm', 'Bob Johnson', 'STUDENT', TRUE);

-- Insert sample careers
INSERT INTO career_recommendations (career_name, description, required_skills, salary_range, job_outlook) VALUES 
('Software Engineer', 'Develops and maintains computer software systems', 'Java, Python, C++, Problem Solving', '$100,000 - $150,000', 'Growing'),
('Data Scientist', 'Analyzes complex data and builds predictive models', 'Python, R, SQL, Machine Learning', '$120,000 - $180,000', 'Very Growing'),
('UI/UX Designer', 'Designs user interfaces and experiences', 'Figma, Adobe XD, Prototyping, UX Research', '$80,000 - $130,000', 'Growing'),
('Database Administrator', 'Manages and maintains databases', 'SQL, Database Design, Performance Tuning', '$90,000 - $140,000', 'Stable'),
('Cloud Architect', 'Designs scalable cloud infrastructure', 'AWS, Azure, GCP, System Design', '$130,000 - $200,000', 'Very Growing');

-- Insert sample courses
INSERT INTO courses (title, description, duration, category, instructor, max_students, current_students, price, active) VALUES 
('Career Planning 101', 'Learn how to align your strengths with job opportunities and build a roadmap for success.', '4 weeks', 'Career Development', 'Dr. Sarah Johnson', 50, 0, 0.00, TRUE),
('Resume & Interview Skills', 'Improve your resume, interview communication, and personal branding for job applications.', '3 weeks', 'Career Development', 'Prof. Michael Chen', 40, 0, 0.00, TRUE),
('Professional Networking', 'Build meaningful connections, create a strong profile, and grow your professional network.', '2 weeks', 'Career Development', 'Ms. Emily Davis', 35, 0, 0.00, TRUE),
('Technical Skills Workshop', 'Hands-on training in essential technical skills for modern careers.', '6 weeks', 'Technical Training', 'Dr. Robert Wilson', 30, 0, 0.00, TRUE),
('Leadership & Management', 'Develop leadership skills and learn effective management techniques.', '5 weeks', 'Leadership', 'Prof. Lisa Anderson', 25, 0, 0.00, TRUE),
('Entrepreneurship Fundamentals', 'Learn the basics of starting and running a successful business.', '4 weeks', 'Business', 'Mr. David Thompson', 45, 0, 0.00, TRUE);

-- Insert sample course registrations
INSERT INTO course_registrations (user_id, course_id, registration_date, status) VALUES
(2, 1, '2026-04-08 09:00:00', 'REGISTERED'),
(2, 2, '2026-04-08 10:30:00', 'REGISTERED'),
(3, 1, '2026-04-08 11:15:00', 'REGISTERED'),
(3, 3, '2026-04-08 14:20:00', 'COMPLETED'),
(4, 2, '2026-04-08 15:45:00', 'REGISTERED');

-- Insert sample student programs
INSERT INTO student_programs (name, description, duration, requirements, benefits, category, coordinator, max_participants, current_participants, active) VALUES 
('Career Development Program', 'Comprehensive program to help students develop their career skills and find suitable job opportunities.', '6 months', 'Completed assessment test with minimum 60% score', 'Personalized career counseling, resume building, interview preparation', 'Career Development', 'Dr. Sarah Johnson', 100, 0, TRUE),
('Skill Enhancement Program', 'Focused program to improve specific technical and soft skills required for various careers.', '3 months', 'Basic assessment completed', 'Skill workshops, certification preparation, mentorship', 'Technical Training', 'Prof. Michael Chen', 80, 0, TRUE),
('Leadership Excellence Program', 'Advanced program for developing leadership and management capabilities.', '4 months', 'Minimum 2 years experience or equivalent', 'Executive coaching, project management training, networking events', 'Leadership', 'Prof. Lisa Anderson', 50, 0, TRUE);

-- Insert sample program enrollments
INSERT INTO student_program_enrollments (user_id, program_id, enrollment_date, status, progress_percentage) VALUES
(2, 1, '2026-04-07 09:00:00', 'ENROLLED', 25),
(3, 1, '2026-04-07 10:30:00', 'ENROLLED', 15),
(2, 2, '2026-04-07 14:20:00', 'COMPLETED', 100),
(4, 3, '2026-04-08 11:15:00', 'ENROLLED', 5);

-- Insert sample questions
INSERT INTO questions (question_text, category, description, difficulty, active) VALUES 
('What is your primary interest?', 'General', 'Career preference question', 1, TRUE),
('How do you prefer to work?', 'Work Style', 'Work environment preference', 1, TRUE),
('What type of problems do you enjoy solving?', 'Problem Solving', 'Problem type preference', 2, TRUE),
('Which technology interests you most?', 'Technology', 'Technology preference question', 2, TRUE),
('How important is work-life balance to you?', 'Lifestyle', 'Work-life balance importance', 1, TRUE);

-- Insert sample answers for question 1
INSERT INTO answers (question_id, answer_text, is_correct, display_order, career_mapping, active) VALUES 
(1, 'Building software applications', TRUE, 1, '1', TRUE),
(1, 'Analyzing data and patterns', TRUE, 2, '2', TRUE),
(1, 'Designing user experiences', TRUE, 3, '3', TRUE),
(1, 'Managing infrastructure', TRUE, 4, '4,5', TRUE);

-- Insert sample answers for question 2
INSERT INTO answers (question_id, answer_text, is_correct, display_order, career_mapping, active) VALUES 
(2, 'Independently', TRUE, 1, '1', TRUE),
(2, 'In a team environment', TRUE, 2, '2,3', TRUE),
(2, 'Mix of both', TRUE, 3, '4,5', TRUE);

-- Insert sample test results for student users
INSERT INTO test_results (user_id, test_name, total_questions, correct_answers, score_percentage, answer_details, recommended_careers, completed_at, reviewed_at, admin_notes) VALUES
(2, 'Career Interest Assessment', 5, 4, 80.00, '[{"questionId":1,"chosenAnswer":"Building software applications"},{"questionId":2,"chosenAnswer":"Independently"},{"questionId":3,"chosenAnswer":"Complex logic"},{"questionId":4,"chosenAnswer":"Software development"},{"questionId":5,"chosenAnswer":"Very important"}]', 'Software Engineer,Cloud Architect', '2026-04-07 14:20:00', NULL, 'Strong aptitude for technical roles'),
(3, 'Career Interest Assessment', 5, 3, 60.00, '[{"questionId":1,"chosenAnswer":"Analyzing data and patterns"},{"questionId":2,"chosenAnswer":"In a team environment"},{"questionId":3,"chosenAnswer":"Research and modeling"},{"questionId":4,"chosenAnswer":"Data science"},{"questionId":5,"chosenAnswer":"Important"}]', 'Data Scientist', '2026-04-07 15:10:00', NULL, 'Good fit for analytics roles');

-- Useful queries for course statistics

-- Count total courses
SELECT 'Total Courses' as Metric, COUNT(*) as Count FROM courses;

-- Count active courses
SELECT 'Active Courses' as Metric, COUNT(*) as Count FROM courses WHERE active = TRUE;

-- Count courses by category
SELECT category, COUNT(*) as Course_Count FROM courses WHERE active = TRUE GROUP BY category ORDER BY Course_Count DESC;

-- Count course registrations
SELECT 'Total Course Registrations' as Metric, COUNT(*) as Count FROM course_registrations;

-- Count registrations by status
SELECT status, COUNT(*) as Registration_Count FROM course_registrations GROUP BY status ORDER BY Registration_Count DESC;

-- Count student programs
SELECT 'Total Student Programs' as Metric, COUNT(*) as Count FROM student_programs;

-- Count active student programs
SELECT 'Active Student Programs' as Metric, COUNT(*) as Count FROM student_programs WHERE active = TRUE;

-- Count program enrollments
SELECT 'Total Program Enrollments' as Metric, COUNT(*) as Count FROM student_program_enrollments;

-- Most popular courses (by registrations)
SELECT c.title, COUNT(cr.id) as Registration_Count
FROM courses c
LEFT JOIN course_registrations cr ON c.id = cr.course_id
WHERE c.active = TRUE
GROUP BY c.id, c.title
ORDER BY Registration_Count DESC;

-- Most popular programs (by enrollments)
SELECT sp.name, COUNT(spe.id) as Enrollment_Count
FROM student_programs sp
LEFT JOIN student_program_enrollments spe ON sp.id = spe.program_id
WHERE sp.active = TRUE
GROUP BY sp.id, sp.name
ORDER BY Enrollment_Count DESC;

-- Course enrollment summary
SELECT 
    c.title as Course_Name,
    c.category as Category,
    c.max_students as Max_Students,
    COUNT(cr.id) as Current_Registrations,
    (c.max_students - COUNT(cr.id)) as Available_Spots
FROM courses c
LEFT JOIN course_registrations cr ON c.id = cr.course_id AND cr.status = 'REGISTERED'
WHERE c.active = TRUE
GROUP BY c.id, c.title, c.category, c.max_students
ORDER BY Current_Registrations DESC;

-- Student program enrollment summary
SELECT 
    sp.name as Program_Name,
    sp.category as Category,
    sp.max_participants as Max_Participants,
    COUNT(spe.id) as Current_Enrollments,
    (sp.max_participants - COUNT(spe.id)) as Available_Spots
FROM student_programs sp
LEFT JOIN student_program_enrollments spe ON sp.id = spe.program_id AND spe.status = 'ENROLLED'
WHERE sp.active = TRUE
GROUP BY sp.id, sp.name, sp.category, sp.max_participants
ORDER BY Current_Enrollments DESC;

COMMIT;
