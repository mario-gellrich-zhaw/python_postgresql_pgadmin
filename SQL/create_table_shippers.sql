DROP TABLE IF EXISTS Shippers;

CREATE TABLE Shippers (
    ShipperID	VARCHAR(512),
    ShipperName	VARCHAR(512),
    Phone	VARCHAR(512)
);

INSERT INTO Shippers (ShipperID, ShipperName, Phone) VALUES ('1', 'Speedy Express', '(503) 555-9831');
INSERT INTO Shippers (ShipperID, ShipperName, Phone) VALUES ('2', 'United Package', '(503) 555-3199');
INSERT INTO Shippers (ShipperID, ShipperName, Phone) VALUES ('3', 'Federal Shipping', '(503) 555-9931');