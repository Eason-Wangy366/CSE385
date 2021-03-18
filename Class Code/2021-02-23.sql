------------------------------------------------------------------------------ Lab-04: Q2
/* 
	Write a query that returns list of customers and how much they have
	spent in orders and how many orders they have. Return the CustID, a 
	field called TotalAmountPaid, and a field called TotalOrders. Order 
	the list by the CustID.

		First 5 Rows:
		-------------
		1	114.30	3
		2	76.90	4
		3	34.90	2
		4	13.00	1
		5	17.95	1
*/
USE ProductOrders

	SELECT	o.CustID,
			[TotalAmountPaid]		= SUM(od.Quantity * i.UnitPrice),
			[TotalOrders]			= COUNT(DISTINCT o.OrderID)
	FROM Orders o
		JOIN OrderDetails od ON o.OrderID = od.OrderID
		JOIN Items i ON od.ItemID = i.ItemID
	GROUP BY o.CustID
	ORDER BY o.CustID



	SELECT *
	FROM Orders o
		LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
	WHERE od.OrderID IS NULL

GO

------------------------------------------------------------------------------ Lab-04: Q4
/*
	Write a query that retuns the top 3 sales reps with the most total 
	sales Return first name, last name and the total sales called TotalSales

	Result:
	----------------------------------
	Jonathon	Thomas		3196940.69
	Sonja		Martinez	2841015.55
	Andrew		Markasian	2165620.04
*/

USE Examples
	SELECT TOP(3)
		sr.RepFirstName,
		sr.RepLastName,
		[TotalSales] = SUM(st.SalesTotal)
	FROM SalesTotals st
		JOIN SalesReps sr ON sr.RepID = st.RepID
	GROUP BY sr.RepFirstName,sr.RepLastName
	ORDER BY TotalSales DESC

GO
/*************************************************************************************
	Rules for UNION
		1.	Each result set must return the same number of columns
		2.	Corresponding columns must have compatible data types
		3.	Column names are taken from the first SELECT
		4.	ORDER BY can only order by fields in query	


		1)	[Status]		Warning,	Send Collection Notice,	Cancel Account,	Paid
		  IF Balance is:	1-99		100-500					> 500			0
		2)	InvoiceNumber
		3)	Balance


		* 	Can you figure out how to add VendorID, VendorName (without) adding to 
			the UNION tables and order the list by VendorName
*/

------------------------------------------------------------------------------
-- CTE = Common Table Expresion
USE AP
GO
WITH tbl AS (
		SELECT	 [Status] = 'Warning'
				,i.InvoiceNumber
				,i.Balance
		FROM vwInvoices i
		WHERE i.Balance BETWEEN 1 AND 99
	UNION
		SELECT	 [Status] = 'Send Collection Notice'
				,i.InvoiceNumber
				,i.Balance
		FROM vwInvoices i
		WHERE i.Balance BETWEEN 100 AND 500
	UNION
		SELECT	 [Status] = 'Cancel Account'
				,i.InvoiceNumber
				,i.Balance
		FROM vwInvoices i
		WHERE i.Balance > 500
	UNION
		SELECT	 [Status] = 'Paid'
				,i.InvoiceNumber
				,i.Balance
		FROM vwInvoices i
		WHERE i.Balance = 0
) SELECT v.VendorName, i.VendorID, tbl.*
  FROM tbl 
	JOIN vwInvoices i	ON tbl.InvoiceNumber = i.InvoiceNumber
	JOIN Vendors v		ON i.VendorID = v.VendorID
  ORDER BY i.VendorID
GO

------------------------------------------------------------------------------
/*
	Return a list of every Vendor and the number of invoices they have
	Return the VendorName and [InvoiceCount]
*/
	SELECT	v.VendorName
			,[InvoiceCount] = COUNT(i.InvoiceID)
	FROM Vendors v
		LEFT JOIN Invoices i ON v.VendorID = i.VendorID
	GROUP BY v.VendorName
	ORDER BY InvoiceCount DESC, VendorName
		OFFSET 0 ROWS
			FETCH NEXT 10 ROWS ONLY

	/*
		Federal Express Corporation
		United Parcel Service
		Zylka Design
		Pacific Bell
		Malloy Lithographing Inc
		Roadway Package System, Inc
		Blue Cross
		Cardinal Business Media, Inc.
		Compuserve
		Data Reproductions Corp
	*/
GO

------------------------------------------------------------------------------
USE Examples

-- All Customers that are not employees

	SELECT CustomerFirst, CustomerLast
	FROM Customers
EXCEPT
	SELECT FirstName, LastName
	FROM Employees
GO

------------------------------------------------------------------------------
WITH tbl AS (
		SELECT FirstName, LastName
		FROM Employees
	INTERSECT
		SELECT CustomerFirst, CustomerLast
		FROM Customers
) SELECT e.*
  FROM tbl
	JOIN Employees e ON e.FirstName = tbl.FirstName AND
						e.LastName	= tbl.LastName
GO

------------------------------------------------------------------------------
	SELECT EmployeeID, LastName FROM Employees
UNION ALL
	SELECT EmployeeID, LastName FROM Employees
GO
