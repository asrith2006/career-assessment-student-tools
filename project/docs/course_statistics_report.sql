-- Course Statistics Report
-- Run this script to see current course and program statistics

USE career_assessment_db;

-- Total counts
SELECT '=== COURSE STATISTICS ===' as Report_Section;
SELECT 'Total Courses' as Metric, COUNT(*) as Count FROM courses
UNION ALL
SELECT 'Active Courses', COUNT(*) FROM courses WHERE active = TRUE
UNION ALL
SELECT 'Total Course Registrations', COUNT(*) FROM course_registrations
UNION ALL
SELECT 'Total Student Programs', COUNT(*) FROM student_programs
UNION ALL
SELECT 'Active Student Programs', COUNT(*) FROM student_programs WHERE active = TRUE
UNION ALL
SELECT 'Total Program Enrollments', COUNT(*) FROM student_program_enrollments;

-- Course categories
SELECT '=== COURSES BY CATEGORY ===' as Report_Section;
SELECT
    category,
    COUNT(*) as course_count,
    SUM(max_students) as total_capacity
FROM courses
WHERE active = TRUE
GROUP BY category
ORDER BY course_count DESC;

-- Course registration details
SELECT '=== COURSE REGISTRATION DETAILS ===' as Report_Section;
SELECT
    c.title as course_name,
    c.category,
    c.instructor,
    c.duration,
    COUNT(cr.id) as current_registrations,
    c.max_students as max_capacity,
    ROUND((COUNT(cr.id) / c.max_students) * 100, 1) as utilization_percentage,
    (c.max_students - COUNT(cr.id)) as available_spots
FROM courses c
LEFT JOIN course_registrations cr ON c.id = cr.course_id AND cr.status = 'REGISTERED'
WHERE c.active = TRUE
GROUP BY c.id, c.title, c.category, c.instructor, c.duration, c.max_students
ORDER BY current_registrations DESC, utilization_percentage DESC;

-- Student program enrollment details
SELECT '=== STUDENT PROGRAM ENROLLMENT DETAILS ===' as Report_Section;
SELECT
    sp.name as program_name,
    sp.category,
    sp.coordinator,
    sp.duration,
    COUNT(spe.id) as current_enrollments,
    sp.max_participants as max_capacity,
    ROUND((COUNT(spe.id) / sp.max_participants) * 100, 1) as utilization_percentage,
    (sp.max_participants - COUNT(spe.id)) as available_spots
FROM student_programs sp
LEFT JOIN student_program_enrollments spe ON sp.id = spe.program_id AND spe.status = 'ENROLLED'
WHERE sp.active = TRUE
GROUP BY sp.id, sp.name, sp.category, sp.coordinator, sp.duration, sp.max_participants
ORDER BY current_enrollments DESC, utilization_percentage DESC;

-- Registration status breakdown
SELECT '=== REGISTRATION STATUS BREAKDOWN ===' as Report_Section;
SELECT
    'Course Registrations' as type,
    status,
    COUNT(*) as count
FROM course_registrations
GROUP BY status
UNION ALL
SELECT
    'Program Enrollments' as type,
    status,
    COUNT(*) as count
FROM student_program_enrollments
GROUP BY status
ORDER BY type, count DESC;

-- Top enrolled courses/programs
SELECT '=== MOST POPULAR COURSES ===' as Report_Section;
SELECT
    c.title as course_name,
    COUNT(cr.id) as total_registrations
FROM courses c
LEFT JOIN course_registrations cr ON c.id = cr.course_id
WHERE c.active = TRUE
GROUP BY c.id, c.title
HAVING total_registrations > 0
ORDER BY total_registrations DESC
LIMIT 10;

SELECT '=== MOST POPULAR PROGRAMS ===' as Report_Section;
SELECT
    sp.name as program_name,
    COUNT(spe.id) as total_enrollments
FROM student_programs sp
LEFT JOIN student_program_enrollments spe ON sp.id = spe.program_id
WHERE sp.active = TRUE
GROUP BY sp.id, sp.name
HAVING total_enrollments > 0
ORDER BY total_enrollments DESC
LIMIT 10;

SELECT '=== REPORT GENERATED ===' as Report_Section, NOW() as generated_at;