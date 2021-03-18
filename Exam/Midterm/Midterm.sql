USE MovieRentals;
GO

/*
	Date: 2021-03-17
	CSE-385: Midterm Exam

	Student: Eason Wang
*/


/*======================================================================= Q1: na Rows 
	Write the following code so that it can be undone...

	1) Write a SELECT query that returns all columns from CustomerRentals 
	2) Delete all the data from the CustomerRentals table
		- Do this step without using the DELETE keyword. 
	3) Write a SELECT query that returns all columns from CustomerRentals
		that shows all records were deleted. 
	4) Write the code that puts the deleted records back without using
		the INSERT command (just undo the deleted records)
	5) Write a SELECT query that returns all columns from CustomerRentals
		that shows all records were undeleted.... 
*/
/*	
	SELECT *
	FROM CustomerRentals

	TRUNCATE Table CustomerRentals
	
	SELECT *
	FROM CustomerRentals
	*/
	
	
	
	
	
/*======================================================================= Q2: 10 Rows 
	Create a query that returns the ownerId and their decrypted password.
	Name this filed [ownerPassword]. Note: the owner's password was stored
	using the COMPRESS() method.
*/
	

	SELECT ownerId, password,[ownerPassword] = CAST( DECOMPRESS( password )  AS VARCHAR)
	FROM Owners
	
	
	
	
	
	
/*======================================================================= Q3: 9 Rows 
	Create a query that returns the title and rating of all movies that 
	are listed as 'Romance' and fall under any of the PG ratings. 
	Use an EXPLICIT JOIN and order the list by the title
*/
	
	SELECT M.title,M.rating
	FROM Movies M
		JOIN MovieGenres MG ON MG.movieId = M.movieId
		JOIN Genres G ON G.genreId = MG.genreId
	WHERE G.description = 'Romance' AND M.rating LIKE 'PG%'
	ORDER BY M.title
	
	
	
	
	
	
/*======================================================================= Q4: 21 Rows 
	Create a query that returns every companyName, ownerId, and 
	percentOwner. Use an EXPLICIT JOIN and order the list by 
	companyName, then percentOwner
*/
	
	SELECT S.companyName,O.ownerId,SO.percentOwner
	FROM Stores S
		JOIN StoreOwners SO ON SO.storeId = S.storeId
		JOIN Owners O ON O.ownerId = SO.ownerId
	ORDER BY S.companyName, SO.percentOwner

	
	
	
	
	
	
	
	
/*======================================================================= Q5: 2 Rows 
	Using an EXPLICIT JOIN, create a query that returns a list of companies 
	that have an inaccurate percent of ownership. Meaning, store ownership 
	can be split amoung many owners but the total of the percent should
	add up to 100%. You are to find any stores that break this rule. 
	Return the companyName and [sumPercent]. Order the list by sumPercent 
	and use "NEW SCHOOL" notation for naming your sumPercent field
*/
	
	
	SELECT S.companyName, SUM(SO.percentOwner) AS sumPercent
	FROM Stores S
		JOIN StoreOwners SO ON S.storeId = SO.storeId
	GROUP BY S.companyName
	HAVING SUM(SO.percentOwner) <> 100
	ORDER BY sumPercent
	
	
	
	
/*======================================================================= Q6: 11 Rows 
	Using an EXPLICIT JOIN, create a query that returns EVERY store and 
	the count of the number	of movies each store has. Return only the 
	storeId and the count of movies (named movieCount). Use "OLD SCHOOL" 
	notation for naming the	movieCount field. Order by the movieCount
*/
	
	
	SELECT S.storeId, [movieCount] = COUNT(M.movieId) 
	FROM Stores S
		LEFT JOIN Movies M ON M.storeId = S.storeId
	GROUP BY S.storeId
	ORDER BY [movieCount]
	

	
	
	
	
/*======================================================================= Q7: 11 Rows 
	Using NO JOINS, write the same query as above (hint: we did this in the 
	beginning of the semester before we learned about joins)
*/
	
	SELECT S.storeId, [movieCount] = (
									SELECT COUNT(M.storeId)
									FROM Movies M
									WHERE S.storeId = M.storeId
									) 
	FROM Stores S
	ORDER BY [movieCount]
	
	
	
	
	
	
	
/*======================================================================= Q8: 9 Rows
	Return a list of customers that have never rented a movie. Use an
	EXPLICIT JOIN and return the customerId, password, and phone.
	Order the list by password
*/
	
	SELECT C.customerId,C.password, C.phone
	FROM Customers C
		LEFT JOIN CustomerRentals CR ON C.customerId = CR.customerId
	WHERE CR.movieId IS NULL
	ORDER BY C.password
	
	
	
	
	
	
	
/*======================================================================= Q9: 9 Rows
	Create the same output as the previous question but DO NOT use 
	a JOIN (hint: we did this in the beginning of the semester)
*/
	
	
	SELECT C.customerId,C.password, C.phone
	FROM Customers C
	WHERE C.customerId NOT IN (
								SELECT CR.customerId
								FROM CustomerRentals CR
								)
	ORDER BY C.password
	
	
	
	
	
	
/*======================================================================= Q10: 41 Rows 
	Using an EXPLICIT JOIN, create a query that returns the customerId and  
	the total number of times they have rented (named totalRentals). Only
	return customers that have rented movies. Order the list by customerId
	and use "NEW SCHOOL" notation for naming the totalRentals field
*/
	
	
	SELECT C.customerId, COUNT(CR.movieId) AS totalRentals
	FROM Customers C
		JOIN CustomerRentals CR ON CR.customerId = C.customerId 
	GROUP BY C.customerId
	ORDER BY C.customerId
	
	

	
/*======================================================================= Q11: 9 Rows 
	Using an IMPLICIT JOIN, create a query that returns the top 10 customers
	based on the amount of money they have spent. Return custName, the  
	total number of times they have rented (named sumRentals), and the
	total amount of money (named sumPayments) they have paid. Only
	return customers that have rented movies. Also, only return customers
	that have rented more than 3 times. Use "OLD SCHOOL" notation for naming 
	the sumRentals, and sumPayments fields
*/
	
	
	SELECT TOP(10)	C.custName, 
					[sumRentals] = COUNT(CR.movieId),
					[sumPayments] = SUM(CR.rentalAmount)
	FROM Customers C, CustomerRentals CR
	WHERE C.customerId = CR.customerId 
	GROUP BY C.custName
	HAVING COUNT(CR.movieId)>3
	
	
	
	
	
	
	
/*======================================================================= Q12: 8 Rows 
	Write a query that returns the custName, store companyName, and the
	number of times the customer has rented from that store (call this
	field totalRentalsFromStore). Use an EXPLICIT JOIN and "NEW SCHOOL"
	notation for naming the field.  ONLY show customers that have 
	rented more than once from the same store.  Order the list by 
	custName and then companyName
*/
	
	
	
	SELECT C.custName,S.companyName, COUNT(S.storeId) AS totalRentalsFromStore
	FROM Customers C
		JOIN CustomerRentals CR ON C.customerId = CR.customerId
		JOIN Employees E ON CR.employeeId = E.employeeId
		JOIN Stores S ON E.assignedStoreId = S.storeId
	GROUP BY C.custName,S.companyName
	HAVING COUNT(S.storeId)>1
	ORDER BY  C.custName,S.companyName
	
	
	
	
	
	
/*======================================================================= Q13: na Rows 
	Write a query that returns a JSON package with the following 
	structure: custName, [movies] -> title, companyName.

	The fist 18 rows will look like:
	-------------------------------

		[
		  {
			"custName": "Izabel Pettingall",
			"movies": [
			  {
				"title": "3 Blind Mice",
				"companyName": "Four Star Video Cooperative"
			  },
			  {
				"title": "Catch Me If You Can",
				"companyName": "Movie Lovers"
			  },
			  {
				"title": "Boys Life 4: Four Play",
				"companyName": "The VU"
			  }
			]
		  }, 
		  ...

*/
	
	

	SELECT(
		SELECT	C.custName,
				[movies] = (
							SELECT M.title,S.companyName
							FROM Movies M, Stores S,CustomerRentals CR
							WHERE M.storeId = S.storeId AND CR.movieId = M.movieId AND C.customerId = CR.customerId
							FOR JSON PATH
							)
		FROM Customers C
		FOR JSON PATH
			)FOR XML PATH('')
	
	
	
	
	
	
	
/*======================================================================= Q14: na Rows 
	Write a query that returns a XML package with the following 
	structure: [movie] -> movieId, rating, [genres] -> description

	The fist 10 rows will look like:
	-------------------------------
        <movies>
          <movie>
            <movieId>1</movieId>
            <rating>G</rating>
            <genres>
              <genre>
                <description>Drama</description>
              </genre>
            </genres>
          </movie>
          ...
 */
	
	--structure: [movie] -> movieId, rating, [genres] -> description


	SELECT	M.movieId,
			M.rating,
			[genres] = (
						SELECT G.description
						FROM MovieGenres MG, Genres G
						WHERE M.movieId = MG.movieId AND G.genreId = MG.genreId
						FOR XML PATH('genre'), TYPE
							)
	FROM Movies M
	FOR XML PATH('movie'), ROOT('movies')
	
	
	
	
	
	
	
	
/*======================================================================= Q15: 127 Rows 
	Write a query that returns a custName, movie rating, and the count of
	the number of times they rented a movie of that rating (name this field
	[numOfRatedMovies]) Use "OLD SCHOOL" notation for both named fields. 
	Include summary rows for each customer and the overall count of all 
	rented movies. Do not order the list.
	The first customer's data is listed below:

	custName		rating		numOfRatedMovies
	--------------	-----------	-----------------
	Barbette Haye	PG			2
	Barbette Haye	PG-13		2
	Barbette Haye	NULL		4		<-	This is the summary row 
											for Barbette Haye
*/
	
	
	
	SELECT C.custName, M.rating, COUNT(M.rating)
	FROM Customers C
		JOIN CustomerRentals CR ON C.customerId = CR.customerId
		JOIN Movies M ON M.movieId = CR.movieId
	GROUP BY C.custName, M.rating WITH ROLLUP
	