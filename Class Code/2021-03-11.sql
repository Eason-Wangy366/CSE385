
--============================================ Transactions and TRY...CATCH revisited

	DECLARE @n1 INT = 10, @n2 INT = 3

	BEGIN TRAN
		BEGIN TRY
			DELETE FROM Errors
			SELECT [answer] = @n1 / @n2
		END TRY BEGIN CATCH
			IF(@@TRANCOUNT > 0) ROLLBACK TRAN
			DECLARE @params XML =	( SELECT [n1] = @n1, [n2] = @n2 FOR XML PATH('PARAMS') )
			EXEC spRecordError @params
		END CATCH
	IF(@@TRANCOUNT > 0) COMMIT TRAN

	SELECT * FROM Errors

--============================================ Hashbytes / Compression

	DECLARE @pw NVARCHAR(30) = 'p@$sW0rD'
	SELECT(
		SELECT	[Password]								=	'p@$sW0rD',
				[HASHBYTES(SHA2_512)-VARCHAR]			=	HASHBYTES('SHA2_512','p@$sW0rD'),
				[HASHBYTES(SHA2_512)-NVARCHAR]			=	HASHBYTES('SHA2_512',CAST('p@$sW0rD' AS NVARCHAR)),
				[COMPRESS]								=	COMPRESS('p@$sW0rD'),
				[COMPRESS2]								=	COMPRESS('KLFJAPFUAJR ;AJFO8UJF;OAIUF;OADSJFA P8USA;OIFJA;OFJH;OEFIJHRE;OIJREWA ;OFIJGEAIRUTIREJADSUGFDAIJGADS FPOLFSDOFJO'),
				[DECOMPRESS]							=	DECOMPRESS( COMPRESS('p@$sW0rD') ),
				[DECOMPRESS_WITH_CAST]					=	CAST( DECOMPRESS( COMPRESS('p@$sW0rD') )  AS VARCHAR),
				[MD2]									=	HASHBYTES('MD2', @pw),
				[MD4]									=	HASHBYTES('MD4', @pw),
				[MD5]									=	HASHBYTES('MD5', @pw),
				[SHA]									=	HASHBYTES('SHA', @pw),
				[SHA1]									=	HASHBYTES('SHA1', @pw),
				[SHA2_256]								=	HASHBYTES('SHA2_256', @pw),
				[SHA2_512]								=	HASHBYTES('SHA2_512', @pw)	-- max orig message size is: 2^128 -2 bits or:
																						-- 340,282,366,920,938,463,463,374,607,431,768,211,454 bits
		FOR JSON PATH
	) FOR XML PATH('')
 --============================================ Querying XML datatype

	DROP TABLE IF EXISTS xmlTEST
	GO

	CREATE TABLE xmlTEST (
		xmlTestId		INT		PRIMARY KEY		IDENTITY,
		studentId		INT,
		testData		XML
	)
	GO

	INSERT INTO xmlTEST (studentId,testData) VALUES
		(55,(	SELECT [t1]=55, [t2]=97, [t3]=84, [t4]=100	FOR XML PATH('exams')	)),
		(65,(	SELECT [t1]=64, [t2]=38, [t3]=55			FOR XML PATH('exams')	)),
		(75,(	SELECT [t1]=77, [t2]=44						FOR XML PATH('exams')	)),
		(85,(	SELECT [t1]=94,			 [t3]=98, [t4]=96	FOR XML PATH('exams')	)),
		(95,(	SELECT [t1]=77, [t2]=75, [t3]=96, [t4]=99	FOR XML PATH('exams')	))
	GO

	WITH tmp AS (
		SELECT	e.xmlTestId,
				e.studentId,
				[t1] = child.value('t1[1]','INT'),
				[t2] = child.value('t2[1]','INT'),
				[t3] = child.value('t3[1]','INT'),
				[t4] = child.value('t4[1]','INT')
		FROM xmlTEST e
		CROSS APPLY e.testData.nodes('exams') parent(child)
	) SELECT(
		SELECT 
			[Test1] = ( SELECT AVG(t1) avg, SUM(t1) count, MIN(t1) min, MAX(t1) max FOR JSON PATH),
			[Test2] = ( SELECT AVG(t2) avg, SUM(t2) count, MIN(t2) min, MAX(t2) max FOR JSON PATH),
			[Test3] = ( SELECT AVG(t3) avg, SUM(t3) count, MIN(t3) min, MAX(t3) max FOR JSON PATH),
			[Test4] = ( SELECT AVG(t4) avg, SUM(t4) count, MIN(t4) min, MAX(t4) max FOR JSON PATH)
		FROM tmp
		FOR JSON PATH
	  ) FOR XML PATH('')