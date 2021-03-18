/*

	Practice II, Exam-01
	SOLUTION
	
*/

--1.	(49 records) Write the query that returns each property owned by an owner. 
--		Return the owner's name, phone number, and the property's address. 
--		Sort the list by address and then the owner's name.
	SELECT o.name, o.phoneNumber, p.address
	FROM Owner o 
		JOIN PropertyOwners po ON
			o.ownerId = po.ownerId
		JOIN Property p ON
			p.propertyId = po.propertyId
	ORDER BY p.address, o.name


-- 2.	(3 records) Write the query that returns each renter that still owes a deposit. 
--		Return the renter's name, property's address, the amount of deposit the renter 
--		has paid, what the required deposit should be for the property, and the amount 
--		of deposit the renter still owes (user defined field called "depositOwed"). 
--		Sort the list by the renter's name
	SELECT	r.renterName, p.address, pr.deposit,rd.depositReq,
		[depositOwed] = rd.depositReq - pr.deposit
	FROM Renter r
		JOIN PropertyRental pr 	ON (r.renterId = pr.renterId)
		JOIN RentalData rd 		ON (pr.rentalDataId = rd.rentalDataId)
		JOIN Property p 		ON (rd.propertyId = p.propertyId)
	WHERE pr.deposit < rd.depositReq
	ORDER BY r.renterName


-- 3.	(4 record) Write the query that returns each renter that still owes a deposit as 
--		well as the renters that paid too much deposit. Return the renter's name, property's 
--		address, the amount of deposit the renter has paid, what the required deposit should 
--		be for the property, and the amount of deposit the renter still owes owes 
--		(user defined field called "depositOwed"). Sort the list by the renter's name. 
--		Note: your answer should be written so there is only 1 SELECT statement.
	SELECT	r.renterName, p.address, pr.deposit, rd.depositReq,
		[depositOwed] = rd.depositReq - pr.deposit
	FROM Renter r
		JOIN PropertyRental pr ON
			(r.renterId = pr.renterId)
		JOIN RentalData rd ON
			(pr.rentalDataId = rd.rentalDataId)
		JOIN Property p ON
			(rd.propertyId = p.propertyId)
	WHERE pr.deposit <> rd.depositReq
	ORDER BY r.renterName

-- 4.	(15 records) Write the query that returns each renter that still owes a deposit, 
--		renters that paid too much deposit, and renters that paid the correct amount of deposit. 
--		Return the renter's name, property's address, the amount of deposit the renter has paid, 
--		what the required deposit should be for the property, the amount of deposit the renter 
--		still owes owes (user defined field called "depositOwed"), and a field called "status" 
--		that displays the appropriate text: "OK", "Outstanding Account", or "Refund Needed". 
--		Sort the list by the renter's name.
		SELECT	r.renterName, p.address, pr.deposit, rd.depositReq,
				[depositOwed] = rd.depositReq - pr.deposit, [status] = 'Outstanding Account'
		FROM Renter r
				JOIN PropertyRental	pr	ON	(r.renterId 		= 	pr.renterId)
				JOIN RentalData	rd 	ON	(pr.rentalDataId 	= 	rd.rentalDataId)
				JOIN Property		p 	ON	(rd.propertyId 	=	p.propertyId)
		WHERE pr.deposit < rd.depositReq
	UNION
		SELECT	r.renterName, p.address, pr.deposit, rd.depositReq,
				[depositOwed] = rd.depositReq - pr.deposit, [status] = 'Refund Needed'
		FROM Renter r
				JOIN PropertyRental	pr	ON	(r.renterId 		= 	pr.renterId)
				JOIN RentalData	rd 	ON	(pr.rentalDataId 	= 	rd.rentalDataId)
				JOIN Property		p 	ON	(rd.propertyId 	=	p.propertyId)
		WHERE pr.deposit > rd.depositReq
	UNION
		SELECT	r.renterName, p.address, pr.deposit, rd.depositReq,
				[depositOwed] = rd.depositReq - pr.deposit, [status] = 'OK'
		FROM Renter r
				JOIN PropertyRental	pr	ON	(r.renterId 		= 	pr.renterId)
				JOIN RentalData	rd 	ON	(pr.rentalDataId 	= 	rd.rentalDataId)
				JOIN Property		p 	ON	(rd.propertyId 	=	p.propertyId)
		WHERE pr.deposit = rd.depositReq
		ORDER BY [status], p.address, r.renterName 

-- 5.	(5 records) Write an implicit query that returns the first 5 property address and 
--		owner's name where the owner owns 100% of the property. Sort the list by the 
--		address and then the owner
	SELECT TOP(5) p.address, o.name
	FROM Owner o, PropertyOwners po, Property p
	WHERE	o.ownerId = po.ownerId AND
		po.propertyId = p.propertyId AND
		po.percentOwner = 100
	ORDER BY p.address, o.name


-- 6.	(5 records) Assuming you have seen the first 5 rows listed in the previous question display the next 5 rows
	SELECT p.address, o.name
	FROM Owner o, PropertyOwners po, Property p
	WHERE	o.ownerId = po.ownerId AND
		po.propertyId = p.propertyId AND
		po.percentOwner = 100
	ORDER BY p.address, o.name
		OFFSET 5 ROWS
			FETCH NEXT 5 ROWS ONLY

-- 7.	(1 record) Write the query that will return all property addresses and renter's name that are 
--		renting but not paid rent. Also include a user defined column called "status" and assign it "No Rent Paid"
	SELECT p.address, r.renterName, [status] = 'No Rent Paid'
	FROM Renter r 
		JOIN PropertyRental		pr	ON	(r.renterId = pr.renterId)
		LEFT JOIN RentalPayment 	rp	ON	(pr.propertyRentalId = rp.propertyRentalId)
		JOIN RentalData		rd	ON	(pr.rentalDataId = rd.rentalDataId)
		JOIN Property			p	ON	(rd.propertyId = p.propertyId)
	WHERE pr.deposit > 0 AND rp.paymentAmount IS NULL
	ORDER BY p.address, r.renterName





