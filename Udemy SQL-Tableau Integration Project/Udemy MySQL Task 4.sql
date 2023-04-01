/*
Create an SQL stored procedure that will allow you 
to obtain the average male and female salary per department within a certain salary range. 
Let this range be defined by two values the user can insert when calling the procedure.
Finally, visualize the obtained result-set in Tableau as a double bar chart.
*/

USE employees_mod;
DROP PROCEDURE IF EXISTS avg_dept_salary;

DELIMITER $$
CREATE PROCEDURE avg_dept_salary(IN p_lower_salary_limit FLOAT, IN p_upper_salary_limit FLOAT)
BEGIN
    SELECT
        m.gender,
        ROUND(AVG(s.salary),2) AS avg_salary,
        d.dept_name
    FROM t_employees AS m
    JOIN t_salaries AS s
	ON m.emp_no = s.emp_no
    JOIN t_dept_emp AS de
	ON s.emp_no = de.emp_no
    JOIN t_departments AS d
	ON de.dept_no = d.dept_no
    WHERE s.salary BETWEEN p_lower_salary_limit AND p_upper_salary_limit
    GROUP BY m.gender, d.dept_no
    ORDER BY d.dept_name, avg_salary DESC;
END $$
DELIMITER ;

CALL avg_dept_salary(50000, 90000);
