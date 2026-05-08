-- =========================================
-- SPORTS TICKETING SYSTEM DATABASE
-- =========================================

CREATE DATABASE IF NOT EXISTS sports_ticketing_system;
USE sports_ticketing_system;

-- =========================================
-- USERS TABLE
-- =========================================

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- STADIUMS TABLE
-- =========================================

CREATE TABLE stadiums (
    stadium_id INT PRIMARY KEY AUTO_INCREMENT,
    stadium_name VARCHAR(150) NOT NULL,
    location VARCHAR(255),
    capacity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================
-- EVENTS TABLE
-- =========================================

CREATE TABLE events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(200) NOT NULL,
    sport_type VARCHAR(100),
    stadium_id INT,
    event_date DATETIME,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (stadium_id)
    REFERENCES stadiums(stadium_id)
    ON DELETE CASCADE
);

-- =========================================
-- MATCHES TABLE
-- =========================================

CREATE TABLE matches (
    match_id INT PRIMARY KEY AUTO_INCREMENT,
    home_team VARCHAR(100),
    away_team VARCHAR(100),
    event_id INT,
    match_status ENUM('upcoming', 'live', 'finished') DEFAULT 'upcoming',
    
    FOREIGN KEY (event_id)
    REFERENCES events(event_id)
    ON DELETE CASCADE
);

-- =========================================
-- SEATS TABLE
-- =========================================

CREATE TABLE seats (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    stadium_id INT,
    section_name VARCHAR(50),
    row_number VARCHAR(20),
    seat_number VARCHAR(20),
    seat_type ENUM('regular', 'vip') DEFAULT 'regular',
    
    FOREIGN KEY (stadium_id)
    REFERENCES stadiums(stadium_id)
    ON DELETE CASCADE
);

-- =========================================
-- TICKETS TABLE
-- =========================================

CREATE TABLE tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    seat_id INT,
    price DECIMAL(10,2),
    status ENUM('available', 'booked', 'cancelled') DEFAULT 'available',
    
    FOREIGN KEY (event_id)
    REFERENCES events(event_id)
    ON DELETE CASCADE,
    
    FOREIGN KEY (seat_id)
    REFERENCES seats(seat_id)
    ON DELETE CASCADE
);

-- =========================================
-- BOOKINGS TABLE
-- =========================================

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    ticket_id INT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('pending', 'paid', 'failed') DEFAULT 'pending',
    
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,
    
    FOREIGN KEY (ticket_id)
    REFERENCES tickets(ticket_id)
    ON DELETE CASCADE
);

-- =========================================
-- PAYMENTS TABLE
-- =========================================

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT,
    amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('success', 'failed', 'pending') DEFAULT 'pending',
    
    FOREIGN KEY (booking_id)
    REFERENCES bookings(booking_id)
    ON DELETE CASCADE
);

-- =========================================
-- ADMIN LOGS TABLE
-- =========================================

CREATE TABLE admin_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_id INT,
    action_performed VARCHAR(255),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (admin_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE
);

-- =========================================
-- SAMPLE USERS
-- =========================================

INSERT INTO users (username, email, password, role)
VALUES
('admin', 'admin@gmail.com', 'hashedpassword123', 'admin'),
('john_doe', 'john@gmail.com', 'hashedpassword456', 'user'),
('alice', 'alice@gmail.com', 'hashedpassword789', 'user');

-- =========================================
-- SAMPLE STADIUMS
-- =========================================

INSERT INTO stadiums (stadium_name, location, capacity)
VALUES
('National Stadium', 'New York', 50000),
('Olympic Arena', 'Los Angeles', 40000);

-- =========================================
-- SAMPLE EVENTS
-- =========================================

INSERT INTO events (event_name, sport_type, stadium_id, event_date, description)
VALUES
('Champions League Final', 'Football', 1, '2026-06-15 19:00:00', 'Major football championship'),
('NBA All Stars', 'Basketball', 2, '2026-07-10 18:00:00', 'Basketball all star event');

-- =========================================
-- SAMPLE MATCHES
-- =========================================

INSERT INTO matches (home_team, away_team, event_id)
VALUES
('Chelsea FC', 'Real Madrid', 1),
('Lakers', 'Warriors', 2);

-- =========================================
-- SAMPLE SEATS
-- =========================================

INSERT INTO seats (stadium_id, section_name, row_number, seat_number, seat_type)
VALUES
(1, 'A', '1', 'A1', 'vip'),
(1, 'A', '1', 'A2', 'vip'),
(2, 'B', '3', 'B10', 'regular');

-- =========================================
-- SAMPLE TICKETS
-- =========================================

INSERT INTO tickets (event_id, seat_id, price, status)
VALUES
(1, 1, 250.00, 'available'),
(1, 2, 250.00, 'booked'),
(2, 3, 120.00, 'available');

-- =========================================
-- SAMPLE BOOKINGS
-- =========================================

INSERT INTO bookings (user_id, ticket_id, payment_status)
VALUES
(2, 2, 'paid');

-- =========================================
-- SAMPLE PAYMENTS
-- =========================================

INSERT INTO payments (booking_id, amount, payment_method, payment_status)
VALUES
(1, 250.00, 'Credit Card', 'success');

-- =========================================
-- CREATE INDEXES
-- =========================================

CREATE INDEX idx_user_email
ON users(email);

CREATE INDEX idx_event_date
ON events(event_date);

CREATE INDEX idx_ticket_status
ON tickets(status);

-- =========================================
-- VIEW: BOOKING DETAILS
-- =========================================

CREATE VIEW booking_details AS
SELECT 
    b.booking_id,
    u.username,
    e.event_name,
    t.price,
    b.payment_status,
    b.booking_date
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN tickets t ON b.ticket_id = t.ticket_id
JOIN events e ON t.event_id = e.event_id;

-- =========================================
-- STORED PROCEDURE
-- =========================================

DELIMITER //

CREATE PROCEDURE GetUserBookings(IN input_user_id INT)
BEGIN
    SELECT 
        b.booking_id,
        e.event_name,
        t.price,
        b.payment_status
    FROM bookings b
    JOIN tickets t ON b.ticket_id = t.ticket_id
    JOIN events e ON t.event_id = e.event_id
    WHERE b.user_id = input_user_id;
END //

DELIMITER ;

-- =========================================
-- TRIGGER
-- =========================================

DELIMITER //

CREATE TRIGGER update_ticket_status
AFTER INSERT ON bookings
FOR EACH ROW
BEGIN
    UPDATE tickets
    SET status = 'booked'
    WHERE ticket_id = NEW.ticket_id;
END //

DELIMITER ;

-- =========================================
-- SHOW TABLES
-- =========================================

SHOW TABLES;
