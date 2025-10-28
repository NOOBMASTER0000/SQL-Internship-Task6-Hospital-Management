-- Task 6: Subqueries and Nested Queries
-- Database: HospitalDB
-- Objective: Use subqueries in SELECT, WHERE, and FROM clauses

USE HospitalDB;

-- ----------------------------------------------------------
-- 1. Scalar Subquery
-- Shows each doctor along with total doctors in their department
-- ----------------------------------------------------------

SELECT 
    DoctorName,
    Specialty,
    DepartmentID,
    (SELECT COUNT(*) 
     FROM Doctors d2 
     WHERE d2.DepartmentID = d1.DepartmentID) AS TotalDoctorsInDept
FROM Doctors d1;

-- ----------------------------------------------------------
-- 2. Subquery in WHERE Clause
-- Lists all doctors whose specialty matches any department name
-- ----------------------------------------------------------

SELECT 
    DoctorName, 
    Specialty
FROM Doctors
WHERE Specialty IN (
    SELECT DeptName
    FROM Departments
);

-- ----------------------------------------------------------
-- 3. Correlated Subquery
-- Shows patients with bills greater than their average bill amount
-- ----------------------------------------------------------

SELECT 
    p.PatientName,
    b.Amount,
    b.AppointmentID
FROM Bills b
JOIN Patients p ON p.PatientID = b.BillID
WHERE b.Amount > (
    SELECT AVG(b2.Amount)
    FROM Bills b2
    WHERE b2.BillID = b.BillID
);

-- ----------------------------------------------------------
-- 4. Subquery with EXISTS
-- Displays departments that have at least one doctor assigned
-- ----------------------------------------------------------

SELECT 
    DeptName
FROM Departments d
WHERE EXISTS (
    SELECT 1
    FROM Doctors doc
    WHERE doc.DepartmentID = d.DepartmentID
);

-- ----------------------------------------------------------
-- 5. Subquery in FROM Clause (Derived Table)
-- Shows patients whose average bill exceeds 3000
-- ----------------------------------------------------------

SELECT 
    PatientName,
    AvgAmount
FROM (
    SELECT 
        p.PatientName,
        AVG(b.Amount) AS AvgAmount
    FROM Bills b
    JOIN Patients p ON p.PatientID = b.BillID
    GROUP BY p.PatientName
) AS AvgTable
WHERE AvgAmount > 3000;

-- ----------------------------------------------------------
-- 6. Nested Subquery
-- Finds doctors belonging to the department with the highest doctor count
-- ----------------------------------------------------------

SELECT 
    DoctorName,
    DepartmentID
FROM Doctors
WHERE DepartmentID = (
    SELECT DepartmentID
    FROM Doctors
    GROUP BY DepartmentID
    ORDER BY COUNT(DoctorID) DESC
    LIMIT 1
);
