--=================================================================== Math
	SELECT 5*3, 5/3, 5%3, 5*3.5, 5/3.5, 5%3.5

--=================================================================== Date
	SELECT GETDATE(), SYSDATETIME(), SYSDATETIMEOFFSET(), SYSUTCDATETIME()  -- GMT +-

	SELECT	DATEDIFF(SECOND, '2/11/2000', GETDATE()),
			EOMONTH(GETDATE()),
			EOMONTH('2/1/2020'),
			ISDATE('2/29/2020'),
			ISDATE('2/29/2021'),
			DATENAME(WEEKDAY, GETDATE()),
			DATEPART(DAY, GETDATE()),
			DATEPART(MONTH, GETDATE()),
			DATEPART(YEAR, GETDATE())

--=================================================================== Converting
	SELECT	GETDATE(),
			CONVERT(CHAR(10), GETDATE()),
			CONVERT(CHAR(15), GETDATE()),
			CONVERT(CHAR(11), GETDATE()),
			CONVERT(CHAR(11), GETDATE(), 1),
			CONVERT(CHAR(11), GETDATE(), 101),
			CONVERT(CHAR(11), GETDATE(), 5),
			CONVERT(CHAR(11), GETDATE(), 105),
			CAST( GETDATE() AS DATE ),
			CAST( GETDATE() AS CHAR(10) ),
			CAST( SYSDATETIME() AS CHAR(10) ),
			CAST( SYSDATETIME() AS CHAR(15) )

--=================================================================== Value Checking

---------------------------------------------------------------- VARCHAR 
	DROP TABLE IF EXISTS Users
		
		CREATE TABLE Users (
			id		INT			PRIMARY KEY		IDENTITY,
			un		VARCHAR(20),
			pw		VARCHAR(20)
		)

		INSERT INTO Users (un, pw) VALUES ('tom', 'myPassworD')

		DECLARE @un VARCHAR(20) = 'tom', @pw VARCHAR(20) = 'myPASSWORD'

		-- Will not work correctly
		SELECT * FROM Users WHERE un = @un AND pw = @pw

		-- The fix to this
		SELECT * FROM Users WHERE un = @un AND CAST(pw AS varbinary) = CAST(@pw AS varbinary)
		SELECT * FROM Users WHERE un = @un AND CAST(pw AS varbinary) = CAST('myPassworD' AS varbinary)

---------------------------------------------------------------- NVARCHAR 
	DROP TABLE IF EXISTS Users
		
		CREATE TABLE Users (
			id		INT			PRIMARY KEY		IDENTITY,
			un		NVARCHAR(20),
			pw		NVARCHAR(20)
		)

		INSERT INTO Users (un, pw) VALUES ('tom', 'myPassworD')

		DECLARE @un NVARCHAR(20) = 'tom', @pw NVARCHAR(20) = 'myPASSWORD'

		-- Will not work correctly
		SELECT * FROM Users WHERE un = @un AND pw = @pw

		-- The fix to this
		SELECT * FROM Users WHERE un = @un AND pw COLLATE LATIN1_GENERAL_CS_AS = @pw
		SELECT * FROM Users WHERE un = @un AND pw COLLATE LATIN1_GENERAL_CS_AS = 'myPassworD'
	DROP TABLE IF EXISTS Users


--=================================================================== Comparing / Bit Switch
	-- Return all invoices that there is a credit given or it is deleted
	SELECT * FROM Invoices WHERE (CreditTotal != 0) OR (isDeleted = 1)	-- This "works" but is not universal
	SELECT * FROM Invoices WHERE (CreditTotal <> 0) OR (isDeleted = 1)	-- Proper way to check

	SELECT *, [ToggledIsDeleted] = ~isDeleted, 5, ~5
	FROM Invoices 
	WHERE (CreditTotal <> 0) OR (isDeleted = 1)
	
--- Return all Vendors from states that start with N but exclude any state that ends with K-Y
	SELECT *
	FROM Vendors
	WHERE VendorState LIKE 'N[A-JZ]'


	SELECT *
	FROM Vendors
	WHERE VendorState LIKE 'N[^K-Y]'

--- Return all Vendors where the vendor name starts with 'Am'
	SELECT * FROM Vendors WHERE VendorName LIKE 'Am%'		-- Much better way
	SELECT * FROM Vendors WHERE LEFT(VendorName,2) = 'Am'	-- Will work but not as good or as fast

--=================================================================== Sub-Queries
	-- Get a list of vendors that have invoices (34 rows)
	--  ERROR
		SELECT * 
		FROM Vendors
		WHERE VendorID IN (
			SELECT DISTINCT VendorID, TermsID FROM Invoices
		)
	
	--	Logic Error
		SELECT * 
		FROM Vendors
		WHERE VendorID IN (
			SELECT DISTINCT InvoiceID FROM Invoices
		)


	--  CORRECT
		SELECT * 
		FROM Vendors 
		WHERE VendorID IN (
			SELECT DISTINCT VendorID
			FROM Invoices
		)

	-- Get a list of vendors who have no invoices (88 rows)
		SELECT * 
		FROM Vendors 
		WHERE VendorID NOT IN (
			SELECT DISTINCT VendorID
			FROM Invoices
		)

--=================================================================== NULL
	SELECT COUNT(*) FROM Vendors
	SELECT COUNT(VendorID) FROM Vendors
	SELECT COUNT(VendorName) FROM Vendors
	SELECT COUNT(VendorAddress1) FROM Vendors
	SELECT COUNT(VendorAddress2) FROM Vendors
	SELECT COUNT(VendorZipCode) FROM Vendors
	SELECT COUNT(DISTINCT VendorZipCode) FROM Vendors



	SELECT	VendorName,
			[VendorAddress1] = ISNULL(VendorAddress1, 'na'),
			[VendorPhone]	 = ISNULL(VendorPhone,'***-***-****')
	FROM Vendors 
	WHERE VendorAddress1 IS NULL

--=================================================================== Paging
	DECLARE @page INT = 12, @records INT = 10

	SELECT *
	FROM Vendors
	ORDER BY VendorName
		OFFSET (@page * @records) ROWS
		FETCH NEXT @records ROWS ONLY


	SELECT	VendorName, 
			[totalPages] = CEILING ( (SELECT COUNT(*) FROM Vendors) / CAST(@records AS FLOAT) )
	FROM Vendors
	ORDER BY VendorName
		OFFSET (@pageNum * @records) ROWS
		FETCH NEXT @records ROWS ONLY