CREATE DATABASE IF NOT EXISTS SportsTicketingDB;
USE SportsTicketingDB;

-- EVENTS
CREATE TABLE Events (
    EventID INT AUTO_INCREMENT PRIMARY KEY,
    EventName VARCHAR(100),
    EventDate DATE,
    Venue VARCHAR(100)
);

-- CUSTOMERS
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100),
    PhoneNumber VARCHAR(15) UNIQUE,
    Address VARCHAR(100)
);

-- BOX OFFICES
CREATE TABLE BoxOffices (
    BoxOfficeID INT AUTO_INCREMENT PRIMARY KEY,
    OfficeName VARCHAR(100),
    Address VARCHAR(100)
);

-- TICKETS
CREATE TABLE Tickets (
    TicketID INT AUTO_INCREMENT PRIMARY KEY,
    EventID INT,
    TicketType VARCHAR(50),
    Price DECIMAL(10,2),
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

-- SEATS
CREATE TABLE Seats (
    SeatID INT AUTO_INCREMENT PRIMARY KEY,
    EventID INT,
    SeatNumber VARCHAR(10),
    SeatType VARCHAR(50),
    Status VARCHAR(20) DEFAULT 'Available',
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

-- BOOKINGS
CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    TicketID INT,
    SeatID INT,
    BoxOfficeID INT,
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID),
    FOREIGN KEY (SeatID) REFERENCES Seats(SeatID),
    FOREIGN KEY (BoxOfficeID) REFERENCES BoxOffices(BoxOfficeID)
);