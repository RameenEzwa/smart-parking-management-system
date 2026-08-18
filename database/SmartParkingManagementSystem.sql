CREATE DATABASE SmartParkingManagementSystem;

USE SmartParkingManagementSystem;

CREATE TABLE VEHICLE_TYPES (
    vehicle_type_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE USERS (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    profile_pic_url VARCHAR(255),
    reset_pwd_token VARCHAR(255)
);

CREATE TABLE ADMINS (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    notification_email VARCHAR(100) UNIQUE,
    security_level INT DEFAULT 1,
    reset_pwd_token VARCHAR(255)
);

CREATE TABLE PARKING_ZONES (
    zone_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    location VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE PASS_PLANS (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    duration_days INT CHECK (duration_days > 0),
    price DECIMAL(10,2) CHECK (price >= 0),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE USER_VEHICLES (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    vehicle_type_id INT NOT NULL,
    vehicle_number VARCHAR(20) UNIQUE NOT NULL,
    model VARCHAR(100) NOT NULL,
    color VARCHAR(50),
    is_default BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (user_id)
        REFERENCES USERS(user_id),

    FOREIGN KEY (vehicle_type_id)
        REFERENCES VEHICLE_TYPES(vehicle_type_id)
);

CREATE TABLE PARKING_SLOTS (
    slot_id INT AUTO_INCREMENT PRIMARY KEY,
    zone_id INT NOT NULL,
    slot_number VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'Available',
    is_active BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (zone_id)
        REFERENCES PARKING_ZONES(zone_id)
);

CREATE TABLE BOOKINGS (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    slot_id INT NOT NULL,

    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME,

    duration_hours DECIMAL(5,2)
        CHECK (duration_hours >= 0),

    hourly_rate DECIMAL(10,2)
        CHECK (hourly_rate >= 0),

    total_payment DECIMAL(10,2)
        CHECK (total_payment >= 0),

    status VARCHAR(20) DEFAULT 'Active',

    FOREIGN KEY (user_id)
        REFERENCES USERS(user_id),

    FOREIGN KEY (vehicle_id)
        REFERENCES USER_VEHICLES(vehicle_id),

    FOREIGN KEY (slot_id)
        REFERENCES PARKING_SLOTS(slot_id)
);

CREATE TABLE PAYMENTS (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,

    booking_id INT UNIQUE NOT NULL,

    amount DECIMAL(10,2)
        CHECK (amount >= 0),

    status VARCHAR(20) DEFAULT 'Pending',

    paid_at DATETIME,

    transaction_reference VARCHAR(100) UNIQUE,

    FOREIGN KEY (booking_id)
        REFERENCES BOOKINGS(booking_id)
);

CREATE TABLE USER_PASSES (
    pass_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    plan_id INT NOT NULL,

    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    status VARCHAR(20) DEFAULT 'Active',

    FOREIGN KEY (user_id)
        REFERENCES USERS(user_id),

    FOREIGN KEY (vehicle_id)
        REFERENCES USER_VEHICLES(vehicle_id),

    FOREIGN KEY (plan_id)
        REFERENCES PASS_PLANS(plan_id)
);

CREATE TABLE PARKING_REVIEWS (
    review_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,
    zone_id INT NOT NULL,

    booking_id INT UNIQUE NOT NULL,

    rating INT CHECK (rating BETWEEN 1 AND 5),

    comment TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES USERS(user_id),

    FOREIGN KEY (zone_id)
        REFERENCES PARKING_ZONES(zone_id),

    FOREIGN KEY (booking_id)
        REFERENCES BOOKINGS(booking_id)
);

CREATE TABLE DYNAMIC_PRICING_RULES (
    pricing_rule_id INT AUTO_INCREMENT PRIMARY KEY,

    zone_id INT NOT NULL,

    name VARCHAR(100) NOT NULL,
    day_type VARCHAR(30) NOT NULL,

    start_time TIME NOT NULL,
    end_time TIME NOT NULL,

    hourly_rate DECIMAL(10,2)
        CHECK (hourly_rate >= 0),

    is_active BOOLEAN DEFAULT TRUE,

    category VARCHAR(50) NOT NULL,

    FOREIGN KEY (zone_id)
        REFERENCES PARKING_ZONES(zone_id)
);


INSERT INTO VEHICLE_TYPES (name) VALUES
('Car'),
('Bike'),
('SUV'),
('Electric Car'),
('Van'),
('Truck'),
('Mini Bus'),
('Bus'),
('Rickshaw'),
('Motorcycle');

INSERT INTO USERS
(full_name,email,password_hash,phone,profile_pic_url,reset_pwd_token)
VALUES
('Ali Raza','ali.raza@gmail.com','hash123','03011234567',NULL,NULL),
('Ahmed Khan','ahmed.khan@gmail.com','hash124','03121234567',NULL,NULL),
('Fatima Noor','fatima.noor@gmail.com','hash125','03211234567',NULL,NULL),
('Ayesha Malik','ayesha.malik@gmail.com','hash126','03331234567',NULL,NULL),
('Usman Tariq','usman.tariq@gmail.com','hash127','03451234567',NULL,NULL),
('Bilal Sheikh','bilal.sheikh@gmail.com','hash128','03001234567',NULL,NULL),
('Hamza Ali','hamza.ali@gmail.com','hash129','03111234567',NULL,NULL),
('Sara Ahmed','sara.ahmed@gmail.com','hash130','03221234567',NULL,NULL),
('Hassan Raza','hassan.raza@gmail.com','hash131','03341234567',NULL,NULL),
('Zain Malik','zain.malik@gmail.com','hash132','03461234567',NULL,NULL);

INSERT INTO ADMINS
(username,password_hash,role,notification_email,security_level)
VALUES
('admin1','adminhash1','Super Admin','admin1@parking.pk',5),
('admin2','adminhash2','Zone Manager','admin2@parking.pk',4),
('admin3','adminhash3','Operations Manager','admin3@parking.pk',3),
('admin4','adminhash4','Zone Supervisor','admin4@parking.pk',3),
('admin5','adminhash5','Support Admin','admin5@parking.pk',2),
('admin6','adminhash6','Finance Manager','admin6@parking.pk',4),
('admin7','adminhash7','Security Admin','admin7@parking.pk',3),
('admin8','adminhash8','System Operator','admin8@parking.pk',2),
('admin9','adminhash9','Regional Manager','admin9@parking.pk',5),
('admin10','adminhash10','Audit Admin','admin10@parking.pk',4);

INSERT INTO PARKING_ZONES
(name,location,is_active)
VALUES
('Zone A','DHA Lahore',TRUE),
('Zone B','Johar Town Lahore',TRUE),
('Zone C','Gulberg Lahore',TRUE),
('Zone D','Blue Area Islamabad',TRUE),
('Zone E','Clifton Karachi',FALSE),
('Zone F','Bahria Town Lahore',TRUE),
('Zone G','Model Town Lahore',TRUE),
('Zone H','F-10 Islamabad',TRUE),
('Zone I','Saddar Rawalpindi',TRUE),
('Zone J','Gulshan-e-Iqbal Karachi',TRUE);

INSERT INTO PASS_PLANS
(name,duration_days,price,is_active)
VALUES
('Weekly Pass',7,1500,TRUE),
('Monthly Pass',30,5000,TRUE),
('Quarterly Pass',90,13000,TRUE),
('Annual Pass',365,45000,TRUE),
('Daily Pass',1,300,TRUE),
('Weekend Pass',2,700,TRUE),
('Bi-Weekly Pass',14,2800,TRUE),
('Half-Year Pass',180,25000,TRUE),
('Hourly Pass',1,100,TRUE),
('Student Monthly Pass',30,4000,TRUE);

INSERT INTO USER_VEHICLES
(user_id,vehicle_type_id,vehicle_number,model,color,is_default)
VALUES
(1,1,'LEA-1234','Toyota Corolla','White',TRUE),
(2,3,'LZT-5678','Toyota Fortuner','Black',TRUE),
(3,2,'LHR-1122','Honda CD70','Red',TRUE),
(4,1,'ICT-4455','Honda Civic','Silver',TRUE),
(5,4,'KHI-7788','MG ZS EV','Blue',TRUE),
(6,1,'LHE-9012','Suzuki Alto','White',TRUE),
(7,3,'LHR-3456','Kia Sportage','Grey',TRUE),
(8,2,'KHI-8899','Yamaha YBR','Black',TRUE),
(9,1,'ICT-1111','Toyota Yaris','Silver',TRUE),
(10,1,'LEB-2222','Honda City','White',TRUE),
(1,2,'LEA-9999','Honda 125','Black',FALSE),
(2,1,'LZT-8888','Honda City','Grey',FALSE);

INSERT INTO PARKING_SLOTS
(zone_id,slot_number,status,is_active)
VALUES
(1,'A-01','Occupied',TRUE),
(1,'A-02','Available',TRUE),
(1,'A-03','Available',TRUE),
(1,'A-04','Occupied',TRUE),

(2,'B-01','Available',TRUE),
(2,'B-02','Occupied',TRUE),
(2,'B-03','Available',TRUE),
(2,'B-04','Available',TRUE),

(3,'C-01','Occupied',TRUE),
(3,'C-02','Available',TRUE),
(3,'C-03','Available',TRUE),

(4,'D-01','Occupied',TRUE),
(4,'D-02','Available',TRUE),
(4,'D-03','Occupied',TRUE),

(5,'E-01','Unavailable',FALSE),
(5,'E-02','Unavailable',FALSE);

INSERT INTO BOOKINGS
(user_id,vehicle_id,slot_id,check_in_time,check_out_time,duration_hours,hourly_rate,total_payment,status)
VALUES
(1,1,1,'2025-06-01 08:00:00','2025-06-01 12:00:00',4,150,600,'Completed'),
(2,2,4,'2025-06-01 09:00:00','2025-06-01 14:00:00',5,200,1000,'Completed'),
(3,3,6,'2025-06-02 10:00:00','2025-06-02 13:00:00',3,100,300,'Completed'),
(4,4,9,'2025-06-02 11:00:00','2025-06-02 15:00:00',4,180,720,'Completed'),
(5,5,12,'2025-06-03 08:30:00','2025-06-03 14:30:00',6,250,1500,'Completed'),
(6,6,14,'2025-06-03 09:00:00','2025-06-03 11:00:00',2,150,300,'Completed'),
(7,7,1,'2025-06-04 07:00:00','2025-06-04 12:00:00',5,180,900,'Completed'),
(8,8,6,'2025-06-04 13:00:00','2025-06-04 16:00:00',3,100,300,'Completed'),
(9,9,9,'2025-06-05 08:00:00','2025-06-05 10:00:00',2,180,360,'Completed'),
(10,10,12,'2025-06-05 12:00:00','2025-06-05 18:00:00',6,250,1500,'Completed'),
(1,11,2,'2025-06-06 09:00:00',NULL,2,150,300,'Active'),
(2,12,5,'2025-06-06 10:00:00',NULL,1,180,180,'Active');

INSERT INTO PAYMENTS
(booking_id,amount,status,paid_at,transaction_reference)
VALUES
(1,600,'Paid','2025-06-01 12:05:00','TXN1001'),
(2,1000,'Paid','2025-06-01 14:05:00','TXN1002'),
(3,300,'Paid','2025-06-02 13:05:00','TXN1003'),
(4,720,'Paid','2025-06-02 15:05:00','TXN1004'),
(5,1500,'Paid','2025-06-03 14:35:00','TXN1005'),
(6,300,'Paid','2025-06-03 11:05:00','TXN1006'),
(7,900,'Paid','2025-06-04 12:05:00','TXN1007'),
(8,300,'Paid','2025-06-04 16:05:00','TXN1008'),
(9,360,'Paid','2025-06-05 10:05:00','TXN1009'),
(10,1500,'Paid','2025-06-05 18:05:00','TXN1010'),
(11,300,'Pending',NULL,'TXN1011'),
(12,180,'Pending',NULL,'TXN1012');

INSERT INTO USER_PASSES
(user_id,vehicle_id,plan_id,start_date,end_date,status)
VALUES
(1,1,2,'2025-01-01','2025-01-31','Expired'),
(2,2,2,'2025-05-01','2025-05-31','Expired'),
(3,3,1,'2025-06-01','2025-06-08','Active'),
(4,4,3,'2025-04-01','2025-06-30','Active'),
(5,5,4,'2025-01-01','2025-12-31','Active'),
(6,6,1,'2025-06-01','2025-06-08','Active'),
(7,7,2,'2025-06-01','2025-06-30','Active'),
(8,8,1,'2025-06-01','2025-06-08','Active'),
(9,9,2,'2025-06-01','2025-06-30','Active'),
(10,10,1,'2025-06-01','2025-06-08','Active');

INSERT INTO PARKING_REVIEWS
(user_id,zone_id,booking_id,rating,comment)
VALUES
(1,1,1,5,'Excellent parking experience'),
(2,1,2,4,'Good security and clean area'),
(3,2,3,5,'Easy booking process'),
(4,3,4,4,'Well managed parking zone'),
(5,4,5,5,'Best parking facility'),
(6,4,6,3,'Average experience'),
(7,1,7,5,'Highly recommended'),
(8,2,8,4,'Smooth entry and exit'),
(9,3,9,4,'Good parking management'),
(10,4,10,5,'Very convenient location');

INSERT INTO DYNAMIC_PRICING_RULES
(zone_id,name,day_type,start_time,end_time,hourly_rate,is_active,category)
VALUES
(1,'Weekday Morning','Weekday','08:00:00','12:00:00',150,TRUE,'Standard'),
(1,'Weekday Evening','Weekday','17:00:00','22:00:00',250,TRUE,'Peak'),

(2,'Weekend Rate','Weekend','08:00:00','22:00:00',220,TRUE,'Weekend'),

(3,'Business Hours','Weekday','09:00:00','17:00:00',180,TRUE,'Business'),

(4,'Premium Zone Peak','Weekday','08:00:00','20:00:00',300,TRUE,'Premium'),

(4,'Night Discount','Daily','22:00:00','06:00:00',120,TRUE,'Discount'),

(5,'Inactive Zone Rule','Daily','08:00:00','22:00:00',100,FALSE,'Inactive'),

(2,'Early Bird Discount','Weekday','06:00:00','08:00:00',100,TRUE,'Discount'),

(3,'Weekend Premium','Weekend','10:00:00','20:00:00',250,TRUE,'Premium'),

(5,'Holiday Special','Holiday','08:00:00','22:00:00',180,TRUE,'Special');


SHOW TABLES;

SELECT * FROM USERS;

SELECT * FROM PASS_PLANS;

SELECT * FROM USER_VEHICLES;

SELECT * FROM PARKING_SLOTS;

SELECT * FROM PARKING_ZONES;

SELECT * FROM BOOKINGS;

SELECT * FROM PAYMENTS;

SELECT * FROM PARKING_REVIEWS;

SELECT * FROM ADMINS;

SELECT * FROM DYNAMIC_PRICING_RULES;

SELECT * FROM VEHICLE_TYPES;

SELECT * FROM USER_PASSES;

-- FILTERING QUERIES

SELECT *
FROM BOOKINGS
WHERE status = 'Active';

SELECT *
FROM PAYMENTS
WHERE amount > 500;

-- AGGREGATION QUERIES

SELECT COUNT(*) AS TotalUsers
FROM USERS;

SELECT SUM(amount) AS TotalRevenue
FROM PAYMENTS;

SELECT AVG(rating) AS AverageRating
FROM PARKING_REVIEWS;

SELECT MAX(total_payment) AS HighestPayment
FROM BOOKINGS;

-- GROUP BY / HAVING

SELECT status,
       COUNT(*) AS TotalBookings
FROM BOOKINGS
GROUP BY status;

SELECT zone_id,
       COUNT(*) AS TotalSlots
FROM PARKING_SLOTS
GROUP BY zone_id
HAVING COUNT(*) > 2;

-- JOIN QUERIES

SELECT u.full_name,
       uv.vehicle_number
FROM USERS u
JOIN USER_VEHICLES uv
ON u.user_id = uv.user_id;

SELECT u.full_name,
       b.booking_id,
       p.amount
FROM USERS u
JOIN BOOKINGS b
ON u.user_id = b.user_id
JOIN PAYMENTS p
ON b.booking_id = p.booking_id;

-- SUBQUERIES

SELECT *
FROM BOOKINGS
WHERE total_payment >
(
    SELECT AVG(total_payment)
    FROM BOOKINGS
);
