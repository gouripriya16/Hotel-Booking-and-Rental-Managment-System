-- ============================================================================
-- Script Name: window_functions.sql
-- Project: Hotel Booking and Rental Management System
-- Description: Simple window functions for ranking rooms and payments.
-- Engine / SQL Dialect: MySQL 8.0+
-- ============================================================================

USE hotel_booking_rental_management;

-- 1. Rank rooms by price (highest to lowest)
SELECT 
    room_number,
    room_type,
    price_per_night,
    DENSE_RANK() OVER (ORDER BY price_per_night DESC) AS price_rank
FROM room;

-- 2. Rank guests by total spent money
SELECT 
    g.guest_name,
    SUM(p.amount) AS total_spent,
    DENSE_RANK() OVER (ORDER BY SUM(p.amount) DESC) AS spending_rank
FROM guest g
JOIN booking b ON g.guest_id = b.guest_id
JOIN payment p ON b.booking_id = p.booking_id
WHERE p.payment_status = 'Paid'
GROUP BY g.guest_id, g.guest_name;

-- 3. Calculate running total revenue
SELECT 
    payment_id,
    payment_date,
    amount,
    SUM(amount) OVER (ORDER BY payment_date) AS running_total_revenue
FROM payment
WHERE payment_status = 'Paid';
