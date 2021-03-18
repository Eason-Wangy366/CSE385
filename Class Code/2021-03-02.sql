/*----------------------------------------------------------------------------------------------------*/
	-- VendorID, InvoiceNumber, Balance, Status
	--               Balance	Status
	--               -------	---------------
	--				 0		 -> 'Paid'
	--				 1-199	 -> 'Send Reminder'
	--				 200-499 -> 'ALERT'
	--				 >= 500  -> 'Cancel Account'


	-- Using UNION


			SELECT	VendorID,
					InvoiceNumber,
					Balance,
					[Status] = 'Paid'
			FROM vwInvoices
			WHERE Balance = 0
		UNION
			SELECT	VendorID,
					InvoiceNumber,
					Balance,
					[Status] = 'Send Reminder'
			FROM vwInvoices
			WHERE Balance BETWEEN 1 AND 199.99
		UNION
			SELECT	VendorID,
					InvoiceNumber,
					Balance,
					[Status] = 'ALERT'
			FROM vwInvoices
			WHERE Balance BETWEEN 200 AND 499.99
		UNION
			SELECT	VendorID,
					InvoiceNumber,
					Balance,
					[Status] = 'Cancel Account'
			FROM vwInvoices
			WHERE Balance >= 500

	-- VS

		SELECT	VendorID,
				InvoiceNumber,
				Balance,
				[Status] = CASE
					WHEN Balance = 0	THEN 'Paid'
					WHEN Balance < 200	THEN 'Send Reminder'
					WHEN Balance < 500	THEN 'ALERT'
					ELSE					 'Cancel Account'
				END
		FROM vwInvoices
		ORDER BY Balance DESC


/*----------------------------------------------------------------------------------------------------*/
			SELECT	VendorID,
					VendorName,
					[Check] = 'YES'
			FROM Vendors
			WHERE VendorName LIKE '%''%'
		UNION
			SELECT	VendorID,
					VendorName,
					'no'
			FROM Vendors
			WHERE VendorName NOT LIKE '%''%'

	-- OR

		SELECT	VendorID,
				VendorName,
				[Check] =	CASE
								WHEN VendorName LIKE '%''%' THEN 'YES'
								ELSE							 'no'
							END
		FROM Vendors

	-- OR

		SELECT	VendorID,
				VendorName,
				[Check] =	IIF( VendorName LIKE '%''%', 'YES', 'no' )
		FROM Vendors


/*----------------------------------------------------------------------------------------------------*/
	-- VendorID, Address (called Contact)
	--						but:	If Address1 IS NULL then use Address2.
	--								If Address2 IS NULL then use Phone
	--								If Phone IS NULL then simply return 'ERROR'

	-- CASE Version --
		SELECT	VendorID,
				VendorName,
				[Contact] =	CASE
								WHEN VendorAddress1 IS NOT NULL THEN VendorAddress1
								WHEN VendorAddress2 IS NOT NULL THEN VendorAddress2
								WHEN VendorPhone IS NOT NULL	THEN VendorPhone
								ELSE								 'ERROR'
							END,
				VendorAddress1,
				VendorAddress2,
				VendorPhone
		FROM Vendors
		WHERE VendorID IN (15, 16, 95)


	-- IIF Version --
		SELECT	VendorID,
				VendorName,
				[Contact] =	IIF(VendorAddress1 	IS NOT NULL, VendorAddress1, 
							IIF(VendorAddress2 	IS NOT NULL, VendorAddress2, 
							IIF(VendorPhone 	IS NOT NULL, VendorPhone, 'ERROR'))),
				VendorAddress1,
				VendorAddress2,
				VendorPhone
		FROM Vendors
		WHERE VendorID IN (15, 16, 95)


/*----------------------------------------------------------------------------------------------------*/
	-- Use IIF() to flip-flop TermsID of InvoiceNumber '125520-1' from a 1 to a 2 and back
		UPDATE Invoices
		SET TermsID = IIF(TermsID = 1, 2, 1)
		WHERE InvoiceNumber = '125520-1'

		SELECT * FROM Invoices WHERE InvoiceNumber = '125520-1'

	-- Use CASE to flip-flop TermsID of InvoiceNumber '125520-1' from a 1 to a 2 and back
		UPDATE Invoices
		SET TermsID =	CASE 
							WHEN TermsID = 1 THEN 2
							ELSE				  1
						END
		WHERE InvoiceNumber = '125520-1'
		
		SELECT * FROM Invoices WHERE InvoiceNumber = '125520-1'

	-- Using an IF statement with an EXISTS
		IF EXISTS (SELECT NULL FROM Invoices WHERE InvoiceNumber = '125520-1' AND TermsID = 1) BEGIN
			UPDATE Invoices SET TermsID = 2 WHERE InvoiceNumber = '125520-1'
		END ELSE BEGIN
			UPDATE Invoices SET TermsID = 1 WHERE InvoiceNumber = '125520-1'
		END
	
		SELECT * FROM Invoices WHERE InvoiceNumber = '125520-1'


/*----------------------------------------------------------------------------------------------------*/
	GO
		CREATE PROCEDURE spAddGLAccount
			@AccountNo INT,
			@AccountDescription VARCHAR(50)
		AS BEGIN
			IF NOT EXISTS( SELECT NULL FROM GLAccounts WHERE (AccountNo = @AccountNo) ) BEGIN	-- INSERT
				INSERT INTO GLAccounts (AccountNo, AccountDescription) VALUES 
					(@AccountNo, @AccountDescription)
			END
		END
	GO

	-- Include an UPDATE

	GO
		CREATE PROCEDURE spAddUpdateGLAccount
			@AccountNo INT,
			@AccountDescription VARCHAR(50)
		AS BEGIN
			IF NOT EXISTS( SELECT NULL FROM GLAccounts WHERE (AccountNo = @AccountNo) ) BEGIN	-- INSERT
				INSERT INTO GLAccounts (AccountNo, AccountDescription) VALUES 
					(@AccountNo, @AccountDescription)
			END ELSE BEGIN																		-- UPDATE
				UPDATE GLAccounts 
				SET AccountDescription = @AccountDescription 
				WHERE AccountNo = @AccountNo 
			END
		END
	GO

	-- Include a DELETE

	GO
		CREATE PROCEDURE spAddUpdateDeleteGLAccount
			@AccountNo			INT, 
			@AccountDescription VARCHAR(50),
			@delete				BIT = 0
		AS BEGIN
			IF @delete = 1 BEGIN																	-- DELETE
				BEGIN TRY
					DELETE FROM GLAccounts 
					WHERE AccountNo = @AccountNo
				END TRY BEGIN CATCH

				END CATCH
			END ELSE IF EXISTS (SELECT NULL FROM GLAccounts WHERE AccountNo = @AccountNo) BEGIN		-- UPDATE
				UPDATE GLAccounts 
				SET AccountDescription = @AccountDescription 
				WHERE AccountNo = @AccountNo
			END ELSE BEGIN																			-- INSERT
				INSERT INTO GLAccounts (AccountNo, AccountDescription) VALUES 
					(@AccountNo, @AccountDescription)
			END
		END
	GO

	
	EXEC spAddUpdateDeleteGLAccount 100,'Cash', 1
	EXEC spAddUpdateDeleteGLAccount 110,'Accounts Receivable', 1
	EXEC spAddUpdateDeleteGLAccount 552,'Postage', 1
	

	select * from GLAccounts
	
	--	100	Cash
	--	110	Accounts Receivable
	--	552	Postage


/*----------------------------------------------------------------------------------------------------*/
	-- HW-03:
	--	Create an AddUpdateDelete Stored Procedure for the Terms table
	
