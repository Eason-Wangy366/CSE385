/*
	Practice II, Exam-01
	
*/
	
--1.	(49 records) Write the query that returns each property owned by an owner. 
--		Return the owner's name, phone number, and the property's address. 
--		Sort the list by address and then the owner's name.
	
	SELECT O.name,O.phoneNumber,P.address
	FROM Owner O, PropertyOwners PO, Property P
	WHERE O.ownerId=PO.ownerId AND P.propertyId = PO.propertyId
	ORDER BY P.address,O.name

-- 2.	(3 records) Write the query that returns each renter that still owes a deposit. 
--		Return the renter's name, property's address, the amount of deposit the renter 
--		has paid, what the required deposit should be for the property, and the amount 
--		of deposit the renter still owes (user defined field called "depositOwed"). 
--		Sort the list by the renter's name
	
	SELECT R.renterName,P.address,PR.deposit,RD.depositReq,[depositOwed]=PR.deposit-RD.depositReq
	FROM RentalData RD, PropertyRental PR, Renter R, Property P
	WHERE	RD.rentalDataId = PR.rentalDataId AND 
			R.renterId = PR.renterId AND 
			P.propertyId = RD.propertyId AND
			PR.deposit-RD.depositReq < 0
	ORDER BY R.renterName


-- 3.	(4 record) Write the query that returns each renter that still owes a deposit as 
--		well as the renters that paid too much deposit. Return the renter's name, property's 
--		address, the amount of deposit the renter has paid, what the required deposit should 
--		be for the property, and the amount of deposit the renter still owes owes 
--		(user defined field called "depositOwed"). Sort the list by the renter's name. 
--		Note: your answer should be written so there is only 1 SELECT statement.
	
	SELECT R.renterName,P.address,PR.deposit,RD.depositReq,[depositOwed]=PR.deposit-RD.depositReq
	FROM RentalData RD, PropertyRental PR, Renter R, Property P
	WHERE	RD.rentalDataId = PR.rentalDataId AND 
			R.renterId = PR.renterId AND 
			P.propertyId = RD.propertyId AND
			PR.deposit-RD.depositReq <> 0
	ORDER BY R.renterName
	
	

-- 4.	(15 records) Write the query that returns each renter that still owes a deposit, 
--		renters that paid too much deposit, and renters that paid the correct amount of deposit. 
--		Return the renter's name, property's address, the amount of deposit the renter has paid, 
--		what the required deposit should be for the property, the amount of deposit the renter 
--		still owes owes (user defined field called "depositOwed"), and a field called "status" 
--		that displays the appropriate text: "OK", "Outstanding Account", or "Refund Needed". 
--		Sort the list by the renter's name.
		
	SELECT	R.renterName,
			P.address,
			PR.deposit,
			RD.depositReq,
			[depositOwed]=RD.depositReq-PR.deposit,
			[Status] = CASE
							WHEN RD.depositReq = PR.deposit THEN 'OK'
							WHEN RD.depositReq > PR.deposit THEN 'Outstanding Account'
							ELSE 'Refund Needed'
						END
	FROM RentalData RD, PropertyRental PR, Renter R, Property P
	WHERE	RD.rentalDataId = PR.rentalDataId AND 
			R.renterId = PR.renterId AND 
			P.propertyId = RD.propertyId
	ORDER BY [status],R.renterName
		
		
		

-- 5.	(5 records) Write an implicit query that returns the first 5 property address and 
--		owner's name where the owner owns 100% of the property. Sort the list by the 
--		address and then the owner
	
	SELECT TOP(5) O.name,P.address
	FROM Owner O, PropertyOwners PO, Property P
	WHERE O.ownerId=PO.ownerId AND P.propertyId = PO.propertyId AND PO.percentOwner = 100
	ORDER BY  P.address,O.name
	


-- 6.	(5 records) Assuming you have seen the first 5 rows listed in the previous question display the next 5 rows

	SELECT O.name,P.address
	FROM Owner O, PropertyOwners PO, Property P
	WHERE O.ownerId=PO.ownerId AND P.propertyId = PO.propertyId AND PO.percentOwner = 100
	ORDER BY  P.address,O.name
		OFFSET 5 ROWS
			FETCH NEXT 5 ROWS ONLY



-- 7.	(1 record) Write the query that will return all property addresses and renter's name that are 
--		renting but not paid rent. Also include a user defined column called "status" and assign it "No Rent Paid"

	SELECT *
	FROM RentalData





