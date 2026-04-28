# Course Database Schema and Statistics

## Database Tables Added

### Courses Table
```sql
CREATE TABLE courses (
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Course Registrations Table
```sql
CREATE TABLE course_registrations (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('REGISTERED', 'COMPLETED', 'DROPPED') NOT NULL DEFAULT 'REGISTERED',
    completion_date TIMESTAMP NULL,
    grade VARCHAR(10),
    notes LONGTEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);
```

### Student Programs Table
```sql
CREATE TABLE student_programs (
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Student Program Enrollments Table
```sql
CREATE TABLE student_program_enrollments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    program_id BIGINT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ENROLLED', 'COMPLETED', 'WITHDRAWN') NOT NULL DEFAULT 'ENROLLED',
    completion_date TIMESTAMP NULL,
    progress_percentage INT DEFAULT 0,
    notes LONGTEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (program_id) REFERENCES student_programs(id) ON DELETE CASCADE
);
```

## Sample Data

### Courses (6 total)
1. **Career Planning 101** - Career Development (4 weeks)
2. **Resume & Interview Skills** - Career Development (3 weeks)
3. **Professional Networking** - Career Development (2 weeks)
4. **Technical Skills Workshop** - Technical Training (6 weeks)
5. **Leadership & Management** - Leadership (5 weeks)
6. **Entrepreneurship Fundamentals** - Business (4 weeks)

### Student Programs (3 total)
1. **Career Development Program** - Career Development (6 months)
2. **Skill Enhancement Program** - Technical Training (3 months)
3. **Leadership Excellence Program** - Leadership (4 months)

## Course Statistics Queries

### Total Courses Count
```sql
SELECT COUNT(*) as total_courses FROM courses;
-- Result: 6
```

### Active Courses Count
```sql
SELECT COUNT(*) as active_courses FROM courses WHERE active = TRUE;
-- Result: 6
```

### Courses by Category
```sql
SELECT category, COUNT(*) as course_count
FROM courses
WHERE active = TRUE
GROUP BY category
ORDER BY course_count DESC;
```
| Category | Course Count |
|----------|-------------|
| Career Development | 3 |
| Technical Training | 1 |
| Leadership | 1 |
| Business | 1 |

### Course Registration Statistics
```sql
SELECT
    c.title as course_name,
    COUNT(cr.id) as registrations,
    c.max_students as max_students,
    (c.max_students - COUNT(cr.id)) as available_spots
FROM courses c
LEFT JOIN course_registrations cr ON c.id = cr.course_id AND cr.status = 'REGISTERED'
WHERE c.active = TRUE
GROUP BY c.id, c.title, c.max_students
ORDER BY registrations DESC;
```

| Course Name | Registrations | Max Students | Available Spots |
|-------------|---------------|--------------|----------------|
| Career Planning 101 | 2 | 50 | 48 |
| Resume & Interview Skills | 2 | 40 | 38 |
| Professional Networking | 1 | 35 | 34 |
| Technical Skills Workshop | 0 | 30 | 30 |
| Leadership & Management | 0 | 25 | 25 |
| Entrepreneurship Fundamentals | 0 | 45 | 45 |

### Student Program Enrollment Statistics
```sql
SELECT
    sp.name as program_name,
    COUNT(spe.id) as enrollments,
    sp.max_participants as max_participants,
    (sp.max_participants - COUNT(spe.id)) as available_spots
FROM student_programs sp
LEFT JOIN student_program_enrollments spe ON sp.id = spe.program_id AND spe.status = 'ENROLLED'
WHERE sp.active = TRUE
GROUP BY sp.id, sp.name, sp.max_participants
ORDER BY enrollments DESC;
```

| Program Name | Enrollments | Max Participants | Available Spots |
|--------------|-------------|------------------|----------------|
| Career Development Program | 2 | 100 | 98 |
| Skill Enhancement Program | 1 | 80 | 79 |
| Leadership Excellence Program | 1 | 50 | 49 |

## Usage Instructions

1. **Run the database schema**: Execute `database_schema.sql` in MySQL
2. **Start the Spring Boot application**: The tables will be created automatically via Hibernate
3. **Use the statistics queries**: Run the provided SQL queries to get course statistics
4. **Admin interface**: Use the ManageCourses page to view course registrations
5. **Student interface**: Students can register for courses through CourseRegistration page

## Features

- ✅ Course registration tracking
- ✅ Student program enrollment management
- ✅ Real-time statistics and reporting
- ✅ Admin dashboard integration
- ✅ Student progress tracking
- ✅ Capacity management (max students/participants)