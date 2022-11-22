SELECT *
FROM retention;

-- Getting the number of employees per dept

SELECT department, 
	   COUNT(department) AS totalEmployeesPerDept
FROM retention
GROUP BY department;

-- Getting the number of employees who stay with the company

SELECT department, 
	   COUNT(department) AS retainedEmployees
FROM retention
WHERE left_company = 'No'
GROUP BY department;

-- -- Total number of employees that stayed with the company

SELECT COUNT(department) AS totalRetainedEmployees
FROM retention
WHERE left_company = 'No';

-- Getting the number of employees who left the company

SELECT department, 
	   COUNT(department) AS deptResignedEmployees
FROM retention
WHERE left_company = 'Yes'
GROUP BY department;

-- Total number of employees that left the company

SELECT COUNT(department) AS totalResignedEmployees
FROM retention
WHERE left_company = 'Yes';

-- Getting the employees that were satisfied and dissatisfied

SELECT id, satisfaction_level,
CASE
	WHEN satisfaction_level < (SELECT AVG(satisfaction_level) FROM retention) THEN 'Below Satisfaction'
    WHEN satisfaction_level > (SELECT AVG(satisfaction_level) FROM retention) THEN 'Above Satisfaction'
    ELSE satisfaction_level
END AS Satisfaction
FROM retention;


-- Getting the above and below avg for the employee evaluation

SELECT id, last_evaluation,
CASE
	WHEN last_evaluation < (SELECT AVG(last_evaluation) FROM retention) THEN 'Bad Evaluation'
    WHEN last_evaluation > (SELECT AVG(last_evaluation) FROM retention) THEN 'Good Evaluation'
    ELSE last_evaluation
END AS Evaluation
FROM retention;

-- Checking the number of Low Evaluations of employees that left the company

SELECT id, last_evaluation, 
	   COUNT(left_company) OVER (PARTITION BY left_company) AS lowEvalResigned
FROM retention
WHERE last_evaluation < (SELECT AVG(last_evaluation) FROM retention) AND left_company = 'Yes';

-- Checking the number of High Evaluations of employees that left the company

SELECT last_evaluation, 
	   COUNT(left_company) OVER (PARTITION BY left_company) AS highEvalResigned
FROM retention
WHERE last_evaluation > (SELECT AVG(last_evaluation) FROM retention) AND left_company = 'Yes';

-- Checking the number of Low Evaluations of employees that remained with the company

SELECT last_evaluation, 
	   COUNT(left_company) OVER (PARTITION BY left_company) AS lowEvalResigned
FROM retention
WHERE last_evaluation < (SELECT AVG(last_evaluation) FROM retention) AND left_company = 'No';

-- Checking the number of High Evaluations of employees that remained with the company

SELECT last_evaluation, 
	   COUNT(left_company) OVER (PARTITION BY left_company) AS highEvalResigned
FROM retention
WHERE last_evaluation > (SELECT AVG(last_evaluation) FROM retention) AND left_company = 'No';

-- Finding the avg number of projects

SELECT number_project, 
	  (SELECT AVG(number_project) FROM retention) AS avgProjects
FROM retention;

-- Getting the number of projects that above and below avg

SELECT number_project,
CASE
	WHEN number_project < (SELECT AVG(number_project) FROM retention) THEN 'Low Project Amount'
    WHEN number_project > (SELECT AVG(number_project) FROM retention) THEN 'High Project Amount'
    ELSE number_project
END AS Projects
FROM retention;

-- Finding the avg monthly hours

SELECT average_monthly_hours, 
	   (SELECT AVG(average_monthly_hours) FROM retention) AS monthlyHoursWorked
FROM retention;

-- Getting the number of hours worked that above and below avg

SELECT average_monthly_hours,
CASE
	WHEN average_monthly_hours < (SELECT AVG(average_monthly_hours) FROM retention) THEN 'Low Hours Worked'
    WHEN average_monthly_hours > (SELECT AVG(average_monthly_hours) FROM retention) THEN 'High Hours Worked'
    ELSE average_monthly_hours
END AS HoursWorked
FROM retention;

-- Getting the number of projects worked to number of projects

SELECT number_project AS Projects,
	   average_monthly_hours AS HoursWorked, 
CASE
	WHEN number_project < (SELECT AVG(number_project) FROM retention) AND 
		 average_monthly_hours < (SELECT AVG(average_monthly_hours) FROM retention) THEN 'Low Project Low Hours'
    WHEN number_project < (SELECT AVG(number_project) FROM retention) AND 
		 average_monthly_hours > (SELECT AVG(average_monthly_hours) FROM retention) THEN 'Low Project High Hours'
    WHEN number_project > (SELECT AVG(number_project) FROM retention) AND 
		 average_monthly_hours < (SELECT AVG(average_monthly_hours) FROM retention) THEN 'High Project Low Hours'
    WHEN number_project > (SELECT AVG(number_project) FROM retention) AND 
		 average_monthly_hours > (SELECT AVG(average_monthly_hours) FROM retention) THEN 'High Project High Hours'
    ELSE number_project
END AS Projects
FROM retention
ORDER BY number_project;

-- Getting the avg years with company

SELECT time_spend_company, 
	   AVG(time_spend_company) OVER () AS YearsWithCompany
FROM retention;

-- Checking the satisfaction level by years with the company

SELECT satisfaction_level, time_spend_company,
CASE
	WHEN satisfaction_level < (SELECT AVG(satisfaction_level) FROM retention) AND 
		 time_spend_company < (SELECT AVG(time_spend_company) FROM retention) THEN 'Not Satisfied Company'
    WHEN satisfaction_level > (SELECT AVG(satisfaction_level) FROM retention) AND 
		 time_spend_company < (SELECT AVG(time_spend_company) FROM retention) THEN 'Neutral With Company'
    WHEN satisfaction_level < (SELECT AVG(satisfaction_level) FROM retention) AND 
		 time_spend_company > (SELECT AVG(time_spend_company) FROM retention) THEN 'Not Very Happy With Company'
    WHEN satisfaction_level > (SELECT AVG(satisfaction_level) FROM retention) AND 
		 time_spend_company > (SELECT AVG(time_spend_company) FROM retention) THEN 'Very Happy With Company'
    ELSE number_project
END AS statusWithCompany
FROM retention;

-- Checking to see how many people got promoted

SELECT department, 
	   time_spend_company AS 'Years With Company'
FROM retention
WHERE promotion_last_5years = 'Yes' -- AND time_spend_company > 5
ORDER BY time_spend_company;

-- Checking to see which dept gave out the most promotions

SELECT department, 
	   COUNT(department) AS numOfPromotion
FROM retention
WHERE promotion_last_5years = 'Yes' 
GROUP BY department
ORDER BY numOfPromotion;

-- Checking Salary by Dept

SELECT department, salary, COUNT(salary) AS numOfSalaryRange
FROM retention
GROUP BY department, salary
ORDER BY department;

-- Checking Salary by Dept

SELECT department, 
	   time_spend_company, 
       average_monthly_hours, 
       promotion_last_5years, 
       salary, 
       left_company
FROM retention
ORDER BY salary DESC;