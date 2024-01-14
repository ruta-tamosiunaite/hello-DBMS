/* JOB 8 */

-- 1. Créez la base de données SomeCompany à l’aide d’une requête, ajoutez une condition sur l'existence de SomeCompany.
/*
cd C:\Program Files\MySQL\MySQL Server 8.2\bin
mysql -u root -p < path
*/
CREATE DATABASE IF NOT EXISTS SomeCompany;
USE SomeCompany;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Project;
SET FOREIGN_KEY_CHECKS=1;

-- 2. Créez la table Employees.
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthdate DATE,
    position VARCHAR(50),
    department_id INT
);

INSERT INTO Employees (employee_id, first_name, last_name, birthdate, position, department_id) VALUES
(1, 'John', 'Doe', '1990-05-15', 'Software Engineer', 1),
(2, 'Jane', 'Smith', '1985-08-20', 'Project Manager', 2),
(3, 'Mike', 'Johnson', '1992-03-10', 'Data Analyst', 1),
(4, 'Emily', 'Brown', '1988-12-03', 'UX Designer', 1),
(5, 'Alex', 'Williams', '1995-06-28', 'Software Developer', 1),
(6, 'Sarah', 'Miller', '1987-09-18', 'HR Specialist', 3),
(7, 'Ethan', 'Clark', '1991-02-14', 'Database Administrator', 1),
(8, 'Olivia', 'Garcia', '1984-07-22', 'Marketing Manager', 2),
(9, 'Emilia', 'Clark', '1986-01-12', 'HR Manager', 3),
(10, 'Daniel', 'Taylor', '1993-11-05', 'Systems Analyst', 1),
(11, 'William', 'Lee', '1994-08-15', 'Software Engineer', 1),
(12, 'Sophia', 'Baker', '1990-06-25', 'IT Manager', 2);

-- 3. Créez la table Departments.
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    department_head INT,
    location VARCHAR(50)
);

INSERT INTO Departments (department_id, department_name, department_head, location) VALUES
(1, 'IT', 11, 'Headquarters'),
(2, 'Project Management', 2, 'Branch Office West'),
(3, 'Human Resources', 6, 'Branch Office East');

ALTER TABLE Departments
ADD FOREIGN KEY (department_head) REFERENCES Employees(employee_id);

ALTER TABLE Employees
ADD FOREIGN KEY (department_id) REFERENCES Departments(department_id);

-- 4. Insérez 6 à 9 nouveaux employés dans la table Employees.
INSERT INTO Employees (employee_id, first_name, last_name, birthdate, position, department_id) VALUES
(13, 'Billy', 'Alpert', '1987-06-05', 'Account Manager', 2),
(14, 'Santa', 'Green', '1974-07-23', 'Marketing Specialist', 3),
(15, 'Lou', 'Grant', '1986-01-18', 'Project Coordinator', 2),
(16, 'Justin', 'Tunder', '1998-11-16', 'UX/UI Designer', 1),
(17, 'Alex', 'Williams', '1995-09-20', 'Python Developer', 1),
(18, 'Bernard', 'Srirashi', '1999-03-23', 'Marketing Assistant', 3),
(19, 'Silvie', 'Miller', '1983-12-03', 'PHP Developer', 1),
(20, 'Ruben', 'Bernhart', '1979-08-10', 'System Administrator', 1),
(21, 'Gabriel', 'Dantiste', '1996-01-24', 'Recruitment Partner', 3);

-- 5. Récupérez le nom et le poste de tous les employés.
SELECT CONCAT(first_name, ' ', last_name) AS name, position FROM Employees;

-- 6. Mettez à jour le poste d’un employé dans la table Employees.
UPDATE Employees
SET position = 'Senior Software Engineer'
WHERE employee_id = 1;

-- 7. Supprimez un employé de la table Employees.
DELETE FROM Employees
WHERE employee_id = 9;

-- 8. Affichez le nom, le département et le bureau de chaque employé.
SELECT CONCAT(e.first_name, ' ', e.last_name) AS name, d.department_name, d.location
FROM Employees e
JOIN Departments d ON (e.department_id = d.department_id);

-- 9. Affichez, à l’aide d’un filtre, les membres de l’équipe IT, puis le management, puis les ressources humaines.
SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'IT team members'
FROM Employees e
JOIN Departments d ON (e.department_id = d.department_id)
WHERE d.department_name = 'IT';

SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Project Management team members'
FROM Employees e
JOIN Departments d ON (e.department_id = d.department_id)
WHERE d.department_name = 'Project Management';

SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Human Resources team members'
FROM Employees e
JOIN Departments d ON (e.department_id = d.department_id)
WHERE d.department_name = 'Human Resources';

-- 10. Affichez les départements de SomeCompany dans l’ordre alphabétique, avec les managers respectifs de chaque département.
SELECT department_name, CONCAT(first_name, ' ', last_name) as Manager
FROM Departments d
JOIN Employees e ON (d.department_head = e.employee_id)
ORDER BY department_name;

-- 11.Ajoutez un nouveau département à la table Department (Marketing peut-être?), ajoutez ou mettez à jour les employés de ce nouveau département.
INSERT INTO Departments (department_id, department_name, location) VALUES
(4, 'Marketing', 'Corporate Office');

UPDATE Employees
SET department_id = 4
WHERE employee_id IN (8, 13, 14, 18);

-- 12.Créez une nouvelle table Project : project_id (INT, PK), project_name (VARCHAR), start_date (DATE), end_date (DATE), departement_id (INT, FK).
CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(255),
    start_date DATE,
    end_date DATE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Ajoutez des observations à cette nouvelle table
INSERT INTO Project (project_id, project_name, start_date, end_date, department_id) VALUES
(101, 'Amazon Data Mining', '2022-01-10', '2022-04-12', 1),
(102, 'New Marketing Campaign', '2022-01-15', '2022-02-14', 4),
(103, 'New Marketing Campaign', '2022-02-15', '2022-03-14', 4),
(104, 'New Marketing Campaign', '2022-03-15', '2022-04-14', 4);

-- Analysez la productivité des départements en IT et du nouveau département créé précédemment.
SELECT 
    d.department_name,
    COUNT(p.project_id) AS num_projects,
    ROUND(AVG(DATEDIFF(p.end_date, p.start_date))) AS average_duration
FROM Project p
JOIN Departments d ON p.department_id = d.department_id
WHERE d.department_name IN ('IT', 'Marketing')
GROUP BY d.department_name;

