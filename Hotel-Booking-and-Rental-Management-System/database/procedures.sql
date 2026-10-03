-- ============================================================================
-- Script Name: procedures.sql
-- Project: Hotel Booking and Rental Management System
-- Description: Simple, clean stored procedures for hotel operational workflows
--              (book room, check-in, check-out, payment, cancellation).
-- Engine / SQL Dialect: MySQL 8.0+
-- ============================================================================

USE hotel_booking_rental_management;

-- Drop existing procedures if re-running
DROP PROCEDURE IF EXISTS book_room;
DROP PROCEDURE IF EXISTS check_in_guest;
DROP PROCEDURE IF EXISTS check_out_guest;
DROP PROCEDURE IF EXISTS make_payment;
DROP PROCEDURE IF EXISTS cancel_booking;

DELIMITER //

-- ============================================================================
-- PROCEDURE 1: book_room
-- Purpose: Create a new room booking for a guest.
-- ============================================================================
CREATE PROCEDURE book_room(
    IN p_guest_id INT,
    IN p_room_id INT,
    IN p_check_in_date DATE,
    IN p_check_out_date DATE,
    IN p_number_of_guests INT
)
BEGIN
    -- Create booking record
    INSERT INTO booking (guest_id, room_id, check_in_date, check_out_date, number_of_guests, booking_status)
    VALUES (p_guest_id, p_room_id, p_check_in_date, p_check_out_date, p_number_of_guests, 'Reserved');

    SELECT 'Booking created successfully.' AS Message;
END //

-- ============================================================================
-- PROCEDURE 2: check_in_guest
-- Purpose: Mark booking as Checked-In and set room status to Occupied.
-- ============================================================================
CREATE PROCEDURE check_in_guest(
    IN p_booking_id INT
)
BEGIN
    -- Update booking status to Checked-In
    UPDATE booking 
    SET booking_status = 'Checked-In' 
    WHERE booking_id = p_booking_id;

    -- Update room status to Occupied
    UPDATE room 
    SET status = 'Occupied' 
    WHERE room_id = (SELECT room_id FROM booking WHERE booking_id = p_booking_id);

    SELECT 'Guest checked in successfully.' AS Message;
END //

-- ============================================================================
-- PROCEDURE 3: check_out_guest
-- Purpose: Mark booking as Checked-Out and release room to Available.
-- ============================================================================
CREATE PROCEDURE check_out_guest(
    IN p_booking_id INT
)
BEGIN
    -- Update booking status to Checked-Out
    UPDATE booking 
    SET booking_status = 'Checked-Out' 
    WHERE booking_id = p_booking_id;

    -- Update room status back to Available
    UPDATE room 
    SET status = 'Available' 
    WHERE room_id = (SELECT room_id FROM booking WHERE booking_id = p_booking_id);

    SELECT 'Guest checked out successfully.' AS Message;
END //

-- ============================================================================
-- PROCEDURE 4: make_payment
-- Purpose: Record a payment transaction for a booking.
-- ============================================================================
CREATE PROCEDURE make_payment(
    IN p_booking_id INT,
    IN p_amount DECIMAL(10, 2),
    IN p_payment_method VARCHAR(20)
)
BEGIN
    -- Insert payment record
    INSERT INTO payment (booking_id, payment_date, amount, payment_method, payment_status)
    VALUES (p_booking_id, NOW(), p_amount, p_payment_method, 'Paid');

    SELECT 'Payment recorded successfully.' AS Message;
END //

-- ============================================================================
-- PROCEDURE 5: cancel_booking
-- Purpose: Cancel a booking and mark room as Available.
-- ============================================================================
CREATE PROCEDURE cancel_booking(
    IN p_booking_id INT
)
BEGIN
    -- Update booking status to Cancelled
    UPDATE booking 
    SET booking_status = 'Cancelled' 
    WHERE booking_id = p_booking_id;

    -- Make room available
    UPDATE room 
    SET status = 'Available' 
    WHERE room_id = (SELECT room_id FROM booking WHERE booking_id = p_booking_id);

    SELECT 'Booking cancelled successfully.' AS Message;
END //

DELIMITER ;

-- Confirmation output
SELECT 'All stored procedures updated successfully without IF conditions.' AS Status;
