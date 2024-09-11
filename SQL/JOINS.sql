-- INNER JOIN
SELECT 
    ProductID,
    ProductName,
    CategoryName
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
ORDER BY ProductID;

-- LEFT JOIN
SELECT 
    Customers.CustomerName,
    Orders.OrderID
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
ORDER BY Customers.CustomerName;

-- RIGHT JOIN
SELECT 
    Orders.OrderID, 
    Employees.LastName, 
    Employees.FirstName
FROM Orders
RIGHT JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
ORDER BY Orders.OrderID;

-- FULL JOIN
SELECT
    Customers.CustomerName,
    Orders.OrderID
FROM Customers
FULL OUTER JOIN Orders ON Customers.CustomerID=Orders.CustomerID
ORDER BY Customers.CustomerName;