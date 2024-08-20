SELECT 
ProductID, 
ProductName, 
CategoryName
FROM Products
INNER JOIN Categories 
ON Products.CategoryID = Categories.CategoryID;