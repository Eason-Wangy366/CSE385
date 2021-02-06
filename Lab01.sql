USE Example;
DROP TABLE IF EXISTS [tblPeople]

-- Q1 (5 pts): Create tblPeople table
CREATE TABLE tblPeople(
	peopleId		Int				NOT NULL		PRIMARY KEY		IDENTITY,
	firstName		VARCHAR(20)		NOT NULL,
	lastName		VARCHAR(20)		NOT NULL,
	email			VARCHAR(40)		NOT NULL,
	gender			VARCHAR(20)		NOT NULL,
	ip_address		VARCHAR(20)		NOT NULL
)


-- Q2 (5 pts): Import your records from the file

BULK   INSERT   tblPeople
	FROM	'C:\temp\Lab-01-People.txt'
	WITH	    (  
					FIRSTROW = 2,
                    FIELDTERMINATOR   =   '\t',  
                    ROWTERMINATOR   =   '\n'  
              )


-- Q3 (5 pts): Query that returns all fields from tblPeople that have a first name of Dale

SELECT * FROM tblPeople WHERE firstName = 'Dale'

-- Q4 (5 pts): Query that returns the first name, last name, and email of all females


SELECT firstName, lastName, email FROM tblPeople WHERE gender = 'Female'