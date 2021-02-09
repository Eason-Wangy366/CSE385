/* 
	Basic List			Advanced List
	----------			-------------
	SELECT				SELECT
	FROM				FROM
	WHERE				WHERE
	ORDER BY			GROUP BY
						HAVING
						ORDER BY
						OFFSET
=======================================================
*/


	SELECT *
	FROM Vendors
	WHERE	(VendorState = 'NY') OR
			(VendorState = 'NJ')
		SELECT *
	FROM Vendors
	WHERE	VendorState IN ('NY', 'NJ')

	SELECT *
	FROM Vendors
	WHERE	VendorState LIKE 'N[YJ]'

	SELECT *
	FROM Vendors
	WHERE VendorZipCode LIKE '9%8'

	-- zipcode starts with 9 or 5 and ends in a 1,2,3,4 or 5
	SELECT *
	FROM Vendors
	WHERE VendorZipCode LIKE '[95]%[1-5]'
	SELECT *
	FROM Vendors
	WHERE VendorPhone IS NULL
	
	SELECT *
	FROM Vendors
	WHERE VendorPhone IS NOT NULL
	
	SELECT *
	FROM Vendors
	WHERE	(VendorPhone IS NULL) AND
			(VendorAddress1 IS NULL)
	

	SELECT *, [Balance] = (InvoiceTotal-PaymentTotal-CreditTotal)
	FROM Invoices
	WHERE	(isDeleted = 0) AND
			(InvoiceTotal-PaymentTotal-CreditTotal > 0)
	ORDER BY Balance DESC

	SELECT	VendorID,
			[Balance]		= SUM(InvoiceTotal-PaymentTotal-CreditTotal),
			[InvoiceCount]	= COUNT(*)
	FROM Invoices
	WHERE (InvoiceTotal-PaymentTotal-CreditTotal) > 0
	GROUP BY VendorID
	HAVING	SUM(InvoiceTotal-PaymentTotal-CreditTotal) > 500

	SELECT *
	FROM Invoices
	WHERE	(InvoiceTotal >= 100)	AND
			(InvoiceTotal <= 200)

	SELECT *
	FROM Invoices
	WHERE InvoiceTotal BETWEEN 100 AND 200

	SELECT *
	FROM Invoices
	WHERE InvoiceDate BETWEEN '2016-01-01' AND '2016-05-31'
	ORDER BY InvoiceDate DESC

	-- Version #1
		SELECT DISTINCT VendorState
		FROM Vendors
		ORDER BY VendorState

	-- Version #2
		SELECT VendorState
		FROM Vendors
		GROUP BY VendorState
		ORDER BY VendorState

		SELECT	TOP(10) WITH TIES
			VendorID,
			VendorState,
			VendorCity
	FROM Vendors
	ORDER BY VendorState, VendorCity
			
	SELECT	[VendorName]= '(' + CAST(VendorID AS VARCHAR(5)) + ') ' + VendorName,
			[Location]	= VendorCity + ', ' + VendorState
	FROM Vendors

	SELECT	[VendorName]= '(' + CONVERT(VARCHAR(5), VendorID) + ') ' + VendorName,
			[Location]	= VendorCity + ', ' + VendorState
	FROM Vendors

	SELECT	[VendorName]= CONCAT( '(', VendorID, ') ', VendorName ),
			[Location]	= CONCAT( VendorCity, ', ', VendorState )
	FROM Vendors

	SELECT	6987.345 / 2344.1,
			Balance,
			Balance * 1.21
	FROM vwInvoices
	WHERE Balance > 0