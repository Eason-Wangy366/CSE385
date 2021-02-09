USE master;
GO

-- Older version but is safe
IF DB_ID('Example') IS NOT NULL
	DROP DATABASE Example;
GO

-- Newer version but not as safe
DROP DATABASE IF EXISTS Example;
GO

CREATE DATABASE Example;
GO

USE Example;
GO

-- Create a table...
CREATE TABLE dbo.tblFriends (
	friendId		INT				NOT NULL	PRIMARY KEY		IDENTITY,
	firstName		VARCHAR(20)		NOT NULL,
	lastName		VARCHAR(20)		NOT NULL,
	age				INT				NOT NULL	DEFAULT(-1),
	phoneNumber		VARCHAR(20)		NOT NULL	DEFAULT('(***) ***-****'),
	[address]		VARCHAR(200)	NULL		DEFAULT(NULL)
);
GO

/*
	C.R.U.D.

	Create		INSERT
	Read		SELECT
	Update		UPDATE
	Delete		DELETE

*/

-- Version 1: Creates many transactions
INSERT INTO tblFriends (firstName, lastName, age, phoneNumber, [address])	VALUES ('A', 'A', 22, 'A', 'A')
INSERT INTO tblFriends (firstName, lastName, age, phoneNumber)				VALUES ('B', 'B', 22, 'B')
INSERT INTO tblFriends (firstName, lastName, age)							VALUES ('C', 'C', 22)
INSERT INTO tblFriends (firstName, lastName)								VALUES ('D', 'D')
--INSERT INTO tblFriends (firstName)											VALUES ('E')

TRUNCATE TABLE tblFriends;
GO

-- Version 2: Creates 1 transaction
INSERT INTO tblFriends (firstName, lastName, age, phoneNumber, [address])	VALUES 
	 ('a', 'a', 22, 'a', 'a')
	,('b', 'b', 22, 'b', 'b')
	,('c', 'c', 22, 'c', 'c')
	,('d', 'd', 22, 'd', 'd')
GO

--********************************************************************************************
CREATE TABLE tblCars (
		Id		INT			NOT NULL		IDENTITY (1, 1)	PRIMARY KEY,
		vin		VARCHAR(17)	NOT NULL,
		make	VARCHAR(30)	NOT NULL,
		model	VARCHAR(30)	NOT NULL,
		year	INT			NOT NULL,
);

BULK INSERT tblCars
	FROM 'c:\temp\CarData.txt'
	WITH (
		FIRSTROW = 2,
		ROWTERMINATOR = '\n',
		FIELDTERMINATOR = '\t',
		KEEPIDENTITY
	);

SELECT * FROM tblCars WHERE make = 'Honda';  -- 29 records 

UPDATE tblCars SET make = 'HONDA' WHERE make = 'Honda';
SELECT * FROM tblCars WHERE make = 'Honda';

DELETE FROM tblCars WHERE make = 'Honda';
SELECT * FROM tblCars WHERE make = 'Honda';

SELECT * FROM tblCars;
TRUNCATE TABLE tblCars;
SELECT * FROM tblCars;


