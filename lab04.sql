/*
     Assignment: Lab-04
     Due: 2-22-2021 11:59pm
     Points: 5 pts each = 25
     Author: Eason Wang
*/
/*======================================================== ProductOrders */
USE ProductOrders;
GO

/* ---------------------------------------------------------------------- Q1
    Write a query that returns list of items each customer has purchased.
    Return CustID, OrderID, Quantity, Title, and UnitPrice. Order the list
    by custID and then OrderID

    First 5 Rows:
    -----------------------------------------------------------------
    1    19    1    On The Road With Burt Ruggles                   17.50
    1    479   1    More Songs About Structures and Comestibles     17.95
    1    479   2    Umami In Concert                                17.95
    1    824   2    Rude Noises                                     13.00
    1    824   1    No Rest For The Weary                           16.95

*/

    SELECT  C.CustID,
            O.OrderID,
            D.Quantity,
            I.Title,
            I.UnitPrice
    FROM Customers C
        JOIN Orders O ON C.CustID = O.CustID
        JOIN OrderDetails D ON O.OrderID = D.OrderID
        JOIN Items I ON D.ItemID = I.ItemID
    ORDER BY custID,OrderID



/* ---------------------------------------------------------------------- Q2
    Write a query that returns list of customers and how much they have
    spent in orders and how many orders they have. Return the CustID, a 
    field called TotalAmountPaid, and a field called TotalOrders. Order 
    the list by the CustID.

        First 5 Rows:
        -------------
        1    114.30   3
        2    76.90    4
        3    34.90    2
        4    13.00    1
        5    17.95    1


*/

    SELECT  C.CustID,
            SUM(I.UnitPrice*D.Quantity) AS TotalAmountPaid,
            COUNT(DISTINCT O.OrderID) AS TotalOrders
    FROM Customers C
        JOIN Orders O ON C.CustID = O.CustID
        JOIN OrderDetails D ON O.OrderID = D.OrderID
        JOIN Items I ON D.ItemID = I.ItemID
    GROUP BY C.CustID
    ORDER BY C.CustID



/* ---------------------------------------------------------------------- Q3
    Write a query that returns a list of Customers that have not ordered

    0 Rows returned
*/
    SELECT  C.CustID,COUNT(DISTINCT O.OrderID) AS TotalOrders
    FROM Customers C
        JOIN Orders O ON C.CustID = O.CustID
    GROUP BY C.CustID
    HAVING COUNT(DISTINCT O.OrderID) = 0
    ORDER BY C.CustID
   




/*============================================================= Examples */
USE Examples;
GO

/* ---------------------------------------------------------------------- Q4
    Write a query that retuns the top 3 sales reps with the most total 
    sales Return first name, last name and the total sales called TotalSales

    Result:
    ----------------------------------
    Jonathon    Thomas        3196940.69
    Sonja       Martinez      2841015.55
    Andrew       Markasian    2165620.04
*/

    DECLARE @page INT = 0, @records INT = 3


    SELECT  SR.RepFirstName AS FirstName,
            SR.RepLastName AS LastName,
            SUM(ST.SalesTotal) AS TotalSales
    FROM SalesReps SR
        JOIN SalesTotals ST ON SR.RepID = ST.RepID
    GROUP BY SR.RepFirstName, SR.RepLastName
    ORDER BY    TotalSales DESC
                OFFSET (@page * @records) ROWS
		        FETCH NEXT @records ROWS ONLY








/* ---------------------------------------------------------------------- Q5
    Write a query that retuns the total sales per year. Return the year
    and a field called TotalSales. Sort the list from the highest sales
    to the lowest


    Result:
    ------------------
    2015    4109980.00
    2014    3286197.85
    2016    2003659.02
*/


    SELECT SalesYear, SUM(SalesTotal) AS TotalSales
    FROM SalesTotals 
    GROUP BY SalesYear
    ORDER BY TotalSales DESC