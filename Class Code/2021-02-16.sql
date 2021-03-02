-- 2021-02-16
-- Chapter 4: Working with multiple tables

--============================================================================================ The Implicit Join 
SELECT v.VendorName, i.InvoiceNumber, i.InvoiceTotal
FROM Vendors v, Invoices i
WHERE v.VendorID = i.VendorID

SELECT v.VendorName, i.InvoiceNumber, i.InvoiceTotal, i.Balance
FROM Vendors v, vwInvoices i
WHERE (v.VendorID = i.VendorID) AND (i.Balance > 0)

SELECT v.VendorName, i.InvoiceNumber, ili.InvoiceLineItemDescription, ili.InvoiceLineItemAmount 
FROM Vendors v, 
	 Invoices i, 
	 InvoiceLineItems ili
WHERE (v.VendorID = i.VendorID) AND (i.InvoiceID = ili.InvoiceID)
ORDER BY v.VendorName, i.InvoiceID, ili.InvoiceSequence

--============================================================================================ The Explicit Join 
SELECT v.VendorName, i.InvoiceNumber, i.InvoiceTotal
FROM Vendors v 
	JOIN Invoices i ON v.VendorID = i.VendorID

SELECT v.VendorName, i.InvoiceNumber, ili.InvoiceLineItemDescription, ili.InvoiceLineItemAmount 
FROM Vendors v
	JOIN Invoices i				ON v.VendorID = i.VendorID
	JOIN InvoiceLineItems ili	ON i.InvoiceID = ili.InvoiceID
ORDER BY v.VendorName, i.InvoiceID, ili.InvoiceSequence

-- Self join that returns vendors from cities in common with other vendors
SELECT DISTINCT v1.VendorName, v1.VendorCity, v1.VendorState
FROM Vendors v1		
	JOIN Vendors v2	ON
		(v1.VendorCity = v2.VendorCity) AND
		(v1.VendorState = v2.VendorState) AND
		(v1.VendorID <> v2.VendorID)
ORDER BY v1.VendorState, v1.VendorCity


/*------------- Create the ProductOrders database -------------*/
-- On the same server:
SELECT v.VendorName, c.CustLastName, c.CustFirstName, v.VendorState, v.VendorCity
FROM AP.dbo.Vendors v
	JOIN ProductOrders.dbo.Customers c ON v.VendorZipCode = c.CustZip
ORDER BY v.VendorState, v.VendorCity

-- Shortcut and ONLY on same server
SELECT v.VendorName, c.CustLastName, c.CustFirstName, v.VendorState, v.VendorCity
FROM AP..Vendors v
	JOIN ProductOrders..Customers c ON v.VendorZipCode = c.CustZip
ORDER BY v.VendorState, v.VendorCity



--============================================================================================ FULL Join
SELECT v.VendorName, c.FirstName
FROM Vendors v 
	FULL JOIN ContactUpdates c ON v.VendorID = c.VendorID

--============================================================================================ CROSS Join
SELECT v.VendorName, i.InvoiceNumber, i.InvoiceTotal
FROM Vendors v, Invoices i
