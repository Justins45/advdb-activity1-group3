DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS bill_lines;
DROP TABLE IF EXISTS bill;
DROP TABLE IF EXISTS med_history_updates;
DROP TABLE IF EXISTS medical_history;
DROP TABLE IF EXISTS visit;
DROP TABLE IF EXISTS appointment;
DROP TABLE IF EXISTS parent_guardian;
DROP TABLE IF EXISTS patient;
DROP TABLE IF EXISTS doctor;
DROP TABLE IF EXISTS person;

CREATE TABLE person (
    person_id            BIGINT         GENERATED ALWAYS AS IDENTITY,
    first_name           VARCHAR(50)    NOT NULL,
    last_name            VARCHAR(50)    NOT NULL,
    email                VARCHAR(100),
    phone_number         VARCHAR(20),

    CONSTRAINT pk_person_id PRIMARY KEY (person_id),
    CONSTRAINT uq_person_email UNIQUE (email),
    CONSTRAINT uq_person_phone UNIQUE (phone_number)
);

CREATE TABLE doctor (
    person_id            BIGINT         NOT NULL,
    minc_number          VARCHAR(20)    NOT NULL,
    prac_id              VARCHAR(20)    NOT NULL,

    CONSTRAINT pk_doctor_person_id PRIMARY KEY (person_id),

    CONSTRAINT fk_doctor_person_id
        FOREIGN KEY (person_id)
        REFERENCES person (person_id),

    CONSTRAINT uq_minc_prac_number UNIQUE (minc_number, prac_id)
);

CREATE TABLE patient (
    person_id            BIGINT         NOT NULL,
    healthcare_number    VARCHAR(50)    NOT NULL,

    CONSTRAINT pk_patient_person_id PRIMARY KEY (person_id),

    CONSTRAINT fk_patient_person_id
        FOREIGN KEY (person_id)
        REFERENCES person (person_id),

    CONSTRAINT uq_healthcare_number UNIQUE (healthcare_number)
);

CREATE TABLE parent_guardian (
    person_id            BIGINT         NOT NULL,
    patient_id           BIGINT         NOT NULL,

    CONSTRAINT pk_parent_guardian PRIMARY KEY (patient_id, person_id),

    CONSTRAINT fk_guardian_patient_id
        FOREIGN KEY (patient_id)
        REFERENCES patient (person_id),

    CONSTRAINT fk_guardian_person_id
        FOREIGN KEY (person_id)
        REFERENCES person (person_id)
);

CREATE TABLE appointment (
    appointment_id       BIGINT         GENERATED ALWAYS AS IDENTITY,
    patient_id           BIGINT         NOT NULL,
    doctor_id            BIGINT         NOT NULL,
    date_time            TIMESTAMPTZ    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status               VARCHAR(20)    NOT NULL DEFAULT 'BOOKED',
    notes                VARCHAR(500),

    CONSTRAINT pk_appointment_id PRIMARY KEY (appointment_id),

    CONSTRAINT fk_appointment_patient_id
        FOREIGN KEY (patient_id)
        REFERENCES patient (person_id),

    CONSTRAINT fk_appointment_doctor_id
        FOREIGN KEY (doctor_id)
        REFERENCES doctor (person_id),

    CONSTRAINT ck_appointment_status
        CHECK (status IN ('BOOKED', 'MISSED', 'CANCELED', 'ATTENDED'))
);

CREATE TABLE visit (
    visit_id             BIGINT         GENERATED ALWAYS AS IDENTITY,
    appointment_id       BIGINT         NOT NULL,
    treatment            VARCHAR(255),
    diagnosis            VARCHAR(255),
    notes                VARCHAR(500),

    CONSTRAINT pk_visit_id PRIMARY KEY (visit_id),

    CONSTRAINT fk_visit_appointment_id
        FOREIGN KEY (appointment_id)
        REFERENCES appointment (appointment_id),

    CONSTRAINT uq_visit_appointment_id UNIQUE (appointment_id)
);

CREATE TABLE medical_history (
    medical_history_id   BIGINT         GENERATED ALWAYS AS IDENTITY,
    patient_id           BIGINT         NOT NULL,
    heart_rate           NUMERIC,
    weight               NUMERIC,
    blood_pressure       VARCHAR(10),
    status               VARCHAR(20)    NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT pk_medical_history_id PRIMARY KEY (medical_history_id),

    CONSTRAINT fk_med_history_patient_id
        FOREIGN KEY (patient_id)
        REFERENCES patient (person_id),

    CONSTRAINT ck_med_history_status
        CHECK (status IN ('ACTIVE', 'INACTIVE', 'ARCHIVED')),

    CONSTRAINT uq_med_history_patient_id UNIQUE (patient_id)
);

CREATE TABLE med_history_updates (
    medical_history_id   BIGINT         NOT NULL,
    visit_id             BIGINT         NOT NULL,
    date_time            TIMESTAMPTZ    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes                VARCHAR(500),

    CONSTRAINT pk_med_history_update_id PRIMARY KEY (medical_history_id, visit_id),

    CONSTRAINT fk_med_history_id
        FOREIGN KEY (medical_history_id)
        REFERENCES medical_history (medical_history_id),

    CONSTRAINT fk_med_history_update_visit_id
        FOREIGN KEY (visit_id)
        REFERENCES visit (visit_id)
);

CREATE TABLE bill (
    bill_id              BIGINT         GENERATED ALWAYS AS IDENTITY,
    visit_id             BIGINT         NOT NULL,
    patient_id           BIGINT         NOT NULL,
    doctor_id            BIGINT         NOT NULL,
    bill_date            TIMESTAMPTZ    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount         NUMERIC(10,2)  NOT NULL,
    amount_paid          NUMERIC(10,2)  NOT NULL DEFAULT 0,

    CONSTRAINT pk_bill_id PRIMARY KEY (bill_id),

    CONSTRAINT fk_bill_visit_id
        FOREIGN KEY (visit_id)
        REFERENCES visit (visit_id),

    CONSTRAINT fk_bill_doctor_id
        FOREIGN KEY (doctor_id)
        REFERENCES doctor (person_id),

    CONSTRAINT fk_bill_patient_id
        FOREIGN KEY (patient_id)
        REFERENCES patient (person_id),

    CONSTRAINT uq_bill_visit_id UNIQUE (visit_id)
);

CREATE TABLE bill_lines (
    bill_line_id         BIGINT         GENERATED ALWAYS AS IDENTITY,
    bill_id              BIGINT         NOT NULL,
    amount               NUMERIC(10,2)  NOT NULL,
    description          VARCHAR(500)   NOT NULL,

    CONSTRAINT pk_bill_line_id PRIMARY KEY (bill_line_id),

    CONSTRAINT fk_bill_line_bill_id
        FOREIGN KEY (bill_id)
        REFERENCES bill (bill_id)
);

CREATE TABLE payment (
    payment_id           BIGINT         GENERATED ALWAYS AS IDENTITY,
    bill_id              BIGINT         NOT NULL,
    amount               NUMERIC(10,2)  NOT NULL,
    method               VARCHAR(20)    NOT NULL,
    payment_date         TIMESTAMPTZ    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes                VARCHAR(500),

    CONSTRAINT pk_payment PRIMARY KEY (payment_id),

    CONSTRAINT fk_payment_bill_id
        FOREIGN KEY (bill_id)
        REFERENCES bill (bill_id),

    CONSTRAINT ck_payment_method
        CHECK (method IN ('MASTERCARD', 'VISA', 'DEBIT', 'CASH')),

    CONSTRAINT ck_payment_amount
        CHECK (amount > 0)
);
