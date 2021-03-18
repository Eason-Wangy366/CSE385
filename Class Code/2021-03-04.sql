
		--------------------------------------------------------------------------------------
		DROP TABLE		IF EXISTS Errors
		DROP PROCEDURE	IF EXISTS spRecordError
		DROP PROCEDURE	IF EXISTS spDivide
		
		--------------------------------------------------------------------------------------
		DECLARE @n1 int = 1, @n2 int = 0
		BEGIN TRY
			SELECT @n1/@n2
		END TRY BEGIN CATCH
			SELECT	ERROR_LINE(),
					ERROR_MESSAGE(),
					ERROR_NUMBER(),
					ERROR_PROCEDURE(),
					ERROR_SEVERITY(),
					ERROR_STATE(),
					CAST( (SELECT [n1] = @n1, [n2] = @n2 FOR XML PATH('params')) as xml )
		END CATCH


		SELECT * FROM master.sys.messages
		WHERE LANGUAGE_ID = 1033 and message_id = 8134

		--------------------------------------------------------------------------------------
		/* 
			-- What is XML?  Example
			<users>
				<user>
					<name>Tom Ryan</user>
					<age>22</age>
					<pets>
						<pet>
							<name>Buffy</name>
							<age>10</age>
							<type>dog</type>
						</pet>
					</pets>
				</user>

				<user>
					<name>Sally Right</user>
					<age>21</age>
					<pets></pets>
				</user>
			</users>

		*/
		CREATE TABLE Errors (
			ERROR_ID				INT					PRIMARY KEY			IDENTITY,
			ERROR_LINE				INT,
			ERROR_MESSAGE			VARCHAR(1000),
			ERROR_NUMBER			INT,
			ERROR_PROCEDURE			NVARCHAR(200),
			ERROR_SEVERITY			INT,
			ERROR_STATE				INT,
			PARAMS					XML					NULL				DEFAULT(NULL),
			SYSUSER					VARCHAR(100)		NULL				DEFAULT(SYSTEM_USER),
			ERROR_DATETIME			DATETIME								DEFAULT(GETDATE()),
			FIXED_DATETIME			DATETIME			NULL				DEFAULT(NULL),
			FIXED_BY_USER			VARCHAR(100)		NULL				DEFAULT(NULL)
		)

		--------------------------------------------------------------------------------------
		GO
		CREATE PROCEDURE spRecordError
			@params	XML = NULL
		AS BEGIN
			INSERT INTO Errors (
				ERROR_LINE,				ERROR_MESSAGE,
				ERROR_NUMBER,			ERROR_PROCEDURE,
				ERROR_SEVERITY,			ERROR_STATE,
				PARAMS
			) VALUES(
				ERROR_LINE(),			ERROR_MESSAGE(), 
				ERROR_NUMBER(),			ERROR_PROCEDURE(), 
				ERROR_SEVERITY(),		ERROR_STATE(), 
				@PARAMS
			)		
		END

		-------------------------------------------------------------------------------------- XML STUFF
		
		

		SELECT	*,
				[Invoices] = (
					SELECT	*,
							[InvoiceLineItems] = (
								SELECT * 
								FROM InvoiceLineItems
								WHERE InvoiceID = i.InvoiceID
								FOR XML PATH('InvoiceItem'), TYPE
							)
					FROM Invoices i
					WHERE VendorID = v.VendorID
					FOR XML PATH('Invoice'), TYPE
				)
		FROM Vendors v
		WHERE v.VendorID IN (SELECT DISTINCT VendorID FROM Invoices)
		FOR XML PATH('Vendor'), ROOT('Vendors')

		--------------------------------------------------------------------------------------
		GO
		CREATE PROCEDURE spDivide
			@nom FLOAT,
			@den FLOAT
		AS BEGIN
			DECLARE @result FLOAT

			BEGIN TRY
				SET @result = @nom/@den
				SELECT [result] = @result

			END TRY BEGIN CATCH
				-- If there are parameters then create a 
				DECLARE @params XML = (
										SELECT 
											[nom]=CAST(@nom AS DECIMAL(10,2)),
											[den]=CAST(@den AS DECIMAL(10,2)) 
										FOR XML PATH('Parameters')
									  )
															/* TEST QUESTION
																select CAST(4534345.325253532 AS DECIMAL(19,2))
															*/

															/*
																DECIMAL(p,[s])
																	 p		bytes
																	-----	-----
																	1-9		  5
																	10-19	  9
																	20-28	 13
																	29-38	 17
															*/
				-- Record the error
				EXEC spRecordError @params

				-- Possible return value. Nothing is set in stone here...
				SELECT [result] = NULL;
			END CATCH
		END
	

	--------------------------------------------------------------------------------------
	GO
	EXEC spDivide 400, 0
	EXEC spDivide 10, 0
	EXEC spDivide 400, 0
	EXEC spDivide 10, 0
	EXEC spDivide 10, 0
	EXEC spDivide 200, 0

	SELECT * FROM Errors
	GO

/*
	-- To pull data from the XML field... CROSS APPLY is equivalent to JOIN
		----------------------------------------------------------------
		SELECT	e.ERROR_ID,
				row.value('(nom)[1]', 'FLOAT') as nom,
				row.value('(den)[1]', 'FLOAT') as den
		FROM ERRORS e
		CROSS APPLY e.PARAMS.nodes('Parameters') as r(row)

		----------------------------------------------------------------
		SELECT	COUNT(*) AS countOf400
		FROM ERRORS e
		CROSS APPLY e.PARAMS.nodes('Parameters') as r(row)
		WHERE row.value('(nom)[1]', 'FLOAT') = 400
		
		----------------------------------------------------------------
		SELECT	e.ERROR_ID,
				row.value('(nom)[1]', 'FLOAT') as nom,
				row.value('(den)[1]', 'FLOAT') as den
		FROM ERRORS e
		CROSS APPLY e.PARAMS.nodes('Parameters') as r(row)
		WHERE row.value('(nom)[1]', 'FLOAT') = 10
*/	

/* 
	--- An example of running a query on a xml field ---
		DROP TABLE IF EXISTS xmlTEST
		GO

		CREATE TABLE xmlTEST (
			id		INT		PRIMARY KEY 	IDENTITY,
			data	XML
		)
		GO

		INSERT INTO xmlTEST (data) VALUES ((SELECT [nom] = 10, [den] = 22 FOR XML PATH('Parameters')))
		INSERT INTO xmlTEST (data) VALUES ((SELECT [nom] = 55, [den] = 11 FOR XML PATH('Parameters')))
		INSERT INTO xmlTEST (data) VALUES ((SELECT [nom] = 32, [den] = 67 FOR XML PATH('Parameters')))

		GO

		SELECT	e.id,
				row.value('(nom)[1]', 'FLOAT') as nom,
				row.value('(den)[1]', 'FLOAT') as den
		FROM xmlTEST e
		CROSS APPLY e.data.nodes('Parameters') as r(row)
*/