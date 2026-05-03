USE SportsTicketingDB;

CREATE OR REPLACE VIEW v_event_revenue AS
SELECT 
    E.EventName,
    SUM(T.Price) AS TotalRevenue
FROM Bookings B
JOIN Tickets T ON B.TicketID = T.TicketID
JOIN Events E ON T.EventID = E.EventID
GROUP BY E.EventName;
