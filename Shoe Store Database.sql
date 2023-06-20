-- Create the Shoe Store database
DROP SCHEMA IF EXISTS ShoeStore;
CREATE SCHEMA ShoeStore;

-- Use the Shoe Store database
USE ShoeStore;

-- Create the Customer table
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender CHAR(1),
    telephone VARCHAR(20),
    address VARCHAR(100),
    email VARCHAR(100)
);

-- Create the Department table
CREATE TABLE Department (
    department_code VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(100),
    email VARCHAR(30) UNIQUE NOT NULL
);

-- Create the EmployeeRole table
CREATE TABLE EmployeeRole (
    role_id INT PRIMARY KEY,
    title VARCHAR(100),
    role_description VARCHAR(100)
);

-- Create the Employee table
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    role_id INT,
    department_code VARCHAR(10),
    first_name VARCHAR(20),
    last_name VARCHAR(50),
    gender CHAR(1),
    telephone VARCHAR(20),
    address VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    daily_working_hours INT,
    CHECK(daily_working_hours > 0),
    
    FOREIGN KEY (role_id) REFERENCES EmployeeRole(role_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
        
    FOREIGN KEY (department_code) REFERENCES Department(department_code)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Create the Supplier table
CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    address VARCHAR(100),
    telephone VARCHAR(20),
    email VARCHAR(100)
);

-- Create the Shoe table
CREATE TABLE Shoe (
    model_number INT PRIMARY KEY,
    supplier_id INT,
    brand_name VARCHAR(100),
    colour VARCHAR(50),
    size INT NOT NULL,
    price DECIMAL(10, 2),
    material ENUM('Leather', 'Synthetics','Textiles', 'Rubber'),
    maintenance_method VARCHAR(100),
    
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- Create the Payment table
CREATE TABLE Payment (
    invoice_number INT PRIMARY KEY,
    customer_id INT,
    payment_method VARCHAR(50),
    charge DECIMAL,
    payment_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Create the Reservation table
CREATE TABLE Reservation (
    reservation_id INT PRIMARY KEY,
    employee_id INT,
    customer_id INT,
    model_number INT,
    reservation_date DATE,
    collection_date DATE,
    check (collection_date -reservation_date < 3),
    
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
        
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
        
    FOREIGN KEY (model_number) REFERENCES Shoe(model_number)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Create the PartTime table
CREATE TABLE PartTime (
    employee_id INT PRIMARY KEY,
    number_of_working_days INT,
    hourly_rate DECIMAL(12,1),
    eligibility ENUM('No', 'Yes') NOT NULL,
    CHECK (number_of_working_days > 0 and number_of_working_days < 7),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Create the FullTime table
CREATE TABLE FullTime (
    employee_id INT PRIMARY KEY,
    salary DECIMAL,
    check (salary > 0),
    bonus DECIMAL DEFAULT 0,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Create the Contract table
CREATE TABLE Contract (
    employee_id INT PRIMARY KEY,
    start_date DATE,
    end_date DATE,
    contract_fee DECIMAL,
    CHECK (end_date > start_date),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Create the Casual table
CREATE TABLE Casual (
    model_number INT PRIMARY KEY,
    fashion_level VARCHAR(50),
    open_toed BOOLEAN,
    FOREIGN KEY (model_number) REFERENCES Shoe(model_number)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Create the Formal table
CREATE TABLE Formal (
    model_number INT PRIMARY KEY,
    formal_style VARCHAR(50),
    formal_event_use ENUM('Weddings', 'Work', 'Graduation','Funeral','General Black-Tie Event'),
    FOREIGN KEY (model_number) REFERENCES Shoe(model_number)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Create the Safety table
CREATE TABLE Safety (
    model_number INT PRIMARY KEY,
    protection_level FLOAT(2,1) CHECK(protection_level <= 2.0),
    electric_hazard_rating VARCHAR(50),
    FOREIGN KEY (model_number) REFERENCES Shoe(model_number)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Create the Sport table
CREATE TABLE Sport (
    model_number INT PRIMARY KEY,
    sport_type VARCHAR(50),
    outsole_type VARCHAR(50),
    FOREIGN KEY (model_number) REFERENCES Shoe(model_number)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Create the Inventory table
CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY,
    model_number INT,
    employee_id INT,
    date_stored DATE,
    storage_conditions VARCHAR(100),
    FOREIGN KEY (model_number) REFERENCES Shoe(model_number)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
        
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- INSERTIONS

-- Insert sample data into the Customer table
INSERT INTO Customer (customer_id, first_name, last_name, gender, telephone, address, email)
VALUES
    (1, 'John', 'Doe', 'M', '1234567890', '123 Main St', 'john.doe@example.com'),
    (2, 'Jane', 'Smith', 'F', '9876543210', '456 Elm St', 'jane.smith@example.com'),
    (3, 'Alice', 'Johnson', 'F', '5555555555', '789 Oak St', 'alice.johnson@example.com'),
    (4, 'Bob', 'Williams', 'M', '1112223333', '321 Maple St', 'bob.williams@example.com'),
    (5, 'Emily', 'Brown', 'F', '4444444444', '654 Pine St', 'emily.brown@example.com');

-- Insert sample data into the Department table
INSERT INTO Department (department_code, department_name, location, email)
VALUES
    ('HR', 'Human Resources', 'Room B', 'hr@example.com'),
    ('IT', 'Information Technology', 'Room A', 'it@example.com'),
    ('SALES', 'Sales', 'Room C', 'sales@example.com'),
    ('WAREHOUSE', 'Warehouse', 'Room G', 'warehouse@example.com'),
    ('CS', 'Customer Service', 'Room E', 'cs@example.com'),
    ('FINANCE', 'Finance', 'Room D', 'finance@example.com');
    

-- Insert sample data into the Employee Role table
INSERT INTO EmployeeRole (role_id, title, role_description)
VALUES
    (1, 'Manager', 'Responsible for overall management and decision-making'),
    (2, 'IT Specialist', 'Handles technical support and system maintenance'),
    (3, 'Sales Associate', 'Assists customers with shoe selection and sales'),
    (4, 'Warehouse Staff', 'Manages inventory and handles logistics'),
    (5, 'Attendant','Attends to customers');
    
    
-- Insert sample data into the Employee table
INSERT INTO Employee (employee_id, role_id, department_code, first_name, last_name, gender, telephone, address, email, daily_working_hours)
VALUES
    (1, 1, 'HR', 'John', 'Doe', 'M', '1234567890', '123 Main St', 'john.doe@example.com', 8),
    (2, 2, 'IT', 'Jane', 'Smith', 'F', '9876543210', '456 Elm St', 'jane.smith@example.com', 8),
    (3, 3, 'SALES', 'Alice', 'Johnson', 'F', '5555555555', '789 Oak St', 'alice.johnson@example.com', 8),
    (4, 2, 'IT', 'Bob', 'Williams', 'M', '1112223333', '321 Maple St', 'bob.williams@example.com', 8),
    (5, 4, 'WAREHOUSE', 'Emily', 'Brown', 'F', '4444444444', '654 Pine St', 'emily.brown@example.com', 8);

-- Insert sample data into the Supplier table
INSERT INTO Supplier (supplier_id, company_name, address, telephone, email)
VALUES
    (1, 'ABC Supplier', '123 Supplier St', '1111111111', 'abc@supplier.com'),
    (2, 'XYZ Supplier', '456 Supplier St', '2222222222', 'xyz@supplier.com'),
    (3, '123 Supplier', '789 Supplier St', '3333333333', '123@supplier.com'),
    (4, '456 Supplier', '321 Supplier St', '4444444444', '456@supplier.com'),
    (5, '789 Supplier', '654 Supplier St', '5555555555', '789@supplier.com');

-- Insert sample data into the Shoe table
INSERT INTO Shoe (model_number, supplier_id, brand_name, colour, size, price, maintenance_method)
VALUES
    (1, 1, 'Nike', 'Black', 9, 99.99, 'Wipe clean with a damp cloth'),
    (2, 2, 'Adidas', 'White', 10, 89.99, 'Hand wash with mild detergent'),
    (3, 3, 'Puma', 'Blue', 8, 79.99, 'Spot clean with a brush'),
    (4, 4, 'Reebok', 'Red', 9.5, 69.99, 'Machine washable'),
    (5, 5, 'New Balance', 'Gray', 7.5, 59.99, 'Air dry after use');


-- Insert sample data into the Payment table
INSERT INTO Payment (invoice_number, customer_id, payment_method, charge, payment_date)
VALUES
    (1, 1, 'Credit Card',(SELECT SUM(price) FROM Shoe, Reservation, Customer WHERE Reservation.model_number = Shoe.model_number AND Customer.customer_id = 1),  '2022-01-15'),
    (2, 2, 'Cash', (SELECT SUM(price) FROM Shoe, Reservation, Customer WHERE Reservation.model_number = Shoe.model_number AND Customer.customer_id = 2), '2022-02-28'),
    (3, 3, 'Debit Card', 100, '2022-03-10'),
    (4, 4, 'PayPal', 200, '2022-04-05'),
    (5, 5, 'Bank Transfer', 200, '2022-05-20');

-- Insert sample data into the Reservation table
INSERT INTO Reservation (reservation_id, employee_id, customer_id, model_number, reservation_date, collection_date)
VALUES
    (1, 1, 1, 1, '2022-01-10', '2022-01-12'),
    (2, 2, 2, 2, '2022-02-20', '2022-02-21');
   

-- Insert sample data into the Part Time table
INSERT INTO PartTime (employee_id, number_of_working_days, hourly_rate)
VALUES
    (1, 3, 15.0),
    (4, 3, 14.0),
    (5, 2, 13.5);
INSERT INTO PartTime (employee_id, number_of_working_days, hourly_rate, eligibility)
VALUES
	(2, 4, 12.5, "Yes"),
    (3, 5, 11.0, "Yes");

-- Insert sample data into the Full Time table
INSERT INTO FullTime (employee_id, salary, bonus)
VALUES
    (1, 5000.0, 1000.0),
    (2, 4500.0, 900.0),
    (3, 4000.0, 800.0),
    (4, 4800.0, 960.0),
    (5, 4200.0, 840.0);

-- Insert sample data into the Contract table
INSERT INTO Contract (employee_id, start_date, end_date, contract_fee)
VALUES
    (1, '2022-01-01', '2022-06-30', 10000.0),
    (2, '2022-02-01', '2022-07-31', 9000.0),
    (3, '2022-03-01', '2022-08-31', 8000.0),
    (4, '2022-04-01', '2022-09-30', 9500.0),
    (5, '2022-05-01', '2022-10-31', 8500.0);

-- Insert sample data into the Casual table
INSERT INTO Casual (model_number, fashion_level, open_toed)
VALUES
    (1, 'High', 1),
    (2, 'Medium', 0),
    (3, 'Low', 1),
    (4, 'Medium', 0),
    (5, 'High', 1);

-- Insert sample data into the Formal table
INSERT INTO Formal (model_number, formal_style, formal_event_use)
VALUES
    (1, 'Oxford', 'Weddings'),
    (2, 'Loafer', 'Funeral'),
    (3, 'Derby', 'Work'),
    (4, 'Monk Strap', 'Graduation'),
    (5, 'Brogue', 'General Black-Tie Event');

-- Insert sample data into the Safety table
INSERT INTO Safety (model_number, protection_level, electric_hazard_rating)
VALUES
    (1, 2, 'Non-Electric Hazard'),
    (2, 1, 'Electric Hazard'),
    (3, 1, 'Non-Electric Hazard'),
    (4, 2, 'Electric Hazard'),
    (5, 1, 'Non-Electric Hazard');

-- Insert sample data into the Sport table
INSERT INTO Sport (model_number, sport_type, outsole_type)
VALUES
    (1, 'Running', 'Rubber'),
    (2, 'Basketball', 'Synthetic'),
    (3, 'Tennis', 'Herringbone'),
    (4, 'Soccer', 'Studded'),
    (5, 'Golf', 'Spikeless');

-- Insert sample data into the Inventory table
INSERT INTO Inventory (inventory_id, model_number, employee_id, date_stored, storage_conditions)
VALUES
    (1, 1, 1, '2022-01-01', 'Dry and cool'),
    (2, 2, 2, '2022-02-01', 'Humidity controlled'),
    (3, 3, 3, '2022-03-01', 'Well ventilated');

-- CREATING INDEXES
-- customer index. To help track customers and the shoes they bought
CREATE INDEX idx_Customer ON Customer (first_name, last_name);

-- shoes index. They are the things that define a customer's choice of shoe 
CREATE INDEX idx_shoes ON Shoe(colour, size, brand_name);

-- supplier index. To help in finding what shoe the company supplies 
CREATE UNIQUE INDEX idx_supplier ON Supplier (company_name, email);

-- employee index. To check which employees can be requested to be full time employees
CREATE INDEX idx_employee ON PartTime(eligibility);

-- QUERIES

-- Tracking the shoes that are available 
SELECT brand_name AS Brand_Name, size As Size, colour AS Colour, price AS Price
FROM Shoe WHERE model_number IN (SELECT model_number FROM inventory);

-- Generating bill for purchases made by Customer
SELECT DISTINCT Customer.first_name, Customer.last_name,
Payment.payment_method, Payment.charge, Payment.payment_date
FROM Customer JOIN Payment ON Customer.customer_id = Payment.customer_id ORDER BY Customer.first_name;

-- Tracking the number of shoes in inventory by storage categories
SELECT storage_conditions AS Storage_Conditions, COUNT(storage_conditions) AS Number_of_Shoes
FROM Inventory GROUP BY storage_conditions;

-- Get information on current shoe reservations.
SELECT brand_name AS Brand_Name, size AS Size, colour as Colour,
reservation_date AS Reservation_Date, collection_date AS Collection_Date
FROM Reservation, Shoe WHERE Shoe.model_number = Reservation.model_number 
ORDER BY reservation_date DESC;

-- Tracking the suppliers and the shoe brand they provide.
SELECT company_name as Company_Name, brand_name AS Brand_Name FROM
Supplier, Shoe WHERE Shoe.supplier_id = Supplier.supplier_id;

-- Getting part-time employees that are eligible for full time employment.
SELECT * FROM Employee WHERE employee_id IN 
(SELECT employee_id FROM PartTime WHERE Employee.employee_id = PartTime.employee_id
AND PartTime.number_of_working_days >=3);

 
