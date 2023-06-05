--
-- For table `staff`
--

CREATE TABLE staff (
  staff_id NUMBER(11) CONSTRAINT staff_id_pk PRIMARY KEY,
  first_name VARCHAR2(20) NOT NULL,
  last_name VARCHAR2(20) NOT NULL,
  user_password VARCHAR2(15),
  addres VARCHAR2(30),
  birth_date DATE
);

--
-- Enter data in `staff`
--

INSERT INTO staff (staff_id, first_name, last_name, user_password, addres, birth_date) VALUES
(11, 'Müge', 'Yılmaz', '12345', 'İstiklal Mah. İstanbul/Kadıköy', TO_DATE('2001-07-01', 'YYYY-MM-DD')),
(13, 'Zeynep', 'Altunel', '78901', 'Çiçek Mah. İstanbul/Tuzla', TO_DATE('2001-02-23', 'YYYY-MM-DD')),
(17, 'Gülde', 'Turhanoğlu', '45678', 'Güldem Mah. İstanbul/Maltepe', TO_DATE('2001-08-26', 'YYYY-MM-DD')),
(19, 'Hasan', 'Temiz', '78905', 'Aydın Mah. İstanbul/Kadıköy', TO_DATE('2001-08-26', 'YYYY-MM-DD'));

-- ------------------------------------------------------

--
-- For table `customers`
--

CREATE TABLE customer (
  customer_id NUMBER(11) CONSTRAINT customer_id_pk PRIMARY KEY,
  first_name VARCHAR2(20) NOT NULL,
  last_name VARCHAR2(20) NOT NULL,
  user_password VARCHAR2(15),
  addres VARCHAR2(30),
  birth_date DATE
);

--
-- Enter data in `customers`
--

INSERT INTO customer (customer_id, first_name, last_name, user_password, addres, birth_date) VALUES
(21, 'Ali', 'Gül', '12345', 'Cumhuriyet Mah. İstanbul/Tuzla', TO_DATE('1992-03-11', 'YYYY-MM-DD')),
(22, 'Veli', 'Çiçek', '78901', 'Limon Mah. İstanbul/Pendik', TO_DATE('1997-07-27', 'YYYY-MM-DD')),
(23, 'Gamze', 'Çelik', '45678', 'Gül Mah. İstanbul/Pendik', TO_DATE('1996-11-14', 'YYYY-MM-DD')),
(24, 'Mehmet', 'Demir', '23457', 'Lale Mah. İstanbul/Kartal', TO_DATE('1996-11-14', 'YYYY-MM-DD'));

-- --------------------------------------------------------

--
-- For table `garments`
--

CREATE TABLE garments (
  garment_id NUMBER(11) CONSTRAINT garment_id_pk PRIMARY KEY,
  customer_id NUMBER(11),
  staff_id NUMBER(11),
  brought_date DATE,
  expected_return_date DATE,
  actual_return_date DATE,
  pick_up_date DATE,
  CONSTRAINT customer_id_fk FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  CONSTRAINT staff_id_fk FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

--
-- Enter data in `garments`
--

INSERT INTO garments (garment_id, customer_id, staff_id, brought_date, expected_return_date, actual_return_date, pick_up_date) VALUES
(1, 21, 11, TO_DATE('2023-05-25', 'YYYY-MM-DD'), TO_DATE('2023-05-29', 'YYYY-MM-DD'), TO_DATE('2023-05-27', 'YYYY-MM-DD'), TO_DATE('2023-05-30', 'YYYY-MM-DD')),
(2, 22, 13, TO_DATE('2023-04-01', 'YYYY-MM-DD'), TO_DATE('2023-04-04', 'YYYY-MM-DD'), TO_DATE('2023-04-03', 'YYYY-MM-DD'), TO_DATE('2023-04-05', 'YYYY-MM-DD')),
(3, 23, 17, TO_DATE('2023-05-22', 'YYYY-MM-DD'), TO_DATE('2023-05-25', 'YYYY-MM-DD'), NULL, NULL),
(4, 24, 19, TO_DATE('2023-05-20', 'YYYY-MM-DD'), TO_DATE('2023-05-23', 'YYYY-MM-DD'), NULL, NULL);

-- --------------------------------------------------------

--
-- For table `repairs`
--

CREATE TABLE repairs (
  repairs_id NUMBER(11) CONSTRAINT repair_id_pk PRIMARY KEY,
  garments_id NUMBER(11),
  repair_cost NUMBER(6,2),
  repair_details VARCHAR2(30),
  CONSTRAINT garment_id_fk FOREIGN KEY (garment_id) REFERENCES garments(garment_id)
);

--
-- Enter data in `repairs`
--

INSERT INTO repairs (repairs_id, garments_id, repair_cost, repair_details) VALUES
(32, 2, 100, 'Stitching repair'),
(33, 4, 50, 'Button replacement');

-- --------------------------------------------------------

--
-- For table `cleans`
--

CREATE TABLE cleans (
  cleans_id NUMBER(11) CONSTRAINT clean_id_pk PRIMARY KEY,
  garments_id NUMBER(11),
  clean_cost NUMBER(6,2),
  clean_details VARCHAR2(30),
  CONSTRAINT garment_id_fk FOREIGN KEY (garment_id) REFERENCES garments(garment_id)
);

--
-- Enter data in `cleans`
--

INSERT INTO cleans (cleans_id, garments_id, clean_cost, clean_details) VALUES
(41, 1, 200, 'Dry cleaning'),
(42, 3, 150, 'Laundry');

-- --------------------------------------------------------

--
-- For table `complaints`
--

CREATE TABLE complaints (
  complaint_id NUMBER(11) CONSTRAINT complaint_id_pk PRIMARY KEY,
  garments_id NUMBER(11),
  complaint_details VARCHAR2(30),
  CONSTRAINT garment_id_fk FOREIGN KEY (garment_id) REFERENCES garments(garment_id)
);

--
-- Enter data in `complaints`
--

INSERT INTO complaints (complaint_id, garments_id, complaint_details)
VALUES (1, 3, 'Color fading issue and torn fabric');

-- --------------------------------------------------------

--
-- For table `logistics`
--

CREATE TABLE logistics (
  logistic_id NUMBER(11) CONSTRAINT logistic_id_pk PRIMARY KEY,
  garments_id NUMBER(11),
  logistic_details VARCHAR2(30),
  CONSTRAINT garment_id_fk FOREIGN KEY (garment_id) REFERENCES garments(garment_id)
);

--
-- Enter data in `logistics`
--

INSERT INTO logistics (logistic_id, garments_id, logistic_details)
VALUES (1, 1, 'Shipment to customer');

-- --------------------------------------------------------

--
-- STATEMENTS
--

SELECT first_name, last_name
FROM staff
WHERE staff_id IN (
    SELECT staff_id
    FROM staff
    WHERE birth_date < TO_DATE('2001-01-01', 'YYYY-MM-DD')
);

SELECT garments.garment_id, garments.brought_date, repairs.repair_cost, repairs.repair_details
FROM garments
JOIN repairs ON garments.garment_id = repairs.garments_id;

SELECT staff_id, COUNT(*) AS total_garments
FROM garments
GROUP BY staff_id;

SELECT customer_id, CONCAT(first_name, ' ', last_name) AS full_name, UPPER(user_password) AS uppercase_password
FROM customer;

SELECT customer_id, first_name, last_name, SUBSTR(addres, 1, 15) AS shortened_address
FROM customer;

SELECT *
FROM garments
WHERE expected_return_date < SYSDATE

SELECT *
FROM staff
WHERE birth_date > TO_DATE('2001-01-01', 'YYYY-MM-DD')

UPDATE customers
SET address = 'New Address'
WHERE customer_id = 21;

UPDATE complaints
SET complaint_details = 'Updated complaint details'
WHERE complaint_id = 1;

UPDATE logistics
SET logistic_details = 'Updated logistic details'
WHERE logistic_id = 1;

ALTER TABLE staff
ADD email VARCHAR2(50);
