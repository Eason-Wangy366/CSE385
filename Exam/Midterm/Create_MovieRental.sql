USE master;
GO

DROP DATABASE IF EXISTS MovieRentals;
GO

CREATE DATABASE MovieRentals;
GO

USE MovieRentals;
GO

--------------------------------------------------------------------- Tables
CREATE TABLE Customers (
	customerId			INT				PRIMARY KEY		IDENTITY,
	custName			NVARCHAR(50),
	email				NVARCHAR(50),
	password			VARBINARY(MAX),
	phone				NVARCHAR(15)
)
GO

CREATE TABLE Owners(
	ownerId				INT				PRIMARY KEY		IDENTITY,
	ownerName			NVARCHAR(50),
	email				NVARCHAR(50),
	password			VARBINARY(MAX),
	phone				VARCHAR(20)
)
GO

CREATE TABLE Genres (
	genreId				INT				PRIMARY KEY		IDENTITY,
	description			NVARCHAR(50)
)
GO

CREATE TABLE Stores (
	storeId				INT				PRIMARY KEY		IDENTITY,
	companyName			VARCHAR(50),
	address				VARCHAR(200),
	city				VARCHAR(20),
	state				VARCHAR(2),
	zipcode				VARCHAR(10),
	mainPhone			VARCHAR(20)
)
GO

CREATE TABLE StoreOwners (
	ownerId				INT				FOREIGN KEY		REFERENCES Owners(ownerId),
	storeId				INT				FOREIGN KEY		REFERENCES Stores(storeId),
	percentOwner		FLOAT,
	PRIMARY KEY (ownerId, storeId)
)
GO

CREATE TABLE Employees (
	employeeId			INT				PRIMARY KEY		IDENTITY,
	assignedStoreId		INT				FOREIGN KEY		REFERENCES Stores(storeId),
	name				VARCHAR(50)
)
GO

CREATE TABLE Movies (
	movieId				INT				PRIMARY KEY		IDENTITY,	
	storeId				INT				FOREIGN KEY		REFERENCES Stores(storeId),
	title				VARCHAR(150),
	rating				VARCHAR(15),
	rentalAmount		MONEY
)
GO

CREATE TABLE MovieGenres (
	movieId				INT				FOREIGN KEY		REFERENCES Movies(movieId),
	genreId				INT				FOREIGN KEY		REFERENCES Genres(genreId)
)
GO

CREATE TABLE CustomerRentals (
	customerId			INT				FOREIGN KEY		REFERENCES Customers(customerId),
	employeeId			INT				FOREIGN KEY		REFERENCES Employees(employeeId),
	movieId				INT				FOREIGN KEY		REFERENCES Movies(movieId),
	rentalDate			DATETIME,
	dueDate				DATETIME,
	rentalAmount		MONEY
)
GO


--------------------------------------------------------------------- Populate Tables
SET IDENTITY_INSERT Customers ON
	INSERT INTO Customers (customerId, custName, email, password, phone) VALUES 
		 (1, 'Izabel Pettingall', 'ipettingall0@time.com',COMPRESS('Appl@#'), '391-953-2857')
		,(2, 'Lolita Deval', 'ldeval1@hp.com',COMPRESS('Jac995Kson!'), '151-190-0290')
		,(3, 'Maureene O''Conor', 'moconor2@studiopress.com',COMPRESS('MyPassW0RD'), '989-711-1322')
		,(4, 'Stefanie Mellon', 'smellon3@scribd.com',COMPRESS('baCKwA#$RD'), '669-544-8994')
		,(5, 'Diena Crossfeld', 'dcrossfeld4@google.pl',COMPRESS('M0Nd@y'), '960-531-2901')
		,(6, 'Ransell Kinloch', 'rkinloch5@de.vu',COMPRESS('lett#$%'), '102-731-7853')
		,(7, 'Demetra Keetley', 'dkeetley6@ebay.co.uk',COMPRESS('backH@mm&r'), '242-270-4520')
		,(8, 'Philomena Midson', 'pmidson7@drupal.org',COMPRESS('RyM6$NX4'), '666-371-9140')
		,(9, 'Drugi Dunlap', 'ddunlap8@myspace.com',COMPRESS('S$XZE3sh'), '275-170-2525')
		,(10, 'Kristine Poynzer', 'kpoynzer9@businessweek.com',COMPRESS('aBkJ3@Y9'), '177-384-4724')
		,(11, 'Laureen O''Currigan', 'locurrigana@fema.gov',COMPRESS('Abk4&67X'), '714-262-6864')
		,(12, 'Codie Rider', 'criderb@google.co.jp',COMPRESS('Today!$@G00DD@y'), '647-623-4245')
		,(13, 'Zorine Rheubottom', 'zrheubottomc@cnn.com',COMPRESS('powerM@P'), '571-974-2298')
		,(14, 'Frank Flatte', 'fflatted@delicious.com',COMPRESS('9EEQGhMe'), '296-799-6134')
		,(15, 'Olva Bellow', 'obellowe@squarespace.com',COMPRESS('Mhdi303l1C'), '439-104-8567')
		,(16, 'Lyndel O''Kelly', 'lokellyf@qq.com',COMPRESS('2LBXvZqY4B1j'), '246-257-1951')
		,(17, 'Sauncho Poltone', 'spoltoneg@github.io',COMPRESS('aTU7Z6d2X'), '440-578-1872')
		,(18, 'Mandie Gladdolph', 'mgladdolphh@unesco.org',COMPRESS('s5OWEOIKqE'), '173-724-4387')
		,(19, 'Northrop McCormack', 'nmccormacki@ycombinator.com',COMPRESS('DhtoUUzPR'), '775-452-5659')
		,(20, 'Mara Trahearn-Akerman', 'mtrahearnj@cam.ac.uk',COMPRESS('7kaFMWngie'), '142-906-9721')
		,(21, 'Katey Lasseter', 'klasseterk@spotify.com',COMPRESS('GBzRpw'), '485-638-6584')
		,(22, 'Eileen Gonnely', 'egonnelyl@quantcast.com',COMPRESS('gTqHBZLzw4OB'), '905-424-1593')
		,(23, 'Osbert Bogey', 'obogeym@sfgate.com',COMPRESS('BDIb7gsF3FB'), '126-872-2529')
		,(24, 'Morganica Dobrovolski', 'mdobrovolskin@craigslist.org',COMPRESS('WvKnZbFkIss'), '881-701-4225')
		,(25, 'Chaunce Franke', 'cfrankeo@xrea.com',COMPRESS('vNNFepcAIWF'), '886-733-0527')
		,(26, 'Stirling Carnachen', 'scarnachenp@alibaba.com',COMPRESS('idRfI4vctB2y'), '166-743-0744')
		,(27, 'Westley Tonbye', 'wtonbyeq@engadget.com',COMPRESS('W5PNspXyKD8'), '425-472-3228')
		,(28, 'Kerri Tomkins', 'ktomkinsr@blog.com',COMPRESS('4lNObgyQB4'), '161-753-2145')
		,(29, 'Chickie Barendtsen', 'cbarendtsens@gov.uk',COMPRESS('dlnuSXWexE2D'), '405-506-9740')
		,(30, 'Lori Cockshoot', 'lcockshoott@issuu.com',COMPRESS('Qc8l1S7'), '466-408-6585')
		,(31, 'Chic Nyssens', 'cnyssensu@blogtalkradio.com',COMPRESS('mrDuCgHZ'), '612-578-3667')
		,(32, 'Pedro Griswood', 'pgriswoodv@etsy.com',COMPRESS('iCcdkJbe6o'), '737-823-7801')
		,(33, 'Dorree McClaurie', 'dmcclauriew@creativecommons.org',COMPRESS('8Knrdx'), '190-977-3590')
		,(34, 'Scarlet Bulbrook', 'sbulbrookx@youtu.be',COMPRESS('dMRvfjf0M'), '774-382-6916')
		,(35, 'Janie Guerreiro', 'jguerreiroy@slashdot.org',COMPRESS('iHjvTl'), '662-439-5230')
		,(36, 'Tine Wessell', 'twessellz@dmoz.org',COMPRESS('Irjh6quV'), '537-247-8143')
		,(37, 'Barbette Haye', 'bhaye10@ca.gov',COMPRESS('Y1KfSF4H'), '760-964-8369')
		,(38, 'Godfry Frostdyke', 'gfrostdyke11@shareasale.com',COMPRESS('9xl8f0XqjRb'), '350-305-7340')
		,(39, 'Kata Vost', 'kvost12@bandcamp.com',COMPRESS('mcrywmQvtba'), '770-623-5924')
		,(40, 'Luce Ferandez', 'lferandez13@wix.com',COMPRESS('5FPwTdmt'), '832-930-8523')
		,(41, 'Damon Tichner', 'dtichner14@reuters.com',COMPRESS('1lVSEEPumS'), '425-439-1845')
		,(42, 'Loria Giraudat', 'lgiraudat15@redcross.org',COMPRESS('jEbzC8f'), '697-951-3447')
		,(43, 'Jakob Weitzel', 'jweitzel16@devhub.com',COMPRESS('rHsCLuLh8aF'), '712-146-0992')
		,(44, 'Barney Riguard', 'briguard17@acquirethisname.com',COMPRESS('MhYDrZq'), '124-914-5942')
		,(45, 'Louella Martinuzzi', 'lmartinuzzi18@ted.com',COMPRESS('YXdDUSaQv'), '914-493-2790')
		,(46, 'Francisco Curless', 'fcurless19@tmall.com',COMPRESS('7s2cOF'), '809-107-1476')
		,(47, 'Gabbie Manneville', 'gmanneville1a@utexas.edu',COMPRESS('Mvub82yH'), '288-325-0765')
		,(48, 'Susy Hyrons', 'shyrons1b@bloglovin.com',COMPRESS('CRkBDFdYbZ'), '563-339-7603')
		,(49, 'Michael Wignall', 'mwignall1c@blogs.com',COMPRESS('8JIZYxk'), '723-203-6283')
		,(50, 'Mitchel Bickardike', 'mbickardike1d@meetup.com',COMPRESS('sso5VUf3c'), '614-604-3674')
SET IDENTITY_INSERT Customers OFF
GO

SET IDENTITY_INSERT Owners ON
	INSERT INTO Owners (ownerId, ownerName, email, password, phone) VALUES
		 (1, 'Garvin Fosh', 'gfosh0@apache.org', COMPRESS('p0WEr$0unD'), '823-265-0815')
		,(2, 'Correy Jiru', 'cjiru1@yellowpages.com', COMPRESS('MyP@$sW0rD1!'), '901-394-2945')
		,(3, 'Laura Franz-Schoninger', 'lfranzschoninger2@blogspot.com', COMPRESS('backY@RRD$'), '240-211-1391')
		,(4, 'Shelden Derell', 'sderell3@boston.com', COMPRESS('password'), '275-626-0304')
		,(5, 'Mara Trahearn', 'mtrahearnj@cam.ac.uk',COMPRESS('n0th!ngL!ke@$+r0ngPW'), '142-906-9721')
		,(6, 'Mel McCall', 'mmccall5@ow.ly', COMPRESS('melmc@ll'), '321-217-3796')
		,(7, 'Ceciley Breming', 'cbreming6@amazonaws.com', COMPRESS('pwGO!!!'), '334-396-2971')
		,(8, 'Albertine Tocher', 'atocher7@netvibes.com', COMPRESS('WhoR$@msFr!end$?'), '837-806-2122')
		,(9, 'Emmie Hanaby', 'ehanaby8@ameblo.jp', COMPRESS('abcABC!@#123'), '402-794-1696')
		,(10, 'Lyle Chorley', 'lchorley9@washingtonpost.com', COMPRESS('IHATEMAKINGPASSWORDS'), '119-800-0537')
SET IDENTITY_INSERT Owners OFF
GO

SET IDENTITY_INSERT Genres ON
	INSERT INTO Genres(genreId, description) VALUES
		 (1, 'Action')
		,(2, 'Animation')
		,(3, 'Comedy')
		,(4, 'Crime')
		,(5, 'Drama')
		,(6, 'Experimental')
		,(7, 'Fantasy')
		,(8, 'Historical')
		,(9, 'Horror')
		,(10,'Romance')
		,(11,'Science Fiction')
		,(12,'Thriller')
		,(13,'Western')
		,(14,'War')
		,(15,'Documentary')
		,(16,'Adventure')
		,(17,'Children')
		,(18,'Musical')
		,(19,'Mystery')
SET IDENTITY_INSERT Genres OFF
GO

SET IDENTITY_INSERT Stores ON
	INSERT INTO Stores (storeId, companyName, address, city, state, zipcode, mainPhone) values 
		 (1, 'The Flicks', '646 Fulton Street', 'Boise', 'ID', '83702', '208-342-4222')
		,(2, 'CineFile Video', '11280 Santa Monica Blvd', 'Los Angeles', 'CA', '90025', '310-312-8836')		
		,(3, 'Video Free Brooklyn', '308 Bedford Ave', 'Brooklyn', 'NY', '11249', '718-638-6500')
		,(4, 'Vidiots', '4884 Eagle Rock Blvd', 'Los Angeles', 'CA', '90041', '202-554-2825')
		,(5, 'Scarecrow Video', '5030 Roosevelt Way NE', 'Seattle', 'WA', '98105', '206-524-8554')
		,(6, 'Casa Video', '2905 E Speedway Blvd', 'Tucson', 'AZ', '85716', '520-326-6314')
		,(7, 'Facets Vodeo Rentals', '1517 W. Fullerton Ave.', 'Chicago', 'IL', '60614', '773-281-9075')
		,(8, 'The VU', '3203 Washington Street', 'Jamaica Plain', 'MA', '02130', '617-522-4949')
		,(9, 'Four Star Video Cooperative', '459 W Gilman Street', 'Madison', 'WI', '53703', '608-255-1994')
		,(10, 'Movie Lovers', '200 South 23rd Ave.', 'Bozeman', 'MT', '59718', '406-586-0560')
		,(11,'Videodrome', '617 N Highland Ave', 'Atlanta', 'GA', '30306', '404-885-1117')
SET IDENTITY_INSERT Stores OFF
GO


SET IDENTITY_INSERT Movies ON
	INSERT INTO Movies (movieId, storeId, title, rating, rentalAmount) VALUES 
	 (1,1, 'Few of Us','G',4.54)
	,(2,5, 'Over Your Dead Body','PG-13',4.34)
	,(3,6, 'Night Train to Munich','G',3.59)
	,(4,3, 'Lady of Chance','PG-13',4.03)
	,(5,4, 'Heart of a Lion','PG-13',3.65)
	,(6,8, 'Disaster Movie','PG',2.99)
	,(7,9, 'Camp Hell','PG-13',3.27)
	,(8,10, 'Eastern Promises','R',1.73)
	,(9,7, 'Big Bad Wolf','R',3.39)
	,(10,2, 'Jo Pour Jonathan','R',4.88)
	,(11,1, 'Rush Hour 3','PG',4.12)
	,(12,3, 'House on Carroll Street','PG',2.37)
	,(13,6, 'Haxan: Witchcraft Through the Ages','PG-13',3.34)
	,(14,5, 'Onion Movie','R',1.32)
	,(15,8, 'I Don''t Want to Talk About It','PG-13',3.21)
	,(16,9, 'Jules and Jim','PG',2.7)
	,(17,10, 'Question of Silence','R',4.05)
	,(18,9, 'Warning from Space','PG',1.5)
	,(19,6, 'Aaron Loves Angela','PG-13',1.66)
	,(20,3, 'Life Itself','PG-13',2.81)
	,(21,2, 'Les Feux Arctiques','R',4.77)
	,(22,6, 'Oblivion Island: Haruka and the Magic Mirror','PG-13',2.95)
	,(23,1, 'Maborosi','PG',4.07)
	,(24,7, 'Babylon 5: The River of Souls','G',2.34)
	,(25,6, 'Minuscule: Valley of the Lost Ants','G',2.87)
	,(26,5, 'Ghoulies IV','R',4.26)
	,(27,10, 'Wonder Man','PG-13',1.81)
	,(28,4, 'Gainsbourg','G',4.5)
	,(29,2, 'Norte','R',3.46)
	,(30,3, 'Legends of the Fall','G',2.81)
	,(31,1, 'Coffin Rock','NC-17',2.93)
	,(32,6, 'Armstrong Lie','R',3.11)
	,(33,5, 'Innocence','NC-17',4.22)
	,(34,7, 'Goalie''s Anxiety at the Penalty Kick','G',4.58)
	,(35,6, 'Lie with Me','G',1.65)
	,(36,8, 'Third Man','NC-17',2.94)
	,(37,7, 'Bionicle 2: Legends of Metru Nui','NC-17',1.01)
	,(38,9, 'Dr. T and the Women','PG-13',4.08)
	,(39,8, 'Boys Life 4: Four Play','R',1.83)
	,(40,10, 'Catch Me If You Can','PG-13',4.49)
	,(41,9, '3 Blind Mice','PG',4.06)
	,(42,7, 'The Roots of Heaven','R',2.33)
	,(43,6, 'Throw Away Your Books','NC-17',2.84)
	,(44,5, 'Amateur','PG-13',4.33)
	,(45,1, 'Journey to the West: Conquering the Demons','PG',3.97)
	,(46,2, 'Into the Abyss','PG-13',2.29)
	,(47,3, 'Dark Shadows','PG-13',1.67)
	,(48,4, 'Nico and Dani','R',2.87)
	,(49,10, 'Midnight Mary','PG',1.46)
	,(50,8, 'Young Bess','G',1.62)
SET IDENTITY_INSERT Movies OFF
GO


INSERT INTO MovieGenres (movieId, genreId) values 
		 (1,5),(2,9),(3, 12),(3,14),(4, 3),(4,5),(4,10)
		,(5, 3),(5,5),(5,10),(6,3),(7,12),(8, 4),(8,5)
		,(8,12),(9, 3),(9,9),(10,5),(11, 1),(11,3),(11,4)
		,(11,12),(12,12),(13, 15),(13,9),(14,3),(15, 5)
		,(15,10),(16, 5),(16,10),(17,5),(18,11),(19, 3)
		,(19,5),(19,10),(19,12),(20,15),(21, 15),(21,5)
		,(22, 16),(22,2),(22,7),(23,5),(24, 5),(24,11)
		,(25, 16),(25,2),(25,17),(26, 3),(26,9),(27, 3)
		,(27,7),(27,18),(28, 5),(28,18),(28,10),(29,5)
		,(30, 5),(30,10),(30,14),(30,13),(31,12),(32,15)
		,(33, 16),(33,7),(33,9),(34,5),(35, 5),(35,10)
		,(36, 19),(36,12),(37, 1),(37,16),(37,2),(37,17)
		,(37,7),(38, 3),(38,10),(39, 3),(39,5),(40, 4)
		,(40,5),(41, 4),(41,19),(41,10),(41,12),(42, 16)
		,(42,5),(43,5),(44, 4),(44,12),(45, 16),(45,3)
		,(45,7),(45,10),(46,15),(47, 3),(47,9),(48, 3)
		,(48,5),(48,10),(49, 4),(49,5),(49,10),(50, 5)
		,(50,10)
GO

SET IDENTITY_INSERT Employees ON
	INSERT INTO Employees (employeeId, assignedStoreId, name) VALUES 
		 (1, 6, 'Egon Jimmes')
		,(2, 1, 'Bartel Macci')
		,(3, 8, 'Vasilis Piller')
		,(4, 10, 'Nickey Lynes')
		,(5, 8, 'Natalya Iacomelli')
		,(6, 9, 'Pincus Heinig')
		,(7, 3, 'Thacher Von Helmholtz')
		,(8, 7, 'Storm Heinl')
		,(9, 2, 'Fabiano Prosch')
		,(10, 5, 'Cristie Scholcroft')
		,(11, 7, 'Herminia Olivier')
		,(12, 4, 'Gare Gallanders')
		,(13, 9, 'Kesley Tunnacliffe')
		,(14, 4, 'Jacquie Kenshole')
		,(15, 5, 'Cameron Sinkings')
		,(16, 7, 'Filia Wimes')
		,(17, 10, 'Addia Snary')
		,(18, 5, 'Carney Helgass')
		,(19, 6, 'Rora Munslow')
		,(20, 8, 'Gabrila Petricek')
		,(21, 5, 'Terrence Taynton')
		,(22, 9, 'Glennie Smullin')
		,(23, 5, 'Crawford Hutson')
		,(24, 3, 'Sybilla Sedgeworth')
		,(25, 4, 'Webster Cratchley')
		,(26, 2, 'Aland Sedgman')
		,(27, 2, 'Gerladina Leuren')
		,(28, 10, 'Leela Jacquet')
		,(29, 1, 'Ranice McDade')
		,(30, 9, 'Gauthier Hannan')
SET IDENTITY_INSERT Employees OFF



GO


INSERT INTO StoreOwners (ownerId, storeId, percentOwner) VALUES
		 (1,7,90),(9,7,10)
		,(2,2,50),(9,2,40),(5,2,10)
		,(3,5,100)
		,(7,1,20),(4,1,20),(2,1,40),(8,1,20)
		,(2,3,100)
		,(7,8,45),(10,8,50)
		,(4,4,100)
		,(9,6,30),(8,6,30),(5,6,40)
		,(10,9,91),(1,9,10)
		,(2,10,70),(3,10,30)
GO



INSERT INTO CustomerRentals (customerId, employeeId, movieId, rentalDate, dueDate, rentalAmount) VALUES 
	 (45, 2, 31, '2020-07-27', '2020-07-30', 4.12)
	,(17, 30, 16, '2020-05-21', '2020-05-24', 1.68)
	,(19, 2, 1, '2020-12-21', '2020-12-24', 2.23)
	,(37, 26, 46, '2020-03-22', '2020-03-25', 4.80)
	,(29, 2, 23, '2020-12-09', '2020-12-12', 1.61)
	,(43, 1, 19, '2020-11-24', '2020-11-27', 4.46)
	,(35, 26, 29, '2020-10-12', '2020-10-15', 2.59)
	,(30, 20, 50, '2020-06-08', '2020-06-11', 1.73)
	,(42, 9, 21, '2020-09-20', '2020-09-23', 4.70)
	,(37, 29, 23, '2020-08-06', '2020-08-09', 3.51)
	,(42, 26, 29, '2021-02-27', '2021-03-02', 3.87)
	,(3, 2, 31, '2021-02-12', '2021-02-15', 4.33)
	,(8, 25, 48, '2020-05-11', '2020-05-14', 1.42)
	,(49, 7, 12, '2020-06-27', '2020-06-30', 3.26)
	,(35, 5, 50, '2020-05-03', '2020-05-06', 2.30)
	,(17, 24, 20, '2020-04-04', '2020-04-07', 3.11)
	,(45, 4, 49, '2020-04-08', '2020-04-11', 4.49)
	,(46, 1, 13, '2020-12-14', '2020-12-17', 1.08)
	,(34, 29, 1, '2021-02-21', '2021-02-24', 3.88)
	,(20, 3, 50, '2020-04-11', '2020-04-14', 2.57)
	,(5, 3, 15, '2020-05-13', '2020-05-16', 3.08)
	,(8, 4, 27, '2020-11-17', '2020-11-20', 2.62)
	,(6, 10, 26, '2020-07-09', '2020-07-12', 1.50)
	,(5, 7, 12, '2020-07-29', '2020-08-01', 1.94)
	,(21, 1, 3, '2020-04-02', '2020-04-05', 2.06)
	,(31, 29, 23, '2020-06-19', '2020-06-22', 2.36)
	,(20, 15, 14, '2020-10-20', '2020-10-23', 1.30)
	,(11, 2, 1, '2020-11-14', '2020-11-17', 4.58)
	,(11, 1, 19, '2021-03-08', '2021-03-11', 3.54)
	,(8, 30, 16, '2020-12-27', '2020-12-30', 1.22)
	,(21, 4, 40, '2020-05-21', '2020-05-24', 2.19)
	,(8, 2, 1, '2020-08-14', '2020-08-17', 2.57)
	,(19, 19, 13, '2020-06-13', '2020-06-16', 3.95)
	,(49, 24, 20, '2020-03-29', '2020-04-01', 2.21)
	,(39, 24, 47, '2020-07-25', '2020-07-28', 4.98)
	,(14, 2, 1, '2020-12-07', '2020-12-10', 4.11)
	,(13, 28, 17, '2020-04-18', '2020-04-21', 3.75)
	,(37, 22, 16, '2020-08-30', '2020-09-02', 3.71)
	,(16, 16, 34, '2021-02-20', '2021-02-23', 2.31)
	,(33, 30, 38, '2020-06-24', '2020-06-27', 2.27)
	,(41, 14, 5, '2020-10-30', '2020-11-02', 1.50)
	,(37, 17, 40, '2021-02-22', '2021-02-25', 4.73)
	,(3, 22, 38, '2020-12-12', '2020-12-15', 1.68)
	,(44, 11, 34, '2021-01-23', '2021-01-26', 4.24)
	,(17, 2, 45, '2021-02-18', '2021-02-21', 3.72)
	,(12, 30, 41, '2020-04-22', '2020-04-25', 3.54)
	,(18, 28, 49, '2020-12-08', '2020-12-11', 1.03)
	,(45, 6, 38, '2021-01-26', '2021-01-29', 2.43)
	,(36, 8, 37, '2020-12-05', '2020-12-08', 1.69)
	,(18, 24, 47, '2020-06-26', '2020-06-29', 3.55)
	,(49, 11, 24, '2020-09-21', '2020-09-24', 2.92)
	,(39, 19, 13, '2020-04-27', '2020-04-30', 2.42)
	,(33, 11, 37, '2020-12-17', '2020-12-20', 4.95)
	,(48, 20, 36, '2021-02-27', '2021-03-02', 4.78)
	,(36, 4, 8, '2020-08-24', '2020-08-27', 1.31)
	,(2, 21, 26, '2021-01-13', '2021-01-16', 2.86)
	,(50, 16, 42, '2020-09-19', '2020-09-22', 3.09)
	,(12, 7, 20, '2020-11-12', '2020-11-15', 3.10)
	,(18, 4, 17, '2020-08-04', '2020-08-07', 4.74)
	,(35, 17, 17, '2021-01-13', '2021-01-16', 3.16)
	,(1, 6, 41, '2020-05-02', '2020-05-05', 2.85)
	,(44, 24, 47, '2020-04-06', '2020-04-09', 4.44)
	,(10, 1, 13, '2020-08-20', '2020-08-23', 2.73)
	,(11, 3, 6, '2020-07-17', '2020-07-20', 4.19)
	,(13, 1, 43, '2020-08-02', '2020-08-05', 2.75)
	,(33, 19, 32, '2020-08-01', '2020-08-04', 3.32)
	,(39, 26, 21, '2020-08-06', '2020-08-09', 1.94)
	,(36, 26, 10, '2020-12-05', '2020-12-08', 2.12)
	,(33, 12, 28, '2020-10-22', '2020-10-25', 3.96)
	,(39, 10, 2, '2020-06-15', '2020-06-18', 4.34)
	,(19, 14, 28, '2020-11-23', '2020-11-26', 1.39)
	,(46, 8, 9, '2020-05-21', '2020-05-24', 4.68)
	,(17, 7, 47, '2021-02-08', '2021-02-11', 3.57)
	,(40, 10, 14, '2020-11-28', '2020-12-01', 3.32)
	,(32, 11, 42, '2020-08-09', '2020-08-12', 1.45)
	,(1, 28, 40, '2020-08-05', '2020-08-08', 4.97)
	,(49, 20, 36, '2020-12-02', '2020-12-05', 1.11)
	,(1, 5, 39, '2020-12-26', '2020-12-29', 1.17)
	,(23, 15, 2, '2020-06-29', '2020-07-02', 1.35)
	,(2, 12, 48, '2020-08-12', '2020-08-15', 4.89)
	,(3, 1, 35, '2020-04-13', '2020-04-16', 4.99)
	,(41, 8, 34, '2021-02-03', '2021-02-06', 3.68)
	,(40, 29, 31, '2021-02-25', '2021-02-28', 1.41)
	,(18, 1, 25, '2020-08-29', '2020-09-01', 3.82)
	,(20, 24, 4, '2021-01-15', '2021-01-18', 3.29)
	,(41, 8, 42, '2020-07-23', '2020-07-26', 4.53)
	,(10, 6, 18, '2021-02-01', '2021-02-04', 1.52)
	,(9, 9, 29, '2020-08-28', '2020-08-31', 1.99)
	,(22, 20, 15, '2020-11-02', '2020-11-05', 1.13)
	,(22, 29, 31, '2020-12-20', '2020-12-23', 1.43)
	,(40, 5, 6, '2020-06-01', '2020-06-04', 1.03)
	,(39, 19, 43, '2021-03-05', '2021-03-08', 3.71)
	,(31, 3, 36, '2020-04-27', '2020-04-30', 2.86)
	,(38, 20, 39, '2020-08-04', '2020-08-07', 3.42)
	,(49, 11, 37, '2020-05-23', '2020-05-26', 1.87)
	,(31, 16, 37, '2020-05-29', '2020-06-01', 3.36)
	,(41, 21, 2, '2020-09-19', '2020-09-22', 2.81)
	,(8, 29, 31, '2020-06-07', '2020-06-10', 2.08)
	,(12, 25, 28, '2020-12-13', '2020-12-16', 2.24)
	,(40, 27, 10, '2021-03-08', '2021-03-11', 4.31)
GO


