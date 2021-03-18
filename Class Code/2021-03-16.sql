-- JSON: VendorName, [Invoices] -> InvoiceNumber, InvoiceTotal, [Items] -> ItemDescription, ItemAmount
/*
	SELECT(
		SELECT	VendorName,
				[Invoices] = (
					SELECT	InvoiceNumber,
							InvoiceTotal,
							[Items] = (
								SELECT	ili.InvoiceLineItemDescription,
										ili.InvoiceLineItemAmount
								FROM InvoiceLineItems ili
								WHERE i.InvoiceID = ili.InvoiceID
								FOR JSON PATH
							)
					FROM Invoices i
					WHERE v.VendorID = i.VendorID
					FOR JSON PATH
				)
		FROM Vendors v
		FOR JSON PATH
	) FOR XML PATH('')
*/	

-- XML
/*
	SELECT	[@Name] = VendorName,
			[Invoices] = (
				SELECT	InvoiceNumber AS [@Number],
						[@Total] = InvoiceTotal,
						[Items] = (
							SELECT	[@Desc] = ili.InvoiceLineItemDescription,
									[@Amt] = ili.InvoiceLineItemAmount
							FROM InvoiceLineItems ili
							WHERE i.InvoiceID = ili.InvoiceID
							FOR XML PATH('Item'), TYPE
						)
				FROM Invoices i
				WHERE v.VendorID = i.VendorID
				FOR XML PATH('Invoice'), TYPE
			)
	FROM Vendors v
	FOR XML PATH('Vendor'), ROOT('Vendors')
*/

/*
	SELECT	VendorID,
			[Hash] = HASHBYTES('SHA2_256', VendorName),
			[Hash2] = HASHBYTES('SHA2_512', VendorName),
			[Comp] = COMPRESS(VendorName),
			[Deco] = CAST(DECOMPRESS(COMPRESS(VendorName)) AS VARCHAR)
	FROM Vendors

*/

-- CTE
/*
	USE CourseData
	GO

	WITH vw AS (
		SELECT	ExamID,
				SUM(Points) AS ExamPoints,
				COUNT(*) AS ExamQuestionCount
		FROM ExamsQuestions
		GROUP BY ExamID
	) SELECT	i.name, 
				AVG(vw.ExamPoints) AS avgPts, 
				AVG(vw.ExamQuestionCount) AS avgQuestCount,
				COUNT(vw.ExamID) AS examCount
	  FROM vw
		JOIN Exams e ON vw.ExamID = e.ExamID
		JOIN Instructors i ON e.InstructorID = i.InstructorID
	  GROUP BY i.name
	  HAVING COUNT(vw.ExamID) > 1
	  ORDER BY i.name

*/

/*

	SELECT	t.Name,
			e.TARate AS PaidRate,
			i.Rate AS DefaultRate,
			IIF(e.TARate > i.Rate, 'Overpaid', 'Under Paid') AS Status
	FROM Exams e,
		 InstructorTAPayRate i,
		 TAs t
	WHERE	(e.InstructorID = i.InstructorID) AND
			(e.TAID = i.TAID) AND
			(t.TAID = e.TAID) AND
			(e.TARate != i.Rate)
*/




/*
	USE AP
	GO

	------------------------------------------------ Invoice Count for Vendors with invoices
	SELECT	VendorName, 
			VendorZipCode,
			COUNT(*) AS InvoiceCount
	FROM Vendors v
		JOIN Invoices i ON v.VendorID = i.VendorID
	GROUP BY VendorName, VendorZipCode

	------------------------------------------------ Invoice Count for ALL Vendors
	SELECT	VendorName, 
			VendorZipCode,
			COUNT(i.InvoiceID) AS InvoiceCount
	FROM Vendors v
		LEFT JOIN Invoices i ON v.VendorID = i.VendorID
	GROUP BY VendorName, VendorZipCode
	ORDER BY VendorName

	------------------------------------------------ Invoice Count for ALL Vendors without an explicit or implicit join
	SELECT	VendorName, 
			VendorZipCode,
			[InvoiceCount] = (	SELECT COUNT(i.InvoiceID) FROM Invoices i WHERE i.VendorID = v.VendorID	)
	FROM Vendors v	
	ORDER BY VendorName 
*/

/*
	SELECT	v.VendorState,
			v.VendorCity,
			SUM(i.InvoiceTotal) as InvoiceSum
	FROM Vendors v, Invoices i
	WHERE v.VendorID = i.VendorID
	GROUP BY v.VendorState, v.VendorCity WITH ROLLUP
*/
