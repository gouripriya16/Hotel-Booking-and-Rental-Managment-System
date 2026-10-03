-- ============================================================================
-- Script Name: queries.sql
-- Project: Hotel Booking and Rental Management System
-- Description: Simple and easy-to-understand SQL queries for hotel management.
-- Engine / SQL Dialect: MySQL 8.0+
-- ============================================================================

USE hotel_booking_rental_management;

-- ----------------------------------------------------------------------------
-- 1. Find all available rooms
-- ----------------------------------------------------------------------------
SELECT room_number, room_type, price_per_night 
FROM room 
WHERE status = 'Available';

-- ----------------------------------------------------------------------------
-- 2. Find the most expensive room
-- ----------------------------------------------------------------------------
SELECT room_number, room_type, price_per_night 
FROM room 
ORDER BY price_per_night DESC 
LIMIT 1;

-- ----------------------------------------------------------------------------
-- 3. Show guest names along with their booking dates
-- ----------------------------------------------------------------------------
SELECT 
    g.guest_name, 
    g.phone, 
    b.booking_id, 
    b.check_in_date, 
    b.check_out_date, 
    b.booking_status
FROM guest g
JOIN booking b ON g.guest_id = b.guest_id;

-- ----------------------------------------------------------------------------
-- 4. Count total bookings per room type
-- ----------------------------------------------------------------------------
SELECT 
    r.room_type, 
    COUNT(b.booking_id) AS total_bookings
FROM room r
JOIN booking b ON r.room_id = b.room_id
GROUP BY r.room_type;

-- ----------------------------------------------------------------------------
-- 5. Calculate total revenue generated from paid payments
-- ----------------------------------------------------------------------------
SELECT SUM(amount) AS total_revenue 
FROM payment 
WHERE payment_status = 'Paid';

-- ----------------------------------------------------------------------------
-- 6. Find repeat guests who booked more than once
-- ----------------------------------------------------------------------------
SELECT 
    g.guest_name, 
    g.phone, 
    COUNT(b.booking_id) AS total_bookings
FROM guest g
JOIN booking b ON g.guest_id = b.guest_id
GROUP BY g.guest_id, g.guest_name, g.phone
HAVING COUNT(b.booking_id) > 1;

-- ----------------------------------------------------------------------------
-- 7. Show payment details for each guest booking
-- ----------------------------------------------------------------------------
SELECT 
    g.guest_name, 
    b.booking_id, 
    p.amount, 
    p.payment_method, 
    p.payment_status
FROM guest g
JOIN booking b ON g.guest_id = b.guest_id
JOIN payment p ON b.booking_id = p.booking_id;

-- ----------------------------------------------------------------------------
-- 8. Find rooms priced above average room price
-- ----------------------------------------------------------------------------
SELECT room_number, room_type, price_per_night 
FROM room 
WHERE price_per_night > (SELECT AVG(price_per_night) FROM room);
