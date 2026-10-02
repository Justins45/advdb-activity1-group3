-- Required Queries --

-- Query #1
-- Count the total number of patients in the database.
-- Written by: Jazmin
SELECT COUNT(*) AS total_patients 
FROM patient;

-- Query #2
-- Count how many patients visited the clinic last month.
-- Written by: Jazmin
SELECT COUNT(DISTINCT a.patient_id) AS patients_last_month
FROM visit v
JOIN appointment a ON v.appointment_id = a.appointment_id
WHERE a.date_time >= date_trunc('month', CURRENT_DATE - INTERVAL '1 month')
    AND a.date_time < date_trunc('month', CURRENT_DATE);

-- Query #3
-- Calculate the total dollar amount billed to all patients.
-- Written by: Jazmin
SELECT SUM(total_amount) AS total_billed_amount 
FROM bill;



-- Custom Queries --

-- Query #4
-- One query that demonstrates aggregation (e.g., SUM, COUNT, AVG).
-- Written by: Dylane
SELECT bill_id as "Bill Id", COUNT(bill_line_id) AS "Transactions", to_char(AVG(amount), 'L999.99') AS "Average Amount"
	FROM bill_lines
GROUP BY 1
ORDER BY 1;

-- Query #5
-- One query that uses subqueries and JOINs (e.g., INNER, LEFT, RIGHT).
-- Written by: Dylane
SELECT CONCAT(pe.first_name, ' ', pe.last_name) AS "Full Name", a.date_time AS "Appointment Date and Time", a.status AS "Status", a.notes AS "Booking Notes", v.diagnosis AS "Diagnosis", v.treatment AS "Treatment", v.notes AS "Doctor's Notes"
	FROM visit v
	INNER JOIN appointment a USING (appointment_id)
	INNER JOIN patient p ON a.patient_id = p.person_id
	INNER JOIN person pe USING (person_id)
WHERE EXTRACT(MONTH FROM a.date_time) = EXTRACT(MONTH FROM NOW()) 
	AND a.patient_id IN (
		SELECT patient_id
		FROM parent_guardian
);

-- Query #6
-- One query that uses GROUP BY with HAVING.
-- Written by: Justin
SELECT
    p.first_name || ' ' || p.last_name AS patient_name,
	d.first_name || ' ' || d.last_name AS doctor_name,
	count(*) AS total_visits
FROM visit v
JOIN appointment a ON a.appointment_id = v.appointment_id
JOIN person p ON p.person_id = a.patient_id
JOIN person d ON d.person_id = a.doctor_id
GROUP BY
	patient_name,
	doctor_name
HAVING count(*) >= 5
ORDER BY total_visits DESC;

-- Query #7
-- One query that uses a stored procedure or view.
-- Written by: Justin
CREATE VIEW follow_up_appointment AS
SELECT
    p.first_name || ' ' || p.last_name AS patient_name,
	d.first_name || ' ' || d.last_name AS doctor_name,
	a.date_time,
    a.notes
FROM appointment a
JOIN person p ON p.person_id = a.patient_id
JOIN person d ON d.person_id = a.doctor_id
WHERE a.notes ILIKE '%follow-up%';

SELECT * FROM follow_up_appointment;

-- Query #8
-- For each doctor, who are their two highest-billed patients?
-- Written by: Umaya
WITH patient_bills AS (
    SELECT a.doctor_id,
            a.patient_id,
            p.first_name || ' ' || p.last_name AS patient_name,
            SUM(b.total_amount) AS total_billed
    FROM visit v
    JOIN appointment a USING (appointment_id)
    JOIN bill b USING (visit_id)
    JOIN patient pa ON pa.person_id = a.patient_id
    JOIN person p ON p.person_id = pa.person_id
    GROUP BY a.doctor_id,
            a.patient_id,
            patient_name
),
ranked AS (
    SELECT doctor_id,
            p.first_name || ' ' || p.last_name AS doctor_name,
            patient_name, 
            total_billed,
            row_number() OVER (PARTITION BY doctor_id ORDER BY total_billed DESC) AS billed_rank
    FROM patient_bills
    JOIN doctor d ON d.person_id = doctor_id
    JOIN person p ON p.person_id = d.person_id
)
SELECT doctor_name, billed_rank, patient_name, total_billed
FROM ranked
WHERE billed_rank <= 2
ORDER BY doctor_name, billed_rank;

-- Query #9
-- How did visits and billing change from month to month?
-- Written by: Umaya
WITH monthly AS (
    SELECT date_trunc('month', a.date_time)::date AS month,
            COUNT(v.visit_id) AS total_visits,
            SUM(b.total_amount) AS total_billed
    FROM visit v
    JOIN appointment a USING (appointment_id)
    JOIN bill b USING (visit_id)
    GROUP BY 1
),
previous_month AS (
    SELECT month,
            total_visits,
            total_billed,
            lag(total_visits) OVER (ORDER BY month) AS previous_visits,
            lag(total_billed) OVER (ORDER BY month) AS previous_billed
    FROM monthly
),
monthly_changes AS (
    SELECT month,
            total_visits,
            total_billed,
            previous_visits,
            previous_billed,
            total_visits - previous_visits AS visits_delta,
            total_billed - previous_billed AS billed_delta
    FROM previous_month
)
SELECT month,
        total_visits,
        round(total_billed, 2) AS total_billed,
        visits_delta,
        round(100.0 * (visits_delta / NULLIF(previous_visits, 0)), 1) AS mom_visits_pct,
        round(billed_delta, 2) AS billed_delta,
        round(100.0 * (billed_delta / NULLIF(previous_billed, 0)), 1) AS mom_billed_pct
FROM monthly_changes
ORDER BY month;

-- Query #10
-- Which doctors bill more than the average doctor, and what share of all clinic billing is each one's?
-- Written by: Umaya
WITH doctor_billings AS (
    SELECT a.doctor_id,
            p.first_name || ' ' || p.last_name AS doctor_name,
            SUM(b.total_amount) AS total_billed
    FROM visit v
    JOIN appointment a USING (appointment_id)
    JOIN bill b USING (visit_id)
    JOIN doctor d ON d.person_id = a.doctor_id
    JOIN person p ON p.person_id = d.person_id
    GROUP BY a.doctor_id,
            doctor_name
),
billing_stats AS (
    SELECT doctor_id, 
            doctor_name,
            total_billed,
            round(AVG(total_billed) OVER (), 2) AS avg_doctor_billing,
            SUM(total_billed) OVER () AS total_clinic_billing
    FROM doctor_billings
)
SELECT doctor_name, 
        total_billed,
        avg_doctor_billing,
        total_clinic_billing,
        round(100.0 * (total_billed / NULLIF(total_clinic_billing, 0)), 1) AS pct_of_clinic_billing
FROM billing_stats
WHERE total_billed > avg_doctor_billing
ORDER BY pct_of_clinic_billing DESC;
