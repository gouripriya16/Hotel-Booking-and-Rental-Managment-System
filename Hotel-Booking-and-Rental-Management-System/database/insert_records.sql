USE hotel_booking_rental_management;

-- Truncate existing data
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE payment;
TRUNCATE TABLE booking;
TRUNCATE TABLE room;
TRUNCATE TABLE guest;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Insert Guests
INSERT INTO guest (guest_id, guest_name, phone, email, address, identification_type, identification_number) VALUES
(1, 'Aarav Sharma', '+919876543210', 'aarav@example.com', 'Mumbai', 'Passport', 'P1234567'),
(2, 'Priya Patel', '+919876543211', 'priya@example.com', 'Ahmedabad', 'Aadhaar', '123456789012'),
(3, 'Rohan Verma', '+919876543212', 'rohan@example.com', 'New Delhi', 'Driving License', 'DL98765432'),
(4, 'Ananya Iyer', '+919876543213', 'ananya@example.com', 'Chennai', 'Passport', 'P7654321'),
(5, 'Vikram Singh', '+919876543214', 'vikram@example.com', 'Jaipur', 'Aadhaar', 'NID456789');

-- 2. Insert Rooms
INSERT INTO room (room_id, room_number, room_type, price_per_night, capacity, status) VALUES
(1, '101', 'Single', 1500.00, 1, 'Available'),
(2, '102', 'Single', 1500.00, 1, 'Available'),
(3, '103', 'Double', 2500.00, 2, 'Occupied'),
(4, '201', 'Deluxe', 4500.00, 2, 'Occupied'),
(5, '301', 'Suite', 8500.00, 4, 'Available');

-- 3. Insert Bookings
INSERT INTO booking (booking_id, guest_id, room_id, check_in_date, check_out_date, number_of_guests, booking_status) VALUES
(1, 1, 1, '2026-01-10', '2026-01-12', 1, 'Checked-Out'),
(2, 2, 3, '2026-09-05', '2026-09-10', 2, 'Checked-In'),
(3, 3, 4, '2026-09-04', '2026-09-08', 2, 'Checked-In'),
(4, 1, 5, '2026-10-01', '2026-10-05', 2, 'Reserved'),
(5, 4, 2, '2026-05-01', '2026-05-04', 1, 'Checked-Out');

-- 4. Insert Payments
INSERT INTO payment (payment_id, booking_id, payment_date, amount, payment_method, payment_status) VALUES
(1, 1, '2026-01-05 10:35:00', 3000.00, 'UPI', 'Paid'),
(2, 2, '2026-09-01 09:05:00', 5000.00, 'UPI', 'Paid'),
(3, 3, '2026-09-02 16:25:00', 9000.00, 'Card', 'Paid'),
(4, 4, '2026-09-15 11:00:00', 17000.00, 'Online', 'Paid'),
(5, 5, '2026-04-25 12:15:00', 4500.00, 'Cash', 'Paid');

SELECT 'Sample records inserted successfully.' AS Status;
