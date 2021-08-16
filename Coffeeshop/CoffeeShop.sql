
--Create Coffeeshop database --
CREATE DATABASE CoffeeShop
go

-- switch to Coffeeshop database--
USE Coffeeshop
go

-- Create Category --
CREATE TABLE Category (
	ID INT PRIMARY KEY IDENTITY(1,1),
	NAME NVARCHAR(50) NOT NULL,
);
go

CREATE TABLE Product(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Product_Name NVARCHAR(50) NOT NULL,
	Description TEXT,
	Price FLOAT,
	Category_id INT REFERENCES Category(ID)
);
go

CREATE TABLE Staff(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Fullname NVARCHAR(50),
	Address NVARCHAR(200),
	Gender NVARCHAR(20),
	Birthday DATE,
	Telephone NVARCHAR(20)
);
go

CREATE TABLE Customer(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Fullname NVARCHAR(50) NOT NULL,
	Telephone NVARCHAR(150),
	Email NVARCHAR(50)
);
go

CREATE TABLE Orders(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Customer_ID INT REFERENCES Customer(ID),
	Staff_id INT REFERENCES Staff(ID),
	Total_price FLOAT
);
go
--Add day of creating order collumn
ALTER TABLE OrderDetail
ADD day_created datetime
Go

CREATE TABLE OrderDetail(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Product_ID INT REFERENCES Product(ID),
	Price FLOAT,
	Order_Number INT,
	Total_price FLOAT,
	Order_ID INT REFERENCES ORDERS(ID)
);
go

-- INSERT DATA INTO TABLES --

INSERT INTO Category (NAME)
VALUES 
('Coffee'),
('Soft drink'),
('Smoothie')
go

INSERT INTO Product(Product_Name,Price, Category_id)
VALUES
('Espresso', '4.5',1),
('Black Coffee', '3.5',1),
('Latte', '5.5',1),
('Mocha', '5',1),
('Coke', '4',2),
('7UP', '4',2),
('Soda', '4',2),
('Mango', '4.5',3),
('Lemon', '4.5',3),
('Orange', '4.5',3),
('WaterMelon', '4.5',3)
go

INSERT INTO Staff(Fullname, Address, Gender, Birthday, Telephone)
VALUES
('Alex Lamemna','01 CornerSt', 'M', '1999-02-06','0456875341'),
('Jessica Alby ','56 CenterSt', 'F', '1997-12-08','046234987'),
('Victor Algor','12 St James', 'M', '1995-02-12','044987234')
go

INSERT INTO Customer(Fullname, Email, Telephone)
VALUES
('Brian McCartney','brianmc@gmail.com','01543876123'),
('James Cook','jamescook@gmail.com','0762349342'),
('Mark Dioro','markdioro@gmail.com','038934234'),
('Angelina Pitt','angelinapitt@gmail.com','0434234098'),
('Anna Bronze','annabronze@gmail.com','0438423400')
go

INSERT INTO Orders(Customer_ID,Staff_id,Total_price)
VALUES
(1,1,13.5),
(2,2,8)
go

UPDATE Orders set day_created  = '2020-8-20'

INSERT INTO OrderDetail(Order_ID,Product_ID, Price, Order_Number, Total_price)
VALUES
(1,1,4.5,3,13.5),
(2,5,4,2,8)

go


--Query list of category--

SELECT * FROM Category
SELECT * FROM Product
go

-- Query: CategoryName, ProductName, Price & Create Store--
SELECT Category.NAME CategoryName, Product.Product_Name ProductName, Product.Price Price
	FROM Category, Product
	WHERE Category.ID = Product.Category_id
		AND Category.ID = 1

GO

CREATE PROCEDURE List_Menu1
	@ID INT
AS 
BEGIN 
	SELECT Category.NAME CategoryName, Product.Product_Name ProductName, Product.Price Price
	FROM Category, Product
	WHERE Category.ID = Product.Category_id
		AND Category.ID = @ID
END
GO
EXEC List_Menu1 3

-- Query category in one order -> write a SQL query and create a store for that function--
----OrdersID, Staffname, CustomerName, ProductName, Price, Num, Pricetotalm OrderDate
----Orders, OrderDetail, Staff, Customer, Product
SELECT Orders.id OrdersID, Staff.Fullname StaffName, Customer.Fullname CustomerName, Product.Product_Name ProductName, OrderDetail.price Price,OrderDetail.Order_Number Num,OrderDetail.day_created DayCreate
FROM Orders, Staff, Customer, Product, OrderDetail
WHERE Orders.ID = OrderDetail.Order_ID
	AND Orders.Customer_ID = Customer.ID
	AND Orders.Staff_id = Staff.ID
	AND OrderDetail.Product_ID = Product.ID
	
SELECT sum(Total_price) 'SUMMARY'
FROM Orders