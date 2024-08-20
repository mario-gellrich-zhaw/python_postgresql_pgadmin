DROP TABLE IF EXISTS Categories;

CREATE TABLE Categories (
    CategoryID	INT,
    CategoryName VARCHAR(255),
    Description	VARCHAR(255)
);

INSERT INTO Categories (CategoryID, CategoryName, Description) VALUES ('1', 'Beverages', 'Soft drinks, coffees, teas, beers, and ales');
INSERT INTO Categories (CategoryID, CategoryName, Description) VALUES ('2', 'Condiments', 'Sweet and savory sauces, relishes, spreads, and seasonings');
INSERT INTO Categories (CategoryID, CategoryName, Description) VALUES ('3', 'Confections', 'Desserts, candies, and sweet breads');
INSERT INTO Categories (CategoryID, CategoryName, Description) VALUES ('4', 'Dairy Products', 'Cheeses');
INSERT INTO Categories (CategoryID, CategoryName, Description) VALUES ('5', 'Grains/Cereals', 'Breads, crackers, pasta, and cereal');
INSERT INTO Categories (CategoryID, CategoryName, Description) VALUES ('6', 'Meat/Poultry', 'Prepared meats');
INSERT INTO Categories (CategoryID, CategoryName, Description) VALUES ('7', 'Produce', 'Dried fruit and bean curd');
INSERT INTO Categories (CategoryID, CategoryName, Description) VALUES ('8', 'Seafood', 'Seaweed and fish');
