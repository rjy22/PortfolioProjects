/*
Compare the average salary of female versus male employees in the entire company 
until year 2002, and add a filter allowing you to see that per each department.
*/

SELECT m.gender, 
	   d.dept_name, 
       TRUNCATE(AVG(s.salary),2) AS avg_salary, 
       YEAR(s.from_date) AS calendar_year
FROM t_salaries AS s
JOIN t_dept_emp AS de
	ON s.emp_no = de.emp_no
JOIN t_departments AS d
	ON de.dept_no = d.dept_no
JOIN t_employees AS m
	ON de.emp_no = m.emp_no
GROUP BY d.dept_no, m.gender, calendar_year
HAVING calendar_year <= 2002
ORDER BY m.gender, d.dept_no, avg_salary, calendar_year;