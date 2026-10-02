# SAIT Medical Clinic Database

## Overview

Our group designed and implemented a database for SAIT's Medical Clinic to manage patients, doctors, appointments, visits, medical history, and billing information.

Based on the clinic's business rules, we created an EERD, implemented the database in PostgreSQL with appropriate constraints, and populated the tables with sample data. We also created and tested a set of required and custom SQL queries to retrieve the clinic's data.

## Design Process

1. **Analyzed the business rules**
   - Identified what information the clinic needed to store.

2. **Designed the EERD**
   - Identified and added the main entities.
   - Added attributes and keys.
   - Added relationships, cardinalities, participation, and subtypes.

3. **Created the relational schema**
   - Created tables for the EERD entities.
   - Added primary keys, foreign keys, and other constraints.

4. **Populated the database**
   - Added sample data to the tables.

5. **Wrote and tested SQL queries**
   - Created and tested the required and custom queries.

## Setup Instructions

1. Install PostgreSQL 18.
2. Open a PostgreSQL client or database management tool, such as pgAdmin 4 or a PostgreSQL extension in Visual Studio Code.
3. Create a new PostgreSQL database for the project and connect to it.
4. Run `create-scripts.sql` to create the database tables, relationships, and constraints.
5. Run `data.sql` to populate the tables with the sample data.
6. Run `medical_clinic_queries.sql` to execute the required and custom queries.

### Repository Structure

- `adv-db-class-lab 3 (1).png`: The enhanced entity-relationship diagram image.
- `create-scripts.sql`: DDL script containing CREATE TABLE statements and all constraints.
- `data.sql`: DML script containing INSERT statements to populate the database.
- `medical_clinic_queries.sql`: Script containing all required and custom SELECT queries.
- `database-export.sql`: The complete exported schema and data backup file.
- `Implementing and Querying a Relational Database.pdf`: Document containing query explanations and the team contribution table.
- `README.md`: Project overview, design steps, setup instructions, and query screenshots.

---

## Query Results

### Required Queries

**1. Total number of patients in the database**
<img width="555" height="291" alt="total-patients" src="https://github.com/user-attachments/assets/4a07d7ca-dbbe-4ad4-b361-b6746412478d" />


**2. Patients who visited the clinic last month**
<img width="718" height="415" alt="patient-last-month-visit" src="https://github.com/user-attachments/assets/0ff97d42-87c3-49b1-934e-066ab9d2d531" />

**3. Total dollar amount billed to all patients**
<img width="600" height="361" alt="total-bills" src="https://github.com/user-attachments/assets/bc719bc3-b201-4055-b56d-b617236dc3eb" />

### Custom Queries

**4. Demonstration of aggregation (SUM, COUNT, AVG)**
<img width="395" height="859" alt="aggragate-function-2" src="https://github.com/user-attachments/assets/dbf026da-4a61-4a1e-8132-b2cf3d4c4126" />
<img width="352" height="865" alt="aggragate-function-1" src="https://github.com/user-attachments/assets/4245b666-ae87-49eb-81c6-5202adabc85c" />


**5. Demonstration of subqueries and JOINs**
<img width="1518" height="573" alt="sub-queries" src="https://github.com/user-attachments/assets/916eef73-d01f-4f9d-88f2-28e90449dae7" />


**6. Demonstration of GROUP BY with HAVING**
<img width="703" height="694" alt="goup-by-having-results" src="https://github.com/user-attachments/assets/0d79ca7f-ecdd-4eff-a8e5-e01f6d9aaac3" />


**7. Demonstration of a stored procedure or view**
<img width="700" height="911" alt="view-results" src="https://github.com/user-attachments/assets/5b48a438-a3c1-4074-8b20-d24dab30c291" />

**8. For each doctor, who are their two highest-billed patients?**
<img width="627" height="885" alt="two-highest-billed-patients" src="https://github.com/user-attachments/assets/ed473871-d400-4bd9-a06e-9ab0a3cbd9eb" />


**9. How did visits and billing change from month to month?**
<img width="591" height="801" alt="visit-billing-month-change" src="https://github.com/user-attachments/assets/8ef7834d-7dd8-4bd3-9a64-7d7918666fb5" />


**10. Which doctors bill more than the average doctor, and what share of all clinic billing is each one's?**
<img width="682" height="629" alt="doctor-billing-difference" src="https://github.com/user-attachments/assets/7f1e81b5-2862-4120-8dfd-6e093bb4c31f" />
