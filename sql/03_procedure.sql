USE SportsTicketingDB;

DELIMITER //

CREATE PROCEDURE sp_book_ticket(
    IN cust_id INT,
    IN ticket_id INT,
    IN seat_id INT,
    IN office_id INT
)
BEGIN
    INSERT INTO Bookings(CustomerID, TicketID, SeatID, BoxOfficeID)
    VALUES (cust_id, ticket_id, seat_id, office_id);

    UPDATE Seats
    SET Status = 'Booked'
    WHERE SeatID = seat_id;
END //

DELIMITER ;