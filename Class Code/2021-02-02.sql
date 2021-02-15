-- C.R.U.D

	
-- CREATE (INSERT)

	INSERT INTO dbo.tblFriends (firstName, lastName, age, phoneNumber, [address])
	VALUES ('Tom', 'Ryan', 25, '123-456-7890', 'Oxford, OH')

	INSERT INTO dbo.tblFriends (firstName, lastName, age, phoneNumber, [address])
	VALUES ('Jack', 'Ryan', 35, '000-000-0000', 'NY, NY')

	SET IDENTITY_INSERT tblFriends ON

		INSERT INTO dbo.tblFriends (friendId, firstName, lastName, age, phoneNumber, [address])
		VALUES (500, 'Paul', 'Brick', 45, '000-000-0000', 'NY, NY')
	
	SET IDENTITY_INSERT tblFriends OFF

	SELECT * FROM dbo.tblFriends 


-- READ (SELECT)
	-- New School Version of naming
	SELECT	firstName + ' ' + lastName	AS fullName, 
			age							AS friendAge
	FROM dbo.tblFriends

	-- Old School Version of naming
	SELECT	[fullName] = firstName + ' ' + lastName, 
			[friendAge] = age
	FROM dbo.tblFriends
	WHERE [address] = 'NY, NY'

-- UPDATE
	
	UPDATE	tblCars
	SET		make = 'HONDA', [year] = [year] + 1
	WHERE	make = 'HoNdA'

	select * from dbo.tblCars where make = 'honda'

	UPDATE	tblCars
	SET		make = 'Honda', [year] = [year] - 1
	WHERE	make = 'HoNdA'

	select * from dbo.tblCars where make = 'honda'


-- DELETE
	SELECT * FROM tblFriends

	DELETE
	FROM tblFriends
	WHERE friendId > 10

	SELECT * FROM tblFriends

