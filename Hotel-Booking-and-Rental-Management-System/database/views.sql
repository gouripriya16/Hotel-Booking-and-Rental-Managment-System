-- ============================================================================
-- Script Name: views.sql
-- Project: Hotel Booking and Rental Management System
-- Description: Simple database views for quick hotel reporting.
-- Engine / SQL Dialect: MySQL 8.0+
-- ============================================================================

USE hotel_booking_rental_management;

-- 1. View for all available rooms
CREATE OR REPLACE VIEW v_available_rooms AS
SELECT room_number, room_type, price_per_night, capacity
FROM room
WHERE status = 'Available';

-- 2. View for guest booking list
CREATE OR REPLACE VIEW v_guest_bookings AS
SELECT 
    g.guest_name,
    g.phone,
    r.room_number,
    r.room_type,
    b.check_in_date,
    b.check_out_date,
    b.booking_status
FROM booking b
JOIN guest g ON b.guest_id = g.guest_id
JOIN room r ON b.room_id = r.room_id;

-- 3. View for payment summary
CREATE OR REPLACE VIEW v_payment_summary AS
SELECT 
    b.booking_id,
    g.guest_name,
    p.amount,
    p.payment_method,
    p.payment_status
FROM payment p
JOIN booking b ON p.booking_id = b.booking_id
JOIN guest g ON b.guest_id = g.guest_id;

SELECT 'All views created successfully.' AS Status;
