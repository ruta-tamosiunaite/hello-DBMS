/* JOB 3 */

-- 1. Table students.
SELECT * FROM students;

-- 2. Les élèves âgés de strictement plus de 20 ans.
SELECT * FROM students WHERE age >= 20;

-- 3. Classement des élèves selon leur note dans un ordre croissant, puis dans un ordre décroissant.
-- From worst to best result
SELECT *
FROM students
ORDER BY REPLACE(grade, '+', '') DESC, LENGTH(grade) ASC;

-- From best to worst result
SELECT *
FROM students
ORDER BY REPLACE(grade, '+', '') ASC, LENGTH(grade) DESC;
