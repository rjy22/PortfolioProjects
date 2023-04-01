/*
Compare the number of male managers to the number of female managers 
from different departments for each year, 
starting from 1990.
*/

SELECT 
    d.dept_name,
    m.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    (CASE
	WHEN e.calendar_year BETWEEN YEAR(dm.from_date) AND YEAR(dm.to_date) THEN 1
        ELSE 0
     END) AS active_year
FROM
    (SELECT
         YEAR(hire_date) AS calendar_year
     FROM 
	 t_employees
     GROUP BY 
	 calendar_year) AS e
CROSS JOIN
     t_dept_manager AS dm
JOIN 
     t_departments AS d
    ON dm.dept_no = d.dept_no
JOIN 
     t_employees AS m
    ON dm.emp_no = m.emp_no
ORDER BY
    dm.emp_no,
    e.calendar_year;
