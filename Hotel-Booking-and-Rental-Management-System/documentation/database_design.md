# Database Design Document

## 1. Database Name
```text
hotel_booking_rental_management
```

---

## 2. Table Overview
The database consists of **exactly 4 core tables** normalized to 3rd Normal Form (3NF):

1. **`guest`**: Stores personal profiles, contact info, and official identification records for hotel guests.
2. **`room`**: Contains room inventory details, category classifications, nightly rates, capacity limits, and current availability status.
3. **`booking`**: Tracks reservation records linking guests to specific rooms, check-in/out dates, guest counts, and booking lifecycle status.
4. **`payment`**: Logs financial transactions associated with reservations, including payment dates, amounts, channels, and payment status.

---

## 3. Data Dictionary (Attributes & Schemas)

### Table 1: `guest`
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `guest_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique identifier for each guest profile. |
| `guest_name` | VARCHAR(100) | NOT NULL | Full name of the guest. |
| `phone` | VARCHAR(15) | NOT NULL, UNIQUE | Primary contact phone number. |
| `email` | VARCHAR(100) | NOT NULL, UNIQUE | Primary email address. |
| `address` | VARCHAR(255) | NOT NULL | Residential / mailing address. |
| `identification_type` | VARCHAR(50) | NOT NULL, CHECK | Type of ID proof ('Passport', 'Aadhaar', 'Driving License', 'National ID', 'Voter ID'). |
| `identification_number` | VARCHAR(50) | NOT NULL, UNIQUE | Official ID document number. |

### Table 2: `room`
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `room_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique internal room ID. |
| `room_number` | VARCHAR(10) | NOT NULL, UNIQUE | Physical door room number (e.g., '101', '201'). |
| `room_type` | VARCHAR(20) | NOT NULL, CHECK | Category ('Single', 'Double', 'Deluxe', 'Suite'). |
| `price_per_night` | DECIMAL(10, 2) | NOT NULL, CHECK (>0) | Nightly rental rate in currency units. |
| `capacity` | INT | NOT NULL, CHECK (>0) | Maximum allowed guest count for the room. |
| `status` | VARCHAR(20) | NOT NULL, DEFAULT 'Available', CHECK | Live status ('Available', 'Occupied', 'Maintenance'). |

### Table 3: `booking`
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `booking_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique reservation ID. |
| `guest_id` | INT | FOREIGN KEY, NOT NULL | References `guest(guest_id)`. |
| `room_id` | INT | FOREIGN KEY, NOT NULL | References `room(room_id)`. |
| `check_in_date` | DATE | NOT NULL | Scheduled check-in date. |
| `check_out_date` | DATE | NOT NULL, CHECK (> check_in_date) | Scheduled check-out date. |
| `number_of_guests` | INT | NOT NULL, CHECK (>0) | Number of occupants for this stay. |
| `booking_date` | TIMESTAMP | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Date and time reservation was placed. |
| `booking_status` | VARCHAR(20) | NOT NULL, DEFAULT 'Reserved', CHECK | Status ('Reserved', 'Checked-In', 'Checked-Out', 'Cancelled'). |

### Table 4: `payment`
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `payment_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique transaction ID. |
| `booking_id` | INT | FOREIGN KEY, NOT NULL | References `booking(booking_id)`. |
| `payment_date` | DATETIME | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Timestamp when payment was recorded. |
| `amount` | DECIMAL(10, 2) | NOT NULL, CHECK (>0) | Transaction monetary amount. |
| `payment_method` | VARCHAR(20) | NOT NULL, CHECK | Payment channel ('Cash', 'Card', 'UPI', 'Online'). |
| `payment_status` | VARCHAR(20) | NOT NULL, DEFAULT 'Paid', CHECK | Transaction status ('Paid', 'Pending', 'Failed', 'Refunded'). |

---

## 4. Primary Keys
- **`guest.guest_id`**: Uniquely identifies each guest. Surrogate key using `AUTO_INCREMENT`.
- **`room.room_id`**: Uniquely identifies each room unit. Surrogate key using `AUTO_INCREMENT`.
- **`booking.booking_id`**: Uniquely identifies each reservation record. Surrogate key using `AUTO_INCREMENT`.
- **`payment.payment_id`**: Uniquely identifies each financial transaction. Surrogate key using `AUTO_INCREMENT`.

---

## 5. Foreign Keys & Cascading Rules

1. **`booking.guest_id` → `guest.guest_id`**
   - **Constraint Name**: `fk_booking_guest`
   - **On Delete**: `CASCADE` (If a guest profile is deleted, their booking history is removed).
   - **On Update**: `CASCADE` (If a guest ID is modified, linked bookings update automatically).

2. **`booking.room_id` → `room.room_id`**
   - **Constraint Name**: `fk_booking_room`
   - **On Delete**: `CASCADE` (If a room is deleted from inventory, associated reservations are removed).
   - **On Update**: `CASCADE` (If a room ID changes, linked bookings update automatically).

3. **`payment.booking_id` → `booking.booking_id`**
   - **Constraint Name**: `fk_payment_booking`
   - **On Delete**: `CASCADE` (If a booking is deleted, associated transaction records are removed).
   - **On Update**: `CASCADE` (If a booking ID changes, linked payments update automatically).

---

## 6. Relationships & Cardinalities

```text
  [ Guest ] ─── (1 : N) ───> [ Booking ] <─── (N : 1) ─── [ Room ]
                                │
                             (1 : N)
                                ▼
                           [ Payment ]
```

- **Guest to Booking (1 : Many)**: One guest can place multiple bookings over time; each booking belongs strictly to one guest.
- **Room to Booking (1 : Many)**: One room can be booked multiple times across non-overlapping date ranges; each booking references exactly one room.
- **Booking to Payment (1 : Many)**: One booking can have multiple payment records (e.g. advance deposit, final settlement, or retry on failed payment); each payment belongs to one booking.

---

## 7. Normalization Analysis

### First Normal Form (1NF)
- All table attributes contain atomic (indivisible) values.
- No repeating groups or arrays exist within any table.
- Each table has a designated primary key (`guest_id`, `room_id`, `booking_id`, `payment_id`).

### Second Normal Form (2NF)
- All tables satisfy 1NF.
- Every non-key attribute is fully functionally dependent on the entire primary key.
- Since all primary keys are single-attribute surrogate keys (`INT AUTO_INCREMENT`), partial dependencies are mathematically impossible.

### Third Normal Form (3NF)
- All tables satisfy 2NF.
- No transitive dependencies exist. Non-key columns do not depend on other non-key columns.
- For example, room prices and room capacities depend strictly on `room_id` (and room properties), not on booking records. Payment amounts depend on `payment_id` and `booking_id`.

---

## 8. Database Constraints Summary

- **PRIMARY KEY**: Guarantees entity uniqueness and creates clustered B-Tree indexes.
- **FOREIGN KEY**: Enforces referential integrity across related tables.
- **NOT NULL**: Prevents essential columns (e.g. dates, names, amounts) from storing missing values.
- **UNIQUE**: Prevents duplicate entries for phone numbers, email addresses, identification numbers, and room numbers.
- **CHECK Constraints**:
  - `chk_guest_id_type`: Restricts ID types to official documents.
  - `chk_room_type`: Restricts categories to ('Single', 'Double', 'Deluxe', 'Suite').
  - `chk_room_status`: Restricts statuses to ('Available', 'Occupied', 'Maintenance').
  - `chk_room_price` & `chk_room_capacity`: Enforces positive values (`> 0`).
  - `chk_booking_dates`: Ensures `check_out_date > check_in_date`.
  - `chk_booking_status`: Restricts status values ('Reserved', 'Checked-In', 'Checked-Out', 'Cancelled').
  - `chk_payment_method` & `chk_payment_status`: Restricts payment modes and states.
- **DEFAULT**: Sets sensible default values (e.g. room status `'Available'`, booking status `'Reserved'`, timestamps `CURRENT_TIMESTAMP`).
