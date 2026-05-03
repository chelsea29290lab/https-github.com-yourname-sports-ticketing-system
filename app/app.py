from flask import Flask, jsonify
import mysql.connector
from mysql.connector import Error

app = Flask(__name__)

# ===============================
# DATABASE CONFIG
# ===============================
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "123456",  # đổi password nếu cần
    "database": "SportsTicketingDB"
}

# ===============================
# CONNECT DATABASE
# ===============================
def get_db_connection():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except Error as e:
        print("Database error:", e)
        return None

# ===============================
# HOME
# ===============================
@app.route("/")
def home():
    return jsonify({
        "message": "Sports Ticketing API Running",
        "endpoints": ["/events", "/customers", "/revenue"]
    })

# ===============================
# EVENTS
# ===============================
@app.route("/events")
def get_events():
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Events")
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(data)

# ===============================
# CUSTOMERS
# ===============================
@app.route("/customers")
def get_customers():
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Customers")
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(data)

# ===============================
# REVENUE
# ===============================
@app.route("/revenue")
def get_revenue():
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT E.EventName, SUM(T.Price) AS Revenue
        FROM Bookings B
        JOIN Tickets T ON B.TicketID = T.TicketID
        JOIN Events E ON T.EventID = E.EventID
        GROUP BY E.EventName
    """)

    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(data)

# ===============================
# RUN APP
# ===============================
if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)