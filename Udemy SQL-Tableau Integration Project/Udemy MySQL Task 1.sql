/*
Create a visualization that provides a breakdown 
between the male and female employees working in the company 
each year, starting from 1990. 
*/
SELECT YEAR(dm.from_date) AS calendar_year, 
	   m.gender, 
       COUNT(m.emp_no) AS number_of_employees
FROM t_dept_emp AS dm
JOIN t_employees AS m
	ON dm.emp_no = m.emp_no
GROUP BY YEAR(dm.from_date), m.gender
HAVING calendar_year >= 1990
ORDER BY YEAR(dm.from_date);