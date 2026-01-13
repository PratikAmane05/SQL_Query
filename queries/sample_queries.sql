-- ========================================
-- SQL Query Collection
-- Author: Pratik Amane
-- ========================================

-- ========================================
-- 1. DATA DEFINITION LANGUAGE (DDL)
-- ========================================

-- Create a database
CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;

-- Create employees table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    hire_date DATE,
    job_title VARCHAR(50),
    salary DECIMAL(10, 2),
    department_id INT,
    manager_id INT
);

-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- Create projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12, 2)
);

-- ========================================
-- 2. DATA MANIPULATION LANGUAGE (DML)
-- ========================================

-- Insert departments
INSERT INTO departments (department_name, location) VALUES
('IT', 'New York'),
('HR', 'San Francisco'),
('Sales', 'Chicago'),
('Marketing', 'Los Angeles');

-- Insert employees
INSERT INTO employees (first_name, last_name, email, phone, hire_date, job_title, salary, department_id) VALUES
('John', 'Doe', 'john.doe@company.com', '555-0101', '2020-01-15', 'Software Engineer', 75000.00, 1),
('Jane', 'Smith', 'jane.smith@company.com', '555-0102', '2019-03-20', 'HR Manager', 65000.00, 2),
('Mike', 'Johnson', 'mike.j@company.com', '555-0103', '2021-06-10', 'Sales Representative', 55000.00, 3),
('Emily', 'Brown', 'emily.b@company.com', '555-0104', '2020-11-05', 'Marketing Specialist', 60000.00, 4);

-- Update employee salary
UPDATE employees 
SET salary = salary * 1.10 
WHERE department_id = 1;

-- Delete operation (with caution)
-- DELETE FROM employees WHERE employee_id = 5;

-- ========================================
-- 3. DATA QUERY LANGUAGE (DQL)
-- ========================================

-- Basic SELECT
SELECT * FROM employees;

-- Select specific columns
SELECT first_name, last_name, job_title, salary 
FROM employees;

-- WHERE clause
SELECT * FROM employees 
WHERE salary > 60000;

-- ORDER BY
SELECT first_name, last_name, salary 
FROM employees 
ORDER BY salary DESC;

-- LIMIT
SELECT * FROM employees 
LIMIT 5;

-- ========================================
-- 4. JOINS
-- ========================================

-- INNER JOIN
SELECT 
    e.first_name, 
    e.last_name, 
    e.job_title, 
    d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- LEFT JOIN
SELECT 
    e.first_name, 
    e.last_name, 
    d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- RIGHT JOIN
SELECT 
    e.first_name, 
    e.last_name, 
    d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;

-- ========================================
-- 5. AGGREGATE FUNCTIONS
-- ========================================

-- COUNT
SELECT COUNT(*) as total_employees 
FROM employees;

-- SUM
SELECT SUM(salary) as total_salary_expense 
FROM employees;

-- AVG
SELECT AVG(salary) as average_salary 
FROM employees;

-- MIN and MAX
SELECT 
    MIN(salary) as lowest_salary, 
    MAX(salary) as highest_salary 
FROM employees;

-- GROUP BY
SELECT 
    department_id, 
    COUNT(*) as employee_count, 
    AVG(salary) as avg_salary
FROM employees
GROUP BY department_id;

-- HAVING clause
SELECT 
    department_id, 
    AVG(salary) as avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 60000;

-- ========================================
-- 6. SUBQUERIES
-- ========================================

-- Subquery in WHERE
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Subquery in FROM
SELECT dept_stats.department_id, dept_stats.avg_salary
FROM (
    SELECT department_id, AVG(salary) as avg_salary
    FROM employees
    GROUP BY department_id
) as dept_stats
WHERE dept_stats.avg_salary > 60000;

-- ========================================
-- 7. STRING FUNCTIONS
-- ========================================

-- CONCAT
SELECT CONCAT(first_name, ' ', last_name) as full_name 
FROM employees;

-- UPPER and LOWER
SELECT UPPER(first_name), LOWER(last_name) 
FROM employees;

-- LENGTH
SELECT first_name, LENGTH(first_name) as name_length 
FROM employees;

-- SUBSTRING
SELECT SUBSTRING(email, 1, 10) as email_prefix 
FROM employees;

-- ========================================
-- 8. DATE FUNCTIONS
-- ========================================

-- Current date and time
SELECT NOW(), CURDATE(), CURTIME();

-- Date formatting
SELECT 
    first_name, 
    hire_date, 
    DATE_FORMAT(hire_date, '%M %d, %Y') as formatted_date
FROM employees;

-- Date calculations
SELECT 
    first_name, 
    hire_date, 
    DATEDIFF(CURDATE(), hire_date) as days_employed,
    YEAR(CURDATE()) - YEAR(hire_date) as years_employed
FROM employees;

-- ========================================
-- 9. VIEWS
-- ========================================

-- Create a view
CREATE VIEW employee_summary AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) as full_name,
    e.job_title,
    e.salary,
    d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;

-- Query the view
SELECT * FROM employee_summary;

-- ========================================
-- 10. INDEXES
-- ========================================

-- Create index
CREATE INDEX idx_employee_email ON employees(email);
CREATE INDEX idx_employee_department ON employees(department_id);

-- Show indexes
SHOW INDEX FROM employees;

-- ========================================
-- 11. ADVANCED QUERIES
-- ========================================

-- CASE statement
SELECT 
    first_name, 
    last_name, 
    salary,
    CASE 
        WHEN salary < 60000 THEN 'Junior'
        WHEN salary BETWEEN 60000 AND 70000 THEN 'Mid-level'
        ELSE 'Senior'
    END as experience_level
FROM employees;

-- UNION
SELECT first_name, last_name FROM employees WHERE department_id = 1
UNION
SELECT first_name, last_name FROM employees WHERE department_id = 2;

-- Window Functions (if supported)
SELECT 
    first_name,
    last_name,
    salary,
    department_id,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) as rank_in_dept
FROM employees;

-- ========================================
-- 12. TRANSACTIONS
-- ========================================

-- Start transaction
START TRANSACTION;

-- Multiple operations
UPDATE employees SET salary = salary * 1.05 WHERE department_id = 1;
INSERT INTO employees (first_name, last_name, email, job_title, salary, department_id)
VALUES ('New', 'Employee', 'new.employee@company.com', 'Intern', 40000.00, 1);

-- Commit or Rollback
COMMIT;
-- ROLLBACK;

-- ========================================
-- End of SQL Query Collection
-- ========================================
