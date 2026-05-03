# Sports Ticketing Management System

## Features
- Manage events
- Manage customers
- Book tickets
- Generate revenue reports

## How to Run

Run SQL files in order:
1. 01_schema.sql
2. 02_data.sql
3. 03_procedure.sql
4. 04_view.sql

## Test

```sql
SELECT * FROM Events;
CALL sp_book_ticket(1,1,1,1);
SELECT * FROM v_event_revenue;