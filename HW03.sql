



	
	USE AP
	GO
	
/* ---------------------------------------------------------------------- 
	 Create a single Stored Procedure that will allow for Adding, Updating,
	 and Deleting to/from the Terms table.
*/
	ALTER PROCEDURE spAddUpdateDeleteTerms
		@TermsID				INT,
		@TermsDueDays			SMALLINT,
		@delete					BIT = 0
	AS BEGIN
		IF @delete = 1 BEGIN
			BEGIN TRY
				DELETE FROM Terms WHERE TermsID = @TermsID
			END TRY BEGIN CATCH
				PRINT 'CANNOT DELETE A PARENT RECORD'
			END CATCH
		END ELSE IF NOT EXISTS(SELECT NULL FROM Terms WHERE TermsID = @TermsID) BEGIN
			SET IDENTITY_INSERT Terms ON
			INSERT INTO Terms (TermsID, TermsDescription, TermsDueDays) VALUES
				(@TermsID, 'Net due ' + cast(@TermsDueDays as varchar(50))+' days', @TermsDueDays)
			SET IDENTITY_INSERT Terms OFF
		END ELSE BEGIN
			UPDATE Terms	SET	TermsDescription = 'Net due ' + cast(@TermsDueDays as varchar(50))+' days',
								TermsDueDays = @TermsDueDays
							WHERE TermsID = @TermsID
		END
	END
