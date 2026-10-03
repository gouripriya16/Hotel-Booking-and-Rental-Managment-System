# Project Requirements Document

## Project Title
**Hotel Booking and Rental Management System**

---

## Problem Statement
Traditional and semi-automated hotel management practices relying on manual ledger books, spreadsheets, or disconnected software tools introduce significant operational bottlenecks:

1. **Overbooking & Allocation Conflicts**: Manual tracking often leads to double-booking rooms or assigning rooms currently under maintenance.
2. **Data Inconsistency & Inaccuracy**: Guest contact details, identification proof records, and room rates recorded manually are prone to human entry errors and duplication.
3. **Financial Leakage & Tracking Errors**: Cash, card, and digital UPI payments logged on paper invoices lead to unverified pending balances, untracked refunds, and revenue calculation discrepancies.
4. **Lack of Operational Real-Time Visibility**: Hotel desk managers struggle to determine real-time room availability, active guest check-ins, or pending check-outs instantly.
5. **Absence of Analytical Reporting**: Assessing business performance (e.g., top revenue-generating room types, repeat guest analysis, monthly revenue growth) requires tedious manual compilation.

---

## Proposed Solution
The **Hotel Booking and Rental Management System** provides a centralized, relational MySQL database architecture engineered specifically to streamline hotel inventory, reservations, guest tracking, and financial transactions. 

Key advantages of the database solution include:
- **Relational Integrity**: Enforces primary and foreign key constraints between Guests, Rooms, Bookings, and Payments, eliminating orphan records and redundant data entry.
- **Automated Validation**: Stored procedures validate check-in/check-out dates, room capacity limits, and current availability status prior to confirming reservations.
- **Real-Time Operational Views**: Pre-compiled database views offer instant visibility into available rooms, guest reservation itineraries, payment audits, and guest spending statistics.
- **Advanced Revenue Reporting**: Analytical queries powered by MySQL window functions provide deep business intelligence regarding room popularity, pricing distributions, and cumulative earnings.

---

## Objectives
- **Guest Management**: Maintain complete profiles of guests including contact channels, addresses, and official identification records (Passport, Aadhaar, Driving License).
- **Room Inventory Management**: Categorize rooms by type (Single, Double, Deluxe, Suite), set nightly pricing, define occupancy capacity, and track live status (Available, Occupied, Maintenance).
- **Booking Lifecycle Control**: Track reservations through formal lifecycle states: `Reserved` → `Checked-In` → `Checked-Out` or `Cancelled`.
- **Payment & Transaction Audit**: Multi-channel payment tracking (Cash, Card, UPI, Online) supporting statuses (`Paid`, `Pending`, `Failed`, `Refunded`).
- **Data Integrity & Consistency**: Enforce strict domain rules using `NOT NULL`, `UNIQUE`, and `CHECK` constraints alongside foreign keys.
- **Reporting & Business Intelligence**: Deliver ready-to-run reports for room utilization, guest spending patterns, and financial analytics.

---

## Functional Requirements

### 1. Guest Operations
- System must store unique guest profiles with phone number, email, and identification numbers.
- System must allow searching for guests by name, contact details, or ID proof.
- System must identify repeat guests versus single-stay visitors.

### 2. Room Inventory Operations
- System must manage room details including unique room numbers, category type, capacity, and nightly rates.
- System must prevent booking of rooms marked under `Maintenance`.
- System must allow instant filtering of available rooms.

### 3. Booking & Reservation Operations
- System must create bookings by linking valid guest and room records.
- System must enforce logical stay rules: `check_out_date` must be after `check_in_date`.
- System must restrict booking guest count so it does not exceed room capacity.
- System must support seamless check-in and check-out workflows that update room availability automatically.
- System must support booking cancellations and free assigned rooms immediately.

### 4. Payment & Revenue Operations
- System must record single or multiple payment transactions per booking.
- System must handle multiple payment channels: `Cash`, `Card`, `UPI`, and `Online`.
- System must record payment lifecycle states: `Paid`, `Pending`, `Failed`, and `Refunded`.
- System must aggregate total spending per guest and compute cumulative daily hotel revenue.

---

## Non-Functional Requirements

### 1. Data Integrity & Consistency
- Relational integrity guaranteed via foreign key relationships with cascading rules (`ON DELETE CASCADE ON UPDATE CASCADE`).
- Domain constraints enforced via MySQL `CHECK` conditions on pricing, guest counts, and status values.

### 2. Reliability & Safety
- Stored procedures use atomic SQL validation checks with explicit error signals (`SIGNAL SQLSTATE '45000'`) to prevent invalid transaction commits.

### 3. Security & Compliance
- Sensitive guest identification numbers and contact details are stored under restricted access control within MySQL.

### 4. Maintainability & Code Quality
- Modular SQL organization across separate files (`create_tables.sql`, `views.sql`, `procedures.sql`, `queries.sql`).
- Absence of application code or complex triggers ensures lightweight database portability.

### 5. Performance & Scalability
- B-Tree indexes on primary keys, foreign keys, and unique columns enable fast lookups and sub-second query execution.

---

## Technology Stack

```text
Database Engine : MySQL 8.0+
Query Language  : Structured Query Language (SQL)
Project Type    : Relational Database Management System (RDBMS) B.Tech Project
Architecture    : Pure SQL (Database Schema, Views, Procedures, Window Functions, Queries)
```
