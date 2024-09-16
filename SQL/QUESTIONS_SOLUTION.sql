
1. What are the details of all customers whose country is 'Spain'?

SELECT * 
FROM Customers
WHERE Country = 'Spain';

2. What are the distinct cities of customers from Germany with a city containing the letter 'B'?

SELECT DISTINCT City 
FROM Customers 
WHERE Country = 'Germany' 
AND City LIKE '%B%';

3. What are the number of orders placed by each customer? Sort the result by the number of orders in descending order.

SELECT 
    CustomerID, 
    COUNT(OrderID) AS OrderCount
FROM Orders
GROUP BY CustomerID
ORDER BY OrderCount DESC;

4. What are the customers who have placed more than 3 orders?

SELECT 
    CustomerID, 
    COUNT(OrderID) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 3;

5. What are the top 5 most expensive products? Round the price to 2 decimal places.

SELECT 
    ProductName, 
    ROUND(CAST(Price AS NUMERIC), 2) AS Price
FROM Products
ORDER BY Price DESC
LIMIT 5;

6. What are the order details (ProductID, Quantity) for customers from France?

SELECT 
	o.OrderID, 
	c.CustomerName, 
	c.Country, 
	od.ProductID, 
	od.Quantity
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE c.Country = 'France';

7. Area there products without a category assigned?

SELECT 
    ProductID, 
    ProductName,
    CategoryID
FROM Products
WHERE CategoryID IS NULL;

8. What are all orders and their employees?

SELECT 
    o.OrderID, 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName
FROM Orders o
LEFT JOIN Employees e ON o.EmployeeID = e.EmployeeID;

9. What is the average, minimum, and maximum price of products? Round the values to 2 decimal places.

SELECT 
    ROUND(CAST(AVG(Price) AS NUMERIC), 2) AS AveragePrice,
    ROUND(CAST(MIN(Price) AS NUMERIC), 2) AS MinimumPrice,
    ROUND(CAST(MAX(Price) AS NUMERIC), 2) AS MaximumPrice
FROM Products;

10. What are the products with prices between 10 and 50? Round the price to 2 decimal places and sort the result by price in descending order.

SELECT 
    ProductID, 
    ProductName, 
    ROUND(CAST(Price AS NUMERIC), 2) AS Price
FROM Products
WHERE Price BETWEEN 10 AND 50
ORDER BY Price DESC;

11. What are the shippers and the total number of orders shipped by each shipper, including those with no orders?

SELECT 
    s.ShipperName, 
    COUNT(o.OrderID) AS TotalOrders
FROM Shippers s
LEFT JOIN Orders o ON s.ShipperID = o.ShipperID
GROUP BY s.ShipperName;

12. What are the employees who have processed > 5 orders? Sort the result by the number of orders in descending order.

SELECT 
	e.EmployeeID, 
	e.FirstName, 
	e.LastName, 
COUNT(o.OrderID) AS OrderCount
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
HAVING COUNT(o.OrderID) > 5
ORDER BY OrderCount DESC;

13. What is the total revenue for each product within each order, including the product name and ordered by order ID and total revenue in descending order?

SELECT 
	od.OrderID,
	p.ProductID,
	p.ProductName,
	ROUND(CAST(SUM(p.Price * od.Quantity) AS NUMERIC), 2) AS TotalRevenue
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY od.OrderID, p.ProductID, p.ProductName
ORDER BY od.OrderID, TotalRevenue DESC;

14. What are the customers, employees, and the total number of orders placed by each customer?

SELECT 
    c.CustomerID, 
    c.CustomerName, 
    e.EmployeeID, 
    e.FirstName, 
    e.LastName, 
    COUNT(o.OrderID) AS TotalOrders
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY c.CustomerID, c.CustomerName, e.EmployeeID, e.FirstName, e.LastName;


15. What are the products with an average price higher than the overall average product price? 
    Round the price to 2 decimal places and sort the result by price in descending order.

SELECT 
    ProductID, 
    ProductName, 
    ROUND(CAST(Price AS NUMERIC), 2) AS Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)
ORDER BY Price DESC;
