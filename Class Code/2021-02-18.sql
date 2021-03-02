/*
	2021-02-18
	Chapter 4 - Part II
*/

USE AP
-----------------------------------------------------------------	LEFT JOIN (ALL)
	SELECT v.VendorName, i.InvoiceNumber, i.Balance
	FROM Vendors v
	LEFT JOIN vwInvoices i ON v.VendorID = i.VendorID

-----------------------------------------------------------------	LEFT JOIN (FILTERED)
	SELECT v.VendorName, i.InvoiceNumber, i.Balance
	FROM Vendors			  v
		RIGHT JOIN vwInvoices i ON i.VendorID = v.VendorID
	WHERE v.VendorID IS NULL

-----------------------------------------------------------------	ALL JOINS
USE Examples

/*
	select * from Departments
	select * from Employees
	select * from Projects
*/

	SELECT d.DeptName, d.DeptNo, e.LastName
	FROM Departments d
		 JOIN Employees e ON d.DeptNo = e.DeptNo

	-- VS

	SELECT d.DeptName, d.DeptNo, e.LastName
	FROM Departments d
		LEFT JOIN Employees e ON d.DeptNo = e.DeptNo

	-- VS

	SELECT d.DeptName, d.DeptNo, e.LastName
	FROM Departments d
		RIGHT JOIN Employees e ON d.DeptNo = e.DeptNo

	-- VS

	SELECT d.DeptName, [depDeptNo] = d.DeptNo, [empDeptNo] = e.DeptNo, e.LastName
	FROM Departments d
		FULL JOIN Employees e ON d.DeptNo = e.DeptNo

-----------------------------------------------------------------	JOIN / LEFT JOIN
/*
	Return a list of departments and their employees as well as 
	the projects they are on

	Return the DeptName, LastName, and ProjectNo
*/
	SELECT DeptName, LastName, ProjectNo
	FROM Departments		d
		JOIN Employees		e	ON d.DeptNo     = e.DeptNo
		LEFT JOIN Projects	p	ON e.EmployeeID = p.EmployeeID
	ORDER BY DeptName, LastName, ProjectNo;


-----------------------------------------------------------------	LEFT JOIN
/*
	I would like to know who is working in each department and
	what projects are the employees working on

	Return the DeptName, Employee LastName, and ProjectNo
*/
 
	SELECT DeptName, LastName, ProjectNo
	FROM Departments		d
		LEFT JOIN Employees	e	ON d.DeptNo     = e.DeptNo
		LEFT JOIN Projects	p	ON e.EmployeeID = p.EmployeeID
	ORDER BY DeptName, LastName, ProjectNo;


-----------------------------------------------------------------	FULL JOIN
/*
	Now, I would like to know more about our operation. I want a 
	list of all employees, departments, and projects. This report
	should show:
		1) Departments that don't have employees
		2) Employees that have not been assigned to a department
		3) Employees that have not been assigned to a project
		4) Projects that have not been assigned to employees 
		5) Projects assigned to an employee not in the dB

	Return the DeptName, LastName, ProjectNo, and EmployeeID
*/
	SELECT	d.DeptName, 
			e.LastName, 
			p.ProjectNo, 
			[proEID] = p.EmployeeID, 
			[empEID] = e.EmployeeID
	FROM Departments		d
		FULL JOIN Employees	e	ON d.DeptNo     = e.DeptNo
		FULL JOIN Projects	p	ON e.EmployeeID = p.EmployeeID
	ORDER BY DeptName, LastName, ProjectNo;


-----------------------------------------------------------------	CROSS JOIN
-- Implicit Cross Join
	SELECT d.DeptNo, d.DeptName
	FROM Departments d, Employees e
	ORDER BY d.DeptNo
	
-- Explicit Cross Join
	SELECT d.DeptNo, d.DeptName
	FROM Departments d	CROSS JOIN Employees e
	ORDER BY d.DeptNo

-----------------------------------------------------------------	UNION		
/*
	Rules for UNION
		1.	Each result set must return the same number of columns
		2.	Corresponding columns must have compatible data types
		3.	Column names are taken from the first SELECT
		4.	ORDER BY can only order by fields in query	
*/

USE AP

	SELECT	[Status] = 'Paid',
			i.InvoiceNumber,
			i.Balance
	FROM vwInvoices i
	WHERE i.Balance = 0
UNION
	SELECT	'OKAY',
			i.InvoiceNumber,
			i.Balance
	FROM vwInvoices i
	WHERE i.Balance BETWEEN 1 AND 100
UNION
	SELECT	'Send Notice',
			i.InvoiceNumber,
			i.Balance
	FROM vwInvoices i
	WHERE i.Balance BETWEEN 101 AND 1000
UNION
	SELECT	'SEND TO COLLECTIONS',
			i.InvoiceNumber,
			i.Balance
	FROM vwInvoices i
	WHERE i.Balance > 1000
	ORDER BY i.InvoiceNumber

