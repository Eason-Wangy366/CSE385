USE master
GO

DROP DATABASE IF EXISTS StudentRentals
GO

CREATE DATABASE StudentRentals
GO

USE [StudentRentals]
GO

CREATE TABLE [dbo].[Owner](
	[ownerId]		[int]				NOT NULL	PRIMARY KEY CLUSTERED IDENTITY(1,1),
	[name]			[varchar](50)		NOT NULL,
	[phoneNumber]	[varchar](30)		NOT NULL								
)
GO

CREATE TABLE [dbo].[Property](
	[propertyId]	[int]				NOT NULL	PRIMARY KEY IDENTITY(1,1),
	[address]		[varchar](200)		NOT NULL								
)
GO

CREATE TABLE [dbo].[PropertyOwners](
	[propertyId]	[int]				NOT NULL	FOREIGN KEY REFERENCES Property(propertyId),
	[ownerId]		[int]				NOT NULL	FOREIGN KEY REFERENCES Owner(ownerId),
	[percentOwner]	[float]				NOT NULL,
	PRIMARY KEY  ( [propertyId],[ownerId] )
)
GO

CREATE TABLE [dbo].[Renter](
	[renterId]		[int]				NOT NULL	PRIMARY KEY CLUSTERED IDENTITY(1,1),
	[renterName]	[varchar](50)		NOT NULL,
	[homeAddress]	[varchar](200)		NOT NULL,
	[phoneNumber]	[varchar](30)		NOT NULL,
	[yearInSchool]	[int]				NOT NULL
)
GO

CREATE TABLE [dbo].[RentalData](
	[rentalDataId]	[int]				NOT NULL	PRIMARY KEY CLUSTERED IDENTITY(1,1),
	[propertyId]	[int]				NOT NULL	FOREIGN KEY REFERENCES Property(propertyId),
	[startDate]		[datetime]			NOT NULL,
	[endDate]		[datetime]			NOT NULL,
	[rentalCost]	[float]				NOT NULL,
	[depositReq]	[float]				NOT NULL,
	[damageCost]	[float]				NOT NULL
)
GO

CREATE TABLE [dbo].[PropertyRental](
	[propertyRentalId]	[int]			NOT NULL	PRIMARY KEY CLUSTERED IDENTITY(1,1),
	[renterId]			[int]			NOT NULL	FOREIGN KEY REFERENCES Renter(renterId),
	[rentalDataId]		[int]			NOT NULL	FOREIGN KEY REFERENCES RentalData(rentalDataId),
	[moveInDate]		[datetime]		NOT NULL,
	[moveOutDate]		[datetime]		NULL,
	[deposit]			[float]			NOT NULL	DEFAULT(0.0)
)
GO

CREATE TABLE [dbo].[RentalPayment](	
	[rentalPaymentId]	[int]			NOT NULL	PRIMARY KEY CLUSTERED IDENTITY(1,1),
	[propertyRentalId]	[int]			NOT NULL	FOREIGN KEY REFERENCES PropertyRental(propertyRentalId),
	[paymentDate]		[datetime]		NOT NULL,
	[paymentAmount]		[float]			NOT NULL	DEFAULT(0.0)
)
GO 

SET IDENTITY_INSERT Owner ON
INSERT INTO Owner (ownerId, name, phoneNumber) VALUES
	(1, 'Omar Yukhnov', '835-600-6694'),
	(2, 'Uri Brockway', '339-756-1858'),
	(3, 'Regen Boskell', '966-239-1609'),
	(4, 'Petunia Tyne', '753-951-5047'),
	(5, 'Shannon Samme', '372-460-4394'),
	(6, 'Rebekah MacSkeaghan', '228-330-4696'),
	(7, 'Joelle Newland', '721-249-0537'),
	(8, 'Shae Pettingall', '147-706-8559'),
	(9, 'Heinrik Hazeltine', '169-164-2619'),
	(10, 'Dorena Peplow', '205-232-2047')
SET IDENTITY_INSERT Owner OFF
GO

SET IDENTITY_INSERT Property ON
INSERT INTO Property (propertyId, address) VALUES 
	(1, '134 Boyd Plaza'),
	(2, '104 Petterle Drive'),
	(3, '7 Welch Pass'),
	(4, '36111 Schlimgen Center'),
	(5, '8 Loeprich Terrace'),
	(6, '525 Springview Junction'),
	(7, '4 Dennis Center'),
	(8, '1 Grasskamp Road'),
	(9, '6654 School Point'),
	(10, '999 Maywood Circle'),
	(11, '292 Helena Crossing'),
	(12, '6112 Stone Corner Hill'),
	(13, '3962 Thompson Street'),
	(14, '2637 Thompson Plaza'),
	(15, '5843 Golf Circle'),
	(16, '887 Porter Lane'),
	(17, '547 Oak Valley Center'),
	(18, '8 Macpherson Court'),
	(19, '5 John Wall Terrace'),
	(20, '4578 Paget Hill'),
	(21, '3 Londonderry Park'),
	(22, '8 Lyons Lane'),
	(23, '9024 Forest Run Junction'),
	(24, '75 Warner Court'),
	(25, '03 Union Hill')
SET IDENTITY_INSERT Property OFF
GO

INSERT INTO PropertyOwners (propertyId, ownerId, percentOwner) VALUES 
	(1,1,25),
	(1,2,25),
	(1,3,25),
	(1,4,25),
	(2,5,50),
	(2,6,30),
	(2,7,10),
	(2,8,10),
	(3,9,50),
	(3,10,50),
	(4,1,100),
	(5,2,30),
	(5,5,40),
	(5,7,30),
	(6,4,100),
	(7,5,100),
	(8,6,100),
	(9,8,100),
	(10,9,100),
	(11,10,50),
	(11,4,50),
	(12,10,60),
	(12,1,40),
	(13,9,20),
	(13,8,20),
	(13,7,20),
	(13,6,20),
	(13,5,20),
	(14,4,80),
	(14,3,20),
	(15,2,10),
	(15,1,90),
	(16,1,50),
	(16,6,50),
	(17,2,50),
	(17,7,50),
	(18,9,100),
	(19,10,100),
	(20,7,55),
	(20,4,45),
	(21,3,100),
	(22,7,25),
	(22,6,25),
	(22,5,25),
	(22,2,25),
	(23,8,100),
	(24,2,95),
	(24,10,5),
	(25,1,100)
GO

SET IDENTITY_INSERT RentalData ON
INSERT INTO RentalData (rentalDataId, propertyId, startDate, endDate, rentalCost, depositReq, damageCost) VALUES 
	(1, 1, '8/25/2017', '6/24/2018', 4203, 500, 60),
	(2, 2, '8/20/2017', '6/3/2018', 6671, 500, 754),
	(3, 3, '8/29/2017', '6/5/2018', 3433, 500, 767),
	(4, 4, '8/24/2017', '6/16/2018', 6292, 500, 39),
	(5, 5, '8/27/2017', '6/24/2018', 6798, 500, 810),
	(6, 6, '8/5/2017', '8/24/2018', 7228, 500, 399),
	(7, 7, '8/29/2017', '7/6/2018', 2900, 500, 789),
	(8, 8, '8/21/2017', '8/9/2018', 4709, 500, 462),
	(9, 9, '8/26/2017', '5/19/2018', 3200, 500, 37),
	(10,10, '8/20/2017', '5/16/2018', 2636, 500, 512),
	(11,11, '8/31/2017', '5/26/2018', 7095, 500, 282),
	(12,12, '8/5/2017', '5/28/2018', 3777, 500, 252),
	(13,13, '8/7/2017', '8/26/2018', 2784, 500, 626),
	(14,14, '8/21/2017', '5/14/2018', 3455, 1000, 515),
	(15,15, '8/21/2017', '6/19/2018', 7948, 1000, 747),
	(16,16, '8/5/2017', '5/27/2018', 3447, 1000, 739),
	(17,17, '8/8/2017', '7/17/2018', 6612, 1000, 595),
	(18,18, '8/1/2017', '7/27/2018', 3195, 1000, 43),
	(19,19, '8/6/2017', '8/22/2018', 2641, 1000, 486),
	(20,20, '8/5/2017', '8/16/2018', 5861, 1000, 105),
	(21,21, '8/30/2017', '7/1/2018', 4835, 1000, 531),
	(22,22, '8/5/2017', '5/25/2018', 7044, 1000, 145),
	(23,23, '8/12/2017', '7/13/2018', 7400, 1000, 168),
	(24,24, '8/23/2017', '6/6/2018', 2646, 1000, 716),
	(25,25, '8/23/2017', '5/23/2018', 4294, 1000, 528)
SET IDENTITY_INSERT RentalData OFF
GO

SET IDENTITY_INSERT Renter ON
INSERT INTO Renter (renterId, renterName, homeAddress, phoneNumber, yearInSchool) VALUES 
	(1,   'Thomasa Avramov','92 Algoma Plaza', '491-205-0549', 3),
	(2,   'Amata Scotney','55 Kropf Pass', '473-877-2288', 1),
	(3,   'Frans Reasun','5122 Truax Trail', '123-501-6547', 1),
	(4,   'Tonie MacGibbon','63370 Carpenter Way', '523-408-4018', 3),
	(5,   'Welby Lung','7340 Becker Road', '710-165-9925', 3),
	(6,   'Nathanael Hulburd','982 Ridgeway Alley', '427-789-6967', 3),
	(7,   'Henryetta Loren','0167 Dakota Park', '468-574-8067', 1),
	(8,   'Flo Carreck','853 Westport Road', '956-965-5054', 2),
	(9,   'Deirdre Bradbrook','443 Duke Drive', '368-442-1845', 3),
	(10,  'Ramsay Lanfere','32 Stang Way', '716-755-1981', 5),
	(11,  'Andonis Ellsworthe','6 Shelley Place', '484-934-3773', 3),
	(12,  'Edyth Dike','83 Stang Alley', '838-372-9392', 5),
	(13,  'Bette-ann Lidgett','41334 Magdeline Circle', '189-449-1637', 5),
	(14,  'Tirrell Catton','299 Sherman Pass', '885-291-2253', 3),
	(15,  'Cozmo Wooding','72 Express Park', '641-278-8224', 2),
	(16,  'Frederik Pitman','6311 Talisman Center', '951-149-8362', 3),
	(17,  'Dredi Kundert','9 Superior Plaza', '479-734-0309', 3),
	(18,  'Alvinia Orta','249 Nova Drive', '528-354-2302', 2),
	(19,  'Herta Rudyard','1328 New Castle Street', '255-162-9296', 2),
	(20,  'Parnell Sadd','39010 Sutteridge Road', '809-946-8987', 5),
	(21,  'Courtenay Chisolm','377 Transport Point', '822-805-1537', 2),
	(22,  'Yalonda Minchella','09578 Judy Pass', '143-491-3358', 1),
	(23,  'Dyane Musk','8276 Grayhawk Center', '309-347-2172', 4),
	(24,  'Janek Lucio','18182 Stoughton Circle', '901-428-4237', 1),
	(25,  'Noby Itzhak','73 Moland Parkway', '728-111-2400', 4),
	(26,  'Binnie Sprakes','6888 Londonderry Alley', '705-392-2280', 4),
	(27,  'Aubine Aim','3665 Coolidge Circle', '122-404-5907', 2),
	(28,  'Skelly Joannet','5 Spaight Point', '728-592-4409', 3),
	(29,  'Noach Eltone','28590 Superior Avenue', '492-548-8574', 5),
	(30,  'Juliane Rowbury','6168 Waywood Pass', '178-989-0744', 1),
	(31,  'Elvyn Burleigh','25094 Di Loreto Parkway', '266-376-1986', 5),
	(32,  'Aron Dureden','6 Crownhardt Road', '286-673-8333', 1),
	(33,  'Amalita Carter','2716 Hudson Drive', '885-686-2514', 2),
	(34,  'Ugo Pauletti','6976 Anthes Terrace', '135-689-4262', 4),
	(35,  'Cleo Patron','429 Macpherson Pass', '408-401-9634', 2),
	(36,  'Lainey Short','6599 Mariners Cove Way', '448-196-7479', 5),
	(37,  'Hedvige Pyrton','183 Mcbride Alley', '788-355-8100', 4),
	(38,  'Romola Rittmeier','24066 Service Alley', '591-935-0925', 3),
	(39,  'Farra St. Hill','31875 Logan Crossing', '954-637-7634', 3),
	(40,  'Aluino Muggleston','3 Ruskin Terrace', '544-996-7962', 2),
	(41,  'Lowe Greenleaf','8 Beilfuss Alley', '817-968-1136', 4),
	(42,  'Dov MacCauley','59 Charing Cross Court', '439-239-7584', 3),
	(43,  'Alexis Hayter','6 Haas Plaza', '592-628-6285', 4),
	(44,  'Emlyn Kilius','19 Fremont Center', '623-280-2760', 5),
	(45,  'Olenka Tesmond','32795 Eagan Street', '478-681-4203', 1),
	(46,  'Luciana Risbie','2 Sunbrook Drive', '754-329-3096', 3),
	(47,  'Kaleena Beckley','2177 Bluestem Park', '961-403-7095', 1),
	(48,  'Clark Damsell','21 Dixon Way', '631-645-7802', 2),
	(49,  'Say Johanchon','101 Cherokee Trail', '877-529-9180', 4),
	(50,  'Gaye Shitliffe','4660 Thompson Point', '998-751-7666', 5),
	(51,  'Guy Fuge','3 Fisk Avenue', '303-253-5111', 3),
	(52,  'Tawnya Elwood','28179 Menomonie Terrace', '198-663-4409', 3),
	(53,  'Cassandre Sheepy','98319 Granby Plaza', '626-218-8604', 2),
	(54,  'Inness Scammonden','79 Dottie Place', '949-657-9986', 1),
	(55,  'Nettie Spinello','37 Summer Ridge Avenue', '193-994-1803', 4),
	(56,  'Alwin Branney','0 Daystar Junction', '814-830-2116', 1),
	(57,  'Hayward Genty','4 Bunting Center', '839-175-6836', 4),
	(58,  'Ara Hargroves','0072 Portage Road', '303-401-4097', 5),
	(59,  'Alberto Elderfield','1424 Kensington Hill', '666-544-1829', 1),
	(60,  'Daniel Soans','1 Columbus Plaza', '194-741-9087', 3),
	(61,  'Walsh Lewcock','24 Holy Cross Crossing', '323-768-5290', 4),
	(62,  'Jo Kivlehan','05158 Shasta Plaza', '803-265-7317', 1),
	(63,  'Arnoldo Yarrall','058 Cody Avenue', '369-951-6647', 4),
	(64,  'Carce Liddel','46723 Cascade Circle', '876-291-6893', 5),
	(65,  'Dukie Pickston','40 Manley Road', '558-625-7013', 1),
	(66,  'Ole Pauncefoot','0 Lighthouse Bay Hill', '632-681-5938', 3),
	(67,  'Tynan Hanscome','05 Cardinal Circle', '956-823-6264', 5),
	(68,  'Theodosia Balogun','75 Armistice Avenue', '821-881-4277', 3),
	(69,  'Sam Mathwin','1 Roth Way', '950-881-6509', 1),
	(70,  'Harcourt Reubbens','3362 Russell Drive', '639-756-3538', 2),
	(71,  'Livy Baff','841 Dunning Way', '922-156-1800', 5),
	(72,  'Pepito Fernandes','67 Dovetail Alley', '309-423-6631', 3),
	(73,  'Celesta Cutforth','7972 Vidon Parkway', '587-431-2051', 3),
	(74,  'Corey Stanyer','34 Fordem Hill', '610-334-9338', 1),
	(75,  'Wye Kienlein','17 Bashford Lane', '163-597-4181', 3),
	(76,  'Estell Van Halle','82 American Ash Hill', '596-509-2575', 1),
	(77,  'Wendy Conradie','0 Duke Parkway', '578-133-8174', 4),
	(78,  'Loydie Thowless','469 Farragut Circle', '788-137-1736', 1),
	(79,  'Felice Sherrum','51 Heath Junction', '208-670-6212', 1),
	(80,  'Briggs Elener','1329 Lien Crossing', '514-496-8133', 5),
	(81,  'Julio Broadberrie','34784 Randy Parkway', '137-742-9750', 3),
	(82,  'Bailey Ashbrook','33989 Russell Road', '607-128-7314', 3),
	(83,  'Thedric Weippert','4580 Warner Point', '240-917-8621', 4),
	(84,  'Anastasia Lonnon','26632 Comanche Drive', '833-496-2727', 4),
	(85,  'Brandyn McKern','6490 Oriole Pass', '239-346-6287', 1),
	(86,  'Ettore Gornar','553 Quincy Street', '778-490-9286', 4),
	(87,  'Merilee McIlherran','02403 American Ash Junction', '729-739-9219', 2),
	(88,  'Agna Dunkirk','4 Stoughton Alley', '482-523-5562', 5),
	(89,  'Almeria Foxall','13679 Moland Place', '479-334-5490', 1),
	(90,  'Griffie Blaes','02885 1st Parkway', '222-675-3214', 4),
	(91,  'Lottie Hornbuckle','9182 Buena Vista Point', '768-745-2449', 2),
	(92,  'Tildie Howden','2 Jenna Street', '600-371-9812', 5),
	(93,  'Nickie Mogey','872 Chinook Drive', '892-862-1869', 3),
	(94,  'Hillary Perche','0 Holmberg Alley', '354-630-1248', 3),
	(95,  'Chrissie Buckoke','82674 Talmadge Road', '380-434-2532', 4),
	(96,  'Kimberley Dibnah','10854 Moose Street', '400-861-3779', 2),
	(97,  'Teressa Breckin','8838 Fremont Circle', '776-212-0434', 3),
	(98,  'Carolus Petty','2 Fremont Court', '708-823-4807', 4),
	(99,  'Cornelia Oran','96215 Fieldstone Court', '978-656-7871', 4),
	(100, 'Joscelin Lindup','65 Stephen Crossing', '884-361-8767', 3)
SET IDENTITY_INSERT Renter OFF
GO

SET IDENTITY_INSERT PropertyRental ON
INSERT INTO PropertyRental (propertyRentalId, renterId, rentalDataId, moveInDate, moveOutDate, deposit) VALUES
	(1, 1, 7, '7/3/2018', NULL, 500),
	(2, 4, 7, '5/29/2018', NULL, 500),
	(3, 6, 7, '7/19/2018', NULL, 500),
	(4, 8, 7, '8/11/2018', NULL, 0),
	(5, 2, 9, '6/28/2018', NULL, 500),
	(6, 3, 9, '8/10/2018', NULL, 1000),
	(7, 5, 9, '6/12/2018', NULL, 500),
	(8, 7, 9, '6/4/2018', NULL, 500),
	(9, 9, 9, '6/22/2018', NULL, 0),
	(10, 15, 21, '7/15/2018', NULL, 100),
	(11, 18, 21, '7/1/2018', NULL, 1000),
	(12, 50, 24, '7/9/2018', NULL, 1000),
	(13, 55, 23, '8/19/2018', NULL, 1000),
	(14, 60, 23, '5/21/2018', NULL, 1000),
	(15, 90, 23, '8/11/2018', NULL, 1000)
SET IDENTITY_INSERT PropertyRental OFF
GO


SET IDENTITY_INSERT RentalPayment ON
INSERT INTO RentalPayment (rentalPaymentId, propertyRentalId, paymentDate, paymentAmount) VALUES
	(30	,1	, '2018-07-13',	923),
	(12	,2	, '2018-07-17',	859),
	(6	,3	, '2018-08-25',	786),
	(21	,4	, '2018-06-08',	747),
	(26	,5	, '2018-06-25',	935),
	(28	,5	, '2018-07-09',	740),
	(29	,5	, '2018-08-17',	641),
	(13	,5	, '2018-09-29',	850),
	(1	,6	, '2018-06-17',	554),
	(3	,6	, '2018-07-23',	932),
	(27	,6	, '2018-08-11',	986),
	(24	,7	, '2018-08-21',	923),
	(2	,7	, '2018-09-18',	631),
	(14	,9	, '2018-05-31',	519),
	(20	,9	, '2018-07-10',	650),
	(23	,9	, '2018-08-04',	507),
	(22	,10	, '2018-06-14',	697),
	(11	,10	, '2018-07-04',	594),
	(9	,10	, '2018-08-17',	835),
	(7	,11	, '2018-06-04',	916),
	(8	,11	, '2018-07-25',	641),
	(15	,12	, '2018-07-09',	717),
	(16	,13	, '2018-07-25',	566),
	(18	,13	, '2018-08-02',	565),
	(19	,13	, '2018-09-19',	871),
	(5	,14	, '2018-06-01',	928),
	(17	,14	, '2018-07-19',	946),
	(10	,14	, '2018-08-29',	508),
	(4	,15	, '2018-07-23',	744),
	(25	,15	, '2018-08-26',	703)
SET IDENTITY_INSERT RentalPayment OFF
