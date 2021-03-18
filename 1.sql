DROP PROCEDURE IF EXISTS spGetVendors
GO

CREATE PROCEDURE spGetVendors
	@st VARCHAR(50),
	@include BIT = 0
AS BEGIN
	SET NOCOUNT OFF

	SELECT	V.VendorID,
			V.VendorName,
			COUNT(I.InvoiceID) AS InvoiceCount
	FROM Vendors V
		LEFT JOIN Invoices I ON V.VendorID = I.VendorID
	WHERE (V.VendorState = @st) OR (@st = '')
	GROUP BY V.VendorID, V.VendorName
	HAVING		(COUNT(I.InvoiceID)>0)
			OR	(@include = 1)
	ORDER BY V.VendorName
	END 
	GO


	EXEC spGetVendors @st = 'OH'