SELECT 
    CustomerID,
    CustomerName,
    ContactName,
    Address,
    City,
    PostalCode,
    Country
FROM 
    Customers
WHERE 
    Country IN ('Germany', 'Spain', 'Portugal');