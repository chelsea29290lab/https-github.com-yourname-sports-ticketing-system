USE SportsTicketingDB;

INSERT INTO Events (EventName, EventDate, Venue) VALUES
('Football Match A vs B', '2026-05-10', 'National Stadium'),
('Basketball Finals', '2026-06-15', 'City Arena'),
('Tennis Open Final', '2026-07-20', 'Tennis Center');

INSERT INTO Customers (CustomerName, PhoneNumber, Address) VALUES
('Nguyen Van A', '090000001', 'Hanoi'),
('Tran Thi B', '090000002', 'HCM');

INSERT INTO BoxOffices (OfficeName, Address) VALUES
('Main Office', 'Hanoi'),
('Branch Office', 'District 1');

INSERT INTO Tickets (EventID, TicketType, Price) VALUES
(1,'VIP',100),
(1,'Standard',50),
(2,'VIP',120);

INSERT INTO Seats (EventID, SeatNumber, SeatType) VALUES
(1,'A1','VIP'),
(1,'A2','VIP'),
(2,'B1','Standard');