--
-- PostgreSQL database dump
--

\restrict YgY3CB3FA6phb4qx000G7Z0t0u4Q9bJcd5AEtshhzAj4I0D9RWpjCaEs75G3Ga9

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-01 17:53:18 MDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 225 (class 1259 OID 25544)
-- Name: appointment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment (
    appointment_id bigint NOT NULL,
    patient_id bigint NOT NULL,
    doctor_id bigint NOT NULL,
    date_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status character varying(20) DEFAULT 'BOOKED'::character varying NOT NULL,
    notes character varying(500),
    CONSTRAINT ck_appointment_status CHECK (((status)::text = ANY ((ARRAY['BOOKED'::character varying, 'MISSED'::character varying, 'CANCELED'::character varying, 'ATTENDED'::character varying])::text[])))
);


ALTER TABLE public.appointment OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25543)
-- Name: appointment_appointment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.appointment ALTER COLUMN appointment_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.appointment_appointment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 25628)
-- Name: bill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bill (
    bill_id bigint NOT NULL,
    visit_id bigint NOT NULL,
    patient_id bigint NOT NULL,
    doctor_id bigint NOT NULL,
    bill_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    amount_paid numeric(10,2) DEFAULT 0 NOT NULL
);


ALTER TABLE public.bill OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 25627)
-- Name: bill_bill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.bill ALTER COLUMN bill_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.bill_bill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 25660)
-- Name: bill_lines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bill_lines (
    bill_line_id bigint NOT NULL,
    bill_id bigint NOT NULL,
    amount numeric(10,2) NOT NULL,
    description character varying(500) NOT NULL
);


ALTER TABLE public.bill_lines OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 25659)
-- Name: bill_lines_bill_line_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.bill_lines ALTER COLUMN bill_line_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.bill_lines_bill_line_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 25497)
-- Name: doctor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor (
    person_id bigint NOT NULL,
    minc_number character varying(20) NOT NULL,
    prac_id character varying(20) NOT NULL
);


ALTER TABLE public.doctor OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 25485)
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    person_id bigint NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100),
    phone_number character varying(20)
);


ALTER TABLE public.person OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 25704)
-- Name: follow_up_appointment; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.follow_up_appointment AS
 SELECT (((p.first_name)::text || ' '::text) || (p.last_name)::text) AS patient_name,
    (((d.first_name)::text || ' '::text) || (d.last_name)::text) AS doctor_name,
    a.date_time,
    a.notes
   FROM ((public.appointment a
     JOIN public.person p ON ((p.person_id = a.patient_id)))
     JOIN public.person d ON ((d.person_id = a.doctor_id)))
  WHERE ((a.notes)::text ~~* '%follow-up%'::text);


ALTER VIEW public.follow_up_appointment OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 25606)
-- Name: med_history_updates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.med_history_updates (
    medical_history_id bigint NOT NULL,
    visit_id bigint NOT NULL,
    date_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    notes character varying(500)
);


ALTER TABLE public.med_history_updates OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 25587)
-- Name: medical_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_history (
    medical_history_id bigint NOT NULL,
    patient_id bigint NOT NULL,
    heart_rate numeric,
    weight numeric,
    blood_pressure character varying(10),
    status character varying(20) DEFAULT 'ACTIVE'::character varying NOT NULL,
    CONSTRAINT ck_med_history_status CHECK (((status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'INACTIVE'::character varying, 'ARCHIVED'::character varying])::text[])))
);


ALTER TABLE public.medical_history OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 25586)
-- Name: medical_history_medical_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.medical_history ALTER COLUMN medical_history_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.medical_history_medical_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 25526)
-- Name: parent_guardian; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parent_guardian (
    person_id bigint NOT NULL,
    patient_id bigint NOT NULL
);


ALTER TABLE public.parent_guardian OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25512)
-- Name: patient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patient (
    person_id bigint NOT NULL,
    healthcare_number character varying(50) NOT NULL
);


ALTER TABLE public.patient OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 25677)
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    payment_id bigint NOT NULL,
    bill_id bigint NOT NULL,
    amount numeric(10,2) NOT NULL,
    method character varying(20) NOT NULL,
    payment_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    notes character varying(500),
    CONSTRAINT ck_payment_amount CHECK ((amount > (0)::numeric)),
    CONSTRAINT ck_payment_method CHECK (((method)::text = ANY ((ARRAY['MASTERCARD'::character varying, 'VISA'::character varying, 'DEBIT'::character varying, 'CASH'::character varying])::text[])))
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 25676)
-- Name: payment_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.payment ALTER COLUMN payment_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.payment_payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 25484)
-- Name: person_person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.person ALTER COLUMN person_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.person_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 25570)
-- Name: visit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visit (
    visit_id bigint NOT NULL,
    appointment_id bigint NOT NULL,
    treatment character varying(255),
    diagnosis character varying(255),
    notes character varying(500)
);


ALTER TABLE public.visit OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 25569)
-- Name: visit_visit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.visit ALTER COLUMN visit_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.visit_visit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3592 (class 0 OID 25544)
-- Dependencies: 225
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (1, 11, 1, '2026-08-04 09:00:00-06', 'ATTENDED', 'Annual physical');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (2, 12, 2, '2026-08-04 10:30:00-06', 'ATTENDED', 'Persistent cough for two weeks');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (3, 13, 3, '2026-08-05 08:45:00-06', 'ATTENDED', 'Follow-up on blood work');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (4, 14, 1, '2026-08-05 11:15:00-06', 'ATTENDED', 'Lower back pain');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (5, 15, 4, '2026-08-06 13:00:00-06', 'ATTENDED', 'Skin rash on forearm');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (6, 16, 5, '2026-08-07 09:30:00-06', 'ATTENDED', 'Blood pressure check');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (7, 17, 6, '2026-08-10 14:00:00-06', 'ATTENDED', 'Knee pain after running');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (8, 18, 2, '2026-08-11 10:00:00-06', 'ATTENDED', 'Seasonal allergies');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (9, 19, 7, '2026-08-12 15:30:00-06', 'ATTENDED', 'Migraine consultation');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (10, 20, 8, '2026-08-13 09:15:00-06', 'ATTENDED', 'Routine checkup');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (11, 21, 3, '2026-08-14 11:00:00-06', 'ATTENDED', 'Fatigue and poor sleep');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (12, 22, 6, '2026-08-17 13:45:00-06', 'ATTENDED', 'Sprained ankle');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (13, 23, 10, '2026-08-18 08:30:00-06', 'ATTENDED', 'Vaccination update');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (14, 24, 4, '2026-08-19 10:45:00-06', 'ATTENDED', 'Sore throat');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (15, 25, 5, '2026-08-20 14:15:00-06', 'ATTENDED', 'Cholesterol review');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (16, 26, 9, '2026-08-21 09:00:00-06', 'ATTENDED', 'Ear pain');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (17, 27, 9, '2026-08-24 09:30:00-06', 'ATTENDED', 'School vaccinations');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (18, 28, 9, '2026-08-25 10:00:00-06', 'ATTENDED', 'Asthma review');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (19, 29, 9, '2026-08-26 11:30:00-06', 'ATTENDED', 'Wrist pain after a fall');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (20, 30, 9, '2026-09-01 09:15:00-06', 'ATTENDED', 'Fever and sore throat');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (21, 11, 1, '2026-09-08 10:00:00-06', 'ATTENDED', 'Follow-up on lab results');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (22, 14, 1, '2026-09-15 11:00:00-06', 'ATTENDED', 'Back pain follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (23, 16, 5, '2026-09-02 09:00:00-06', 'MISSED', 'Patient did not show up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (24, 20, 8, '2026-09-09 14:30:00-06', 'MISSED', 'Patient did not show up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (25, 24, 4, '2026-09-10 10:15:00-06', 'MISSED', NULL);
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (26, 12, 2, '2026-09-11 13:00:00-06', 'CANCELED', 'Canceled by patient - scheduling conflict');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (27, 18, 2, '2026-09-16 09:45:00-06', 'CANCELED', 'Canceled by patient - symptoms resolved');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (28, 22, 6, '2026-09-18 15:00:00-06', 'CANCELED', 'Canceled by clinic - doctor unavailable');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (29, 13, 3, '2026-10-06 09:00:00-06', 'BOOKED', 'Follow-up appointment');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (30, 27, 9, '2026-10-13 10:30:00-06', 'BOOKED', 'Annual checkup');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (31, 26, 9, '2026-01-08 08:30:00-07', 'ATTENDED', 'Runny nose and cough');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (32, 11, 1, '2026-01-13 09:00:00-07', 'ATTENDED', 'Cold and congestion');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (33, 25, 5, '2026-01-15 13:30:00-07', 'ATTENDED', 'Chest tightness');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (34, 14, 1, '2026-01-20 08:30:00-07', 'ATTENDED', 'Cough and fever');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (35, 28, 9, '2026-01-22 08:45:00-07', 'ATTENDED', 'Wheezing at night');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (36, 16, 5, '2026-01-27 10:00:00-07', 'ATTENDED', 'Dizziness and headaches');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (37, 12, 2, '2026-02-03 09:30:00-07', 'ATTENDED', 'Annual physical');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (38, 21, 3, '2026-02-10 11:00:00-07', 'ATTENDED', 'Shortness of breath on stairs');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (39, 27, 9, '2026-02-12 15:00:00-07', 'ATTENDED', 'Stomach ache');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (40, 25, 5, '2026-02-19 14:00:00-07', 'ATTENDED', 'Lab results review');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (41, 14, 1, '2026-02-24 09:45:00-07', 'ATTENDED', 'Muscle soreness after moving furniture');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (42, 16, 5, '2026-02-24 10:00:00-07', 'ATTENDED', 'Blood pressure recheck');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (43, 28, 9, '2026-02-26 08:30:00-07', 'ATTENDED', 'Asthma follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (44, 11, 1, '2026-03-03 10:30:00-07', 'ATTENDED', 'Shoulder pain');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (45, 26, 9, '2026-03-05 09:00:00-07', 'ATTENDED', 'Ear pain');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (46, 13, 3, '2026-03-10 09:00:00-06', 'ATTENDED', 'Fatigue and pale skin');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (47, 23, 10, '2026-03-12 09:00:00-06', 'ATTENDED', 'Annual physical');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (48, 12, 2, '2026-03-17 15:00:00-06', 'ATTENDED', 'Persistent heartburn');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (49, 26, 9, '2026-03-19 09:30:00-06', 'ATTENDED', 'Ear pain not improving');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (50, 20, 8, '2026-03-24 14:00:00-06', 'ATTENDED', 'Minor cut on hand');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (51, 25, 5, '2026-04-02 13:30:00-06', 'ATTENDED', 'Cholesterol follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (52, 16, 5, '2026-04-07 09:30:00-06', 'ATTENDED', 'Blood pressure follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (53, 18, 2, '2026-04-08 09:30:00-06', 'ATTENDED', 'Sinus congestion');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (54, 14, 6, '2026-04-14 10:15:00-06', 'ATTENDED', 'Persistent back pain');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (55, 28, 9, '2026-04-16 09:00:00-06', 'ATTENDED', 'Asthma flare after a cold');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (56, 11, 10, '2026-04-21 14:00:00-06', 'ATTENDED', 'Travel vaccine consultation');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (57, 30, 9, '2026-04-28 10:00:00-06', 'ATTENDED', 'Well-child checkup');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (58, 12, 2, '2026-05-05 10:00:00-06', 'ATTENDED', 'Heartburn follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (59, 28, 9, '2026-05-07 08:30:00-06', 'ATTENDED', 'Asthma follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (60, 21, 3, '2026-05-12 10:30:00-06', 'ATTENDED', 'Asthma follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (61, 25, 3, '2026-05-14 14:15:00-06', 'ATTENDED', 'Metabolic screening');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (62, 16, 5, '2026-05-19 11:00:00-06', 'ATTENDED', 'Blood pressure log review');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (63, 14, 6, '2026-05-26 13:00:00-06', 'ATTENDED', 'Back pain follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (64, 24, 4, '2026-05-27 15:30:00-06', 'ATTENDED', 'Acne concerns');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (65, 26, 9, '2026-05-28 15:00:00-06', 'ATTENDED', 'Well-child checkup');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (66, 27, 9, '2026-06-04 10:30:00-06', 'ATTENDED', 'Well-child checkup');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (67, 11, 7, '2026-06-09 11:15:00-06', 'ATTENDED', 'Recurring headaches');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (68, 25, 3, '2026-06-11 14:00:00-06', 'ATTENDED', 'Screening results');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (69, 17, 10, '2026-06-17 08:30:00-06', 'ATTENDED', 'Travel vaccination');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (70, 12, 3, '2026-06-23 13:30:00-06', 'ATTENDED', 'Heartburn second opinion');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (71, 28, 9, '2026-06-25 09:15:00-06', 'ATTENDED', 'Asthma check');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (72, 16, 3, '2026-06-30 15:00:00-06', 'ATTENDED', 'Annual bloodwork');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (73, 25, 5, '2026-07-16 13:45:00-06', 'ATTENDED', 'Cholesterol recheck');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (74, 14, 1, '2026-08-19 14:45:00-06', 'ATTENDED', 'Back pain progress check');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (75, 12, 2, '2026-08-25 16:00:00-06', 'ATTENDED', 'Rash on hands');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (76, 16, 5, '2026-08-28 10:00:00-06', 'ATTENDED', 'Blood pressure recheck');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (77, 26, 9, '2026-09-02 15:30:00-06', 'ATTENDED', 'Ear infection follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (78, 16, 5, '2026-09-09 09:00:00-06', 'ATTENDED', 'Rescheduled blood pressure visit');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (79, 21, 3, '2026-09-21 14:30:00-06', 'ATTENDED', 'Thyroid panel results');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (80, 13, 3, '2026-09-22 09:15:00-06', 'ATTENDED', 'Iron level recheck');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (81, 25, 5, '2026-09-22 13:30:00-06', 'ATTENDED', 'Cholesterol follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (82, 15, 4, '2026-09-23 13:30:00-06', 'ATTENDED', 'Rash follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (83, 19, 7, '2026-09-23 15:45:00-06', 'ATTENDED', 'Migraine follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (84, 16, 5, '2026-09-24 09:30:00-06', 'ATTENDED', 'Blood pressure follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (85, 28, 9, '2026-09-24 15:45:00-06', 'ATTENDED', 'Asthma follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (86, 11, 1, '2026-09-25 10:00:00-06', 'ATTENDED', 'Vitamin D recheck');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (87, 22, 6, '2026-09-25 14:00:00-06', 'ATTENDED', 'Ankle follow-up');
INSERT INTO public.appointment OVERRIDING SYSTEM VALUE VALUES (88, 14, 1, '2026-09-28 09:30:00-06', 'ATTENDED', 'Final back pain check');


--
-- TOC entry 3599 (class 0 OID 25628)
-- Dependencies: 232
-- Data for Name: bill; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (1, 1, 11, 1, '2026-08-04 09:45:00-06', 120.00, 120.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (2, 2, 12, 2, '2026-08-04 11:15:00-06', 105.00, 105.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (3, 3, 13, 3, '2026-08-05 09:30:00-06', 78.50, 78.50);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (4, 4, 14, 1, '2026-08-05 12:00:00-06', 90.00, 90.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (5, 5, 15, 4, '2026-08-06 13:45:00-06', 110.00, 110.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (6, 6, 16, 5, '2026-08-07 10:15:00-06', 95.00, 95.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (7, 7, 17, 6, '2026-08-10 14:45:00-06', 115.00, 115.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (8, 8, 18, 2, '2026-08-11 10:45:00-06', 75.00, 75.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (9, 9, 19, 7, '2026-08-12 16:15:00-06', 180.00, 180.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (10, 10, 20, 8, '2026-08-13 10:00:00-06', 95.00, 95.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (11, 11, 21, 3, '2026-08-14 11:45:00-06', 100.00, 100.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (12, 12, 22, 6, '2026-08-17 14:30:00-06', 97.50, 97.50);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (13, 13, 23, 10, '2026-08-18 09:15:00-06', 70.00, 70.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (14, 14, 24, 4, '2026-08-19 11:30:00-06', 95.00, 95.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (15, 15, 25, 5, '2026-08-20 15:00:00-06', 105.00, 50.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (16, 16, 26, 9, '2026-08-21 09:45:00-06', 97.00, 97.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (17, 17, 27, 9, '2026-08-24 10:15:00-06', 110.00, 110.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (18, 18, 28, 9, '2026-08-25 10:45:00-06', 105.00, 105.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (19, 19, 29, 9, '2026-08-26 12:15:00-06', 170.00, 170.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (20, 20, 30, 9, '2026-09-01 10:00:00-06', 105.00, 105.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (21, 21, 11, 1, '2026-09-08 10:45:00-06', 75.00, 0.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (22, 22, 14, 1, '2026-09-15 11:45:00-06', 60.00, 60.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (23, 23, 26, 9, '2026-01-08 09:15:00-07', 85.00, 85.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (24, 24, 11, 1, '2026-01-13 09:45:00-07', 75.00, 75.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (25, 25, 25, 5, '2026-01-15 14:15:00-07', 145.00, 145.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (26, 26, 14, 1, '2026-01-20 09:15:00-07', 75.00, 75.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (27, 27, 28, 9, '2026-01-22 09:30:00-07', 97.00, 97.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (28, 28, 16, 5, '2026-01-27 10:45:00-07', 120.00, 120.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (29, 29, 12, 2, '2026-02-03 10:15:00-07', 75.00, 75.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (30, 30, 21, 3, '2026-02-10 11:45:00-07', 130.00, 130.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (31, 31, 27, 9, '2026-02-12 15:45:00-07', 85.00, 85.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (32, 32, 25, 5, '2026-02-19 14:45:00-07', 60.00, 60.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (33, 33, 14, 1, '2026-02-24 10:30:00-07', 75.00, 75.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (34, 34, 16, 5, '2026-02-24 10:45:00-07', 60.00, 60.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (35, 35, 28, 9, '2026-02-26 09:15:00-07', 65.00, 65.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (36, 36, 11, 1, '2026-03-03 11:15:00-07', 75.00, 75.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (37, 37, 26, 9, '2026-03-05 09:45:00-07', 85.00, 85.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (38, 38, 13, 3, '2026-03-10 09:45:00-06', 100.00, 100.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (39, 39, 23, 10, '2026-03-12 09:45:00-06', 75.00, 75.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (40, 40, 12, 2, '2026-03-17 15:45:00-06', 75.00, 75.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (41, 41, 26, 9, '2026-03-19 10:15:00-06', 77.00, 77.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (42, 42, 20, 8, '2026-03-24 14:45:00-06', 90.00, 90.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (43, 43, 25, 5, '2026-04-02 14:15:00-06', 60.00, 60.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (44, 44, 16, 5, '2026-04-07 10:15:00-06', 60.00, 60.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (45, 45, 18, 2, '2026-04-08 10:15:00-06', 75.00, 75.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (46, 46, 14, 6, '2026-04-14 11:00:00-06', 100.00, 100.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (47, 47, 28, 9, '2026-04-16 09:45:00-06', 115.00, 57.50);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (48, 48, 11, 10, '2026-04-21 14:45:00-06', 160.00, 160.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (49, 49, 30, 9, '2026-04-28 10:45:00-06', 85.00, 85.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (50, 50, 12, 2, '2026-05-05 10:45:00-06', 90.00, 90.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (51, 51, 28, 9, '2026-05-07 09:15:00-06', 77.00, 77.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (52, 52, 21, 3, '2026-05-12 11:15:00-06', 90.00, 90.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (53, 53, 25, 3, '2026-05-14 15:00:00-06', 100.00, 100.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (54, 54, 16, 5, '2026-05-19 11:45:00-06', 60.00, 30.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (55, 55, 14, 6, '2026-05-26 13:45:00-06', 75.00, 37.50);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (56, 56, 24, 4, '2026-05-27 16:15:00-06', 140.00, 140.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (57, 57, 26, 9, '2026-05-28 15:45:00-06', 85.00, 85.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (58, 58, 27, 9, '2026-06-04 11:15:00-06', 85.00, 85.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (59, 59, 11, 7, '2026-06-09 12:00:00-06', 150.00, 150.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (60, 60, 25, 3, '2026-06-11 14:45:00-06', 60.00, 60.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (61, 61, 17, 10, '2026-06-17 09:15:00-06', 195.00, 195.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (62, 62, 12, 3, '2026-06-23 14:15:00-06', 75.00, 75.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (63, 63, 28, 9, '2026-06-25 10:00:00-06', 65.00, 65.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (64, 64, 16, 3, '2026-06-30 15:45:00-06', 100.00, 100.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (65, 65, 25, 5, '2026-07-16 14:30:00-06', 85.00, 85.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (66, 66, 14, 1, '2026-08-19 15:30:00-06', 60.00, 60.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (67, 67, 12, 2, '2026-08-25 16:45:00-06', 105.00, 105.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (68, 68, 16, 5, '2026-08-28 10:45:00-06', 60.00, 60.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (69, 69, 26, 9, '2026-09-02 16:15:00-06', 65.00, 65.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (70, 70, 16, 5, '2026-09-09 09:45:00-06', 60.00, 60.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (71, 71, 21, 3, '2026-09-21 15:15:00-06', 60.00, 60.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (72, 72, 13, 3, '2026-09-22 10:00:00-06', 60.00, 60.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (73, 73, 25, 5, '2026-09-22 14:15:00-06', 60.00, 60.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (74, 74, 15, 4, '2026-09-23 14:15:00-06', 75.00, 75.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (75, 75, 19, 7, '2026-09-23 16:30:00-06', 100.00, 100.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (76, 76, 16, 5, '2026-09-24 10:15:00-06', 60.00, 0.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (77, 77, 28, 9, '2026-09-24 16:30:00-06', 65.00, 0.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (78, 78, 11, 1, '2026-09-25 10:45:00-06', 60.00, 0.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (79, 79, 22, 6, '2026-09-25 14:45:00-06', 75.00, 0.00);
INSERT INTO public.bill OVERRIDING SYSTEM VALUE VALUES (80, 80, 14, 1, '2026-09-28 10:15:00-06', 60.00, 0.00);


--
-- TOC entry 3601 (class 0 OID 25660)
-- Dependencies: 234
-- Data for Name: bill_lines; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (1, 1, 95.00, 'Consultation - annual physical');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (2, 1, 25.00, 'Lab requisition processing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (3, 2, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (4, 2, 30.00, 'Prescription - cough suppressant');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (5, 3, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (6, 3, 18.50, 'Iron supplement dispensing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (7, 4, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (8, 4, 15.00, 'Physiotherapy referral');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (9, 5, 110.00, 'Dermatology consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (10, 6, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (11, 6, 20.00, 'Blood pressure monitoring');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (12, 7, 100.00, 'Sports medicine consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (13, 7, 15.00, 'Physiotherapy referral');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (14, 8, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (15, 9, 150.00, 'Neurology consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (16, 9, 30.00, 'Prescription - migraine medication');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (17, 10, 95.00, 'Routine physical exam');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (18, 11, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (19, 11, 25.00, 'Thyroid panel requisition');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (20, 12, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (21, 12, 22.50, 'Ankle wrap and supplies');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (22, 13, 25.00, 'Vaccine administration fee');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (23, 13, 45.00, 'Tetanus and influenza vaccines');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (24, 14, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (25, 14, 20.00, 'Rapid strep test');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (26, 15, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (27, 15, 30.00, 'Lipid panel review');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (28, 16, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (29, 16, 12.00, 'Ear drops dispensing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (30, 17, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (31, 17, 25.00, 'Vaccine administration fee');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (32, 18, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (33, 18, 20.00, 'Inhaler technique review');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (34, 19, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (35, 19, 65.00, 'Wrist X-ray');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (36, 19, 20.00, 'Splint');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (37, 20, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (38, 20, 20.00, 'Rapid strep test');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (39, 21, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (40, 21, 15.00, 'Vitamin D supplement dispensing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (41, 22, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (42, 23, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (43, 24, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (44, 25, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (45, 25, 45.00, 'ECG');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (46, 25, 25.00, 'Lab requisition processing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (47, 26, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (48, 27, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (49, 27, 12.00, 'Prescription dispensing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (50, 28, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (51, 28, 45.00, 'ECG');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (52, 29, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (53, 30, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (54, 30, 55.00, 'Spirometry');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (55, 31, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (56, 32, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (57, 33, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (58, 34, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (59, 35, 65.00, 'Pediatric consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (60, 36, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (61, 37, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (62, 38, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (63, 38, 25.00, 'Lab requisition processing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (64, 39, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (65, 40, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (66, 41, 65.00, 'Pediatric consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (67, 41, 12.00, 'Prescription dispensing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (68, 42, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (69, 42, 15.00, 'Wound care supplies');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (70, 43, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (71, 44, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (72, 45, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (73, 46, 100.00, 'Sports medicine consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (74, 47, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (75, 47, 30.00, 'Nebulizer treatment');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (76, 48, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (77, 48, 25.00, 'Vaccine administration fee');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (78, 48, 60.00, 'Hepatitis A vaccine');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (79, 49, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (80, 50, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (81, 50, 30.00, 'Prescription dispensing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (82, 51, 65.00, 'Pediatric consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (83, 51, 12.00, 'Prescription dispensing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (84, 52, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (85, 52, 30.00, 'Prescription dispensing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (86, 53, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (87, 53, 25.00, 'Lab requisition processing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (88, 54, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (89, 55, 75.00, 'Sports medicine consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (90, 56, 110.00, 'Dermatology consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (91, 56, 30.00, 'Prescription dispensing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (92, 57, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (93, 58, 85.00, 'Pediatric consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (94, 59, 150.00, 'Neurology consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (95, 60, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (96, 61, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (97, 61, 25.00, 'Vaccine administration fee');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (98, 61, 95.00, 'Travel vaccines');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (99, 62, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (100, 63, 65.00, 'Pediatric consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (101, 64, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (102, 64, 25.00, 'Lab requisition processing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (103, 65, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (104, 65, 25.00, 'Lab requisition processing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (105, 66, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (106, 67, 75.00, 'Consultation');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (107, 67, 30.00, 'Prescription dispensing');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (108, 68, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (109, 69, 65.00, 'Pediatric consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (110, 70, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (111, 71, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (112, 72, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (113, 73, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (114, 74, 75.00, 'Dermatology consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (115, 75, 100.00, 'Neurology consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (116, 76, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (117, 77, 65.00, 'Pediatric consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (118, 78, 60.00, 'Consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (119, 79, 75.00, 'Sports medicine consultation - follow-up');
INSERT INTO public.bill_lines OVERRIDING SYSTEM VALUE VALUES (120, 80, 60.00, 'Consultation - follow-up');


--
-- TOC entry 3588 (class 0 OID 25497)
-- Dependencies: 221
-- Data for Name: doctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.doctor VALUES (1, 'MINC-100201', 'PRAC-4401');
INSERT INTO public.doctor VALUES (2, 'MINC-100202', 'PRAC-4402');
INSERT INTO public.doctor VALUES (3, 'MINC-100203', 'PRAC-4403');
INSERT INTO public.doctor VALUES (4, 'MINC-100204', 'PRAC-4404');
INSERT INTO public.doctor VALUES (5, 'MINC-100205', 'PRAC-4405');
INSERT INTO public.doctor VALUES (6, 'MINC-100206', 'PRAC-4406');
INSERT INTO public.doctor VALUES (7, 'MINC-100207', 'PRAC-4407');
INSERT INTO public.doctor VALUES (8, 'MINC-100208', 'PRAC-4408');
INSERT INTO public.doctor VALUES (9, 'MINC-100209', 'PRAC-4409');
INSERT INTO public.doctor VALUES (10, 'MINC-100210', 'PRAC-4410');


--
-- TOC entry 3597 (class 0 OID 25606)
-- Dependencies: 230
-- Data for Name: med_history_updates; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.med_history_updates VALUES (1, 1, '2026-08-04 09:50:00-06', 'Baseline vitals recorded; lab requisition issued');
INSERT INTO public.med_history_updates VALUES (2, 2, '2026-08-04 11:20:00-06', 'Bronchitis noted; advised rest and fluids');
INSERT INTO public.med_history_updates VALUES (3, 3, '2026-08-05 09:35:00-06', 'Iron deficiency noted; supplement started');
INSERT INTO public.med_history_updates VALUES (4, 4, '2026-08-05 12:05:00-06', 'Lumbar strain noted; physiotherapy referral');
INSERT INTO public.med_history_updates VALUES (5, 5, '2026-08-06 13:50:00-06', 'Contact dermatitis noted; topical treatment');
INSERT INTO public.med_history_updates VALUES (6, 6, '2026-08-07 10:20:00-06', 'Elevated blood pressure noted; monitoring plan set');
INSERT INTO public.med_history_updates VALUES (7, 7, '2026-08-10 14:50:00-06', 'Knee pain noted; physiotherapy referral');
INSERT INTO public.med_history_updates VALUES (8, 8, '2026-08-11 10:50:00-06', 'Seasonal allergies noted');
INSERT INTO public.med_history_updates VALUES (9, 9, '2026-08-12 16:20:00-06', 'Migraine diagnosis added; headache diary started');
INSERT INTO public.med_history_updates VALUES (10, 10, '2026-08-13 10:05:00-06', 'Routine exam; no changes');
INSERT INTO public.med_history_updates VALUES (11, 11, '2026-08-14 11:50:00-06', 'Fatigue under investigation; thyroid panel ordered');
INSERT INTO public.med_history_updates VALUES (12, 12, '2026-08-17 14:35:00-06', 'Ankle sprain noted');
INSERT INTO public.med_history_updates VALUES (13, 13, '2026-08-18 09:20:00-06', 'Immunizations updated');
INSERT INTO public.med_history_updates VALUES (14, 14, '2026-08-19 11:35:00-06', 'Viral pharyngitis noted');
INSERT INTO public.med_history_updates VALUES (15, 15, '2026-08-20 15:05:00-06', 'Borderline cholesterol noted; diet counselling');
INSERT INTO public.med_history_updates VALUES (16, 16, '2026-08-21 09:50:00-06', 'Ear infection noted; treated with ear drops');
INSERT INTO public.med_history_updates VALUES (17, 17, '2026-08-24 10:20:00-06', 'School-entry vaccinations recorded');
INSERT INTO public.med_history_updates VALUES (18, 18, '2026-08-25 10:50:00-06', 'Asthma medication adjusted');
INSERT INTO public.med_history_updates VALUES (19, 19, '2026-08-26 12:20:00-06', 'Wrist sprain noted; X-ray negative');
INSERT INTO public.med_history_updates VALUES (20, 20, '2026-09-01 10:05:00-06', 'Strep throat treated with antibiotics');
INSERT INTO public.med_history_updates VALUES (1, 21, '2026-09-08 10:50:00-06', 'Vitamin D deficiency noted; supplement started');
INSERT INTO public.med_history_updates VALUES (4, 22, '2026-09-15 11:50:00-06', 'Back pain improving; continue exercises');
INSERT INTO public.med_history_updates VALUES (16, 23, '2026-01-08 09:20:00-07', 'Common cold: Supportive care');
INSERT INTO public.med_history_updates VALUES (1, 24, '2026-01-13 09:50:00-07', 'Upper respiratory infection: Symptomatic treatment; fluids and rest');
INSERT INTO public.med_history_updates VALUES (15, 25, '2026-01-15 14:20:00-07', 'Non-cardiac chest discomfort: ECG normal; blood work ordered');
INSERT INTO public.med_history_updates VALUES (4, 26, '2026-01-20 09:20:00-07', 'Influenza-like illness: Rest, fluids and fever control');
INSERT INTO public.med_history_updates VALUES (18, 27, '2026-01-22 09:35:00-07', 'Asthma, newly diagnosed: Reliever inhaler prescribed');
INSERT INTO public.med_history_updates VALUES (6, 28, '2026-01-27 10:50:00-07', 'Elevated blood pressure: Blood pressure measured; ECG performed');
INSERT INTO public.med_history_updates VALUES (2, 29, '2026-02-03 10:20:00-07', 'Healthy, no concerns: Routine physical exam');
INSERT INTO public.med_history_updates VALUES (11, 30, '2026-02-10 11:50:00-07', 'Mild exercise-induced asthma: Spirometry performed');
INSERT INTO public.med_history_updates VALUES (17, 31, '2026-02-12 15:50:00-07', 'Mild gastroenteritis: Dietary review; fluids advised');
INSERT INTO public.med_history_updates VALUES (15, 32, '2026-02-19 14:50:00-07', 'Elevated LDL cholesterol: Elevated LDL noted; diet counselling');
INSERT INTO public.med_history_updates VALUES (4, 33, '2026-02-24 10:35:00-07', 'Mild back strain: Stretching and heat therapy advised');
INSERT INTO public.med_history_updates VALUES (6, 34, '2026-02-24 10:50:00-07', 'Elevated blood pressure: Home monitoring started');
INSERT INTO public.med_history_updates VALUES (18, 35, '2026-02-26 09:20:00-07', 'Mild asthma: Inhaler technique taught');
INSERT INTO public.med_history_updates VALUES (1, 36, '2026-03-03 11:20:00-07', 'Rotator cuff strain: Exercises reviewed; avoid overhead lifting');
INSERT INTO public.med_history_updates VALUES (16, 37, '2026-03-05 09:50:00-07', 'Early otitis media: Ear exam; watchful waiting');
INSERT INTO public.med_history_updates VALUES (3, 38, '2026-03-10 09:50:00-06', 'Fatigue, cause under investigation: Blood work ordered');
INSERT INTO public.med_history_updates VALUES (13, 39, '2026-03-12 09:50:00-06', 'Healthy, no concerns: Routine physical exam');
INSERT INTO public.med_history_updates VALUES (2, 40, '2026-03-17 15:50:00-06', 'Gastroesophageal reflux: Dietary changes; antacid recommended');
INSERT INTO public.med_history_updates VALUES (16, 41, '2026-03-19 10:20:00-06', 'Otitis media: Antibiotics prescribed');
INSERT INTO public.med_history_updates VALUES (10, 42, '2026-03-24 14:50:00-06', 'Minor laceration: Wound cleaned and dressed; tetanus status confirmed');
INSERT INTO public.med_history_updates VALUES (15, 43, '2026-04-02 14:20:00-06', 'Elevated LDL cholesterol: Dietary changes reviewed');
INSERT INTO public.med_history_updates VALUES (6, 44, '2026-04-07 10:20:00-06', 'Stage 1 hypertension: Lifestyle counselling; sodium reduction');
INSERT INTO public.med_history_updates VALUES (8, 45, '2026-04-08 10:20:00-06', 'Acute sinusitis: Saline rinse; decongestant advised');
INSERT INTO public.med_history_updates VALUES (4, 46, '2026-04-14 11:05:00-06', 'Recurrent lumbar strain: Sports medicine assessment; core exercises');
INSERT INTO public.med_history_updates VALUES (18, 47, '2026-04-16 09:50:00-06', 'Asthma exacerbation: Nebulizer treatment in clinic');
INSERT INTO public.med_history_updates VALUES (1, 48, '2026-04-21 14:50:00-06', 'Immunization update: Hepatitis A vaccine administered');
INSERT INTO public.med_history_updates VALUES (20, 49, '2026-04-28 10:50:00-06', 'Healthy, on track: Growth and development assessment');
INSERT INTO public.med_history_updates VALUES (2, 50, '2026-05-05 10:50:00-06', 'Gastroesophageal reflux disease: Proton pump inhibitor prescribed');
INSERT INTO public.med_history_updates VALUES (18, 51, '2026-05-07 09:20:00-06', 'Mild persistent asthma: Controller inhaler started');
INSERT INTO public.med_history_updates VALUES (11, 52, '2026-05-12 11:20:00-06', 'Exercise-induced asthma: Reliever inhaler prescribed');
INSERT INTO public.med_history_updates VALUES (15, 53, '2026-05-14 15:05:00-06', 'Screening, results pending: Fasting glucose and HbA1c ordered');
INSERT INTO public.med_history_updates VALUES (6, 54, '2026-05-19 11:50:00-06', 'Mild hypertension: Home readings reviewed');
INSERT INTO public.med_history_updates VALUES (4, 55, '2026-05-26 13:50:00-06', 'Lumbar strain, slow recovery: Physiotherapy plan reviewed');
INSERT INTO public.med_history_updates VALUES (14, 56, '2026-05-27 16:20:00-06', 'Mild acne vulgaris: Topical treatment prescribed');
INSERT INTO public.med_history_updates VALUES (16, 57, '2026-05-28 15:50:00-06', 'Healthy, on track: Growth and development assessment');
INSERT INTO public.med_history_updates VALUES (17, 58, '2026-06-04 11:20:00-06', 'Healthy, on track: Growth and development assessment');
INSERT INTO public.med_history_updates VALUES (1, 59, '2026-06-09 12:05:00-06', 'Tension-type headache: Neurological exam; headache diary started');
INSERT INTO public.med_history_updates VALUES (15, 60, '2026-06-11 14:50:00-06', 'Normal glucose levels: Results reviewed; glucose normal');
INSERT INTO public.med_history_updates VALUES (7, 61, '2026-06-17 09:20:00-06', 'Immunization update: Hepatitis A and typhoid vaccines administered');
INSERT INTO public.med_history_updates VALUES (2, 62, '2026-06-23 14:20:00-06', 'GERD, well controlled: Symptoms reviewed; endoscopy not required');
INSERT INTO public.med_history_updates VALUES (18, 63, '2026-06-25 10:05:00-06', 'Mild persistent asthma: Symptoms well controlled');
INSERT INTO public.med_history_updates VALUES (6, 64, '2026-06-30 15:50:00-06', 'Routine screening: Lab panel ordered');
INSERT INTO public.med_history_updates VALUES (15, 65, '2026-07-16 14:35:00-06', 'Borderline high cholesterol: Repeat lipid panel ordered');
INSERT INTO public.med_history_updates VALUES (4, 66, '2026-08-19 15:35:00-06', 'Lumbar strain, improving: Exercise plan adjusted');
INSERT INTO public.med_history_updates VALUES (2, 67, '2026-08-25 16:50:00-06', 'Hand eczema: Topical cream prescribed');
INSERT INTO public.med_history_updates VALUES (6, 68, '2026-08-28 10:50:00-06', 'Mild hypertension: Home readings reviewed');
INSERT INTO public.med_history_updates VALUES (16, 69, '2026-09-02 16:20:00-06', 'Otitis media, resolved: Ear exam; infection cleared');
INSERT INTO public.med_history_updates VALUES (6, 70, '2026-09-09 09:50:00-06', 'Mild hypertension: Medication options discussed');
INSERT INTO public.med_history_updates VALUES (11, 71, '2026-09-21 15:20:00-06', 'Fatigue, thyroid normal: Results reviewed; within normal range');
INSERT INTO public.med_history_updates VALUES (3, 72, '2026-09-22 10:05:00-06', 'Iron deficiency improving: Repeat blood work reviewed');
INSERT INTO public.med_history_updates VALUES (15, 73, '2026-09-22 14:20:00-06', 'Borderline high cholesterol, improving: Lipid panel improved; continue plan');
INSERT INTO public.med_history_updates VALUES (5, 74, '2026-09-23 14:20:00-06', 'Contact dermatitis, resolved: Rash resolved; cream discontinued');
INSERT INTO public.med_history_updates VALUES (9, 75, '2026-09-23 16:35:00-06', 'Migraine without aura, improving: Headache diary reviewed; medication continued');
INSERT INTO public.med_history_updates VALUES (6, 76, '2026-09-24 10:20:00-06', 'Hypertension, improving: Readings reviewed');
INSERT INTO public.med_history_updates VALUES (18, 77, '2026-09-24 16:35:00-06', 'Mild persistent asthma, stable: Dose reviewed after August adjustment');
INSERT INTO public.med_history_updates VALUES (1, 78, '2026-09-25 10:50:00-06', 'Vitamin D level improving: Repeat lab results reviewed');
INSERT INTO public.med_history_updates VALUES (12, 79, '2026-09-25 14:50:00-06', 'Ankle sprain, healed: Ankle strengthening exercises reviewed');
INSERT INTO public.med_history_updates VALUES (4, 80, '2026-09-28 10:20:00-06', 'Lumbar strain, resolved: Discharged from active treatment');


--
-- TOC entry 3596 (class 0 OID 25587)
-- Dependencies: 229
-- Data for Name: medical_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (1, 11, 72, 65.4, '118/76', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (2, 12, 78, 82.1, '128/84', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (3, 13, 68, 70.3, '110/70', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (4, 14, 75, 88.6, '124/80', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (5, 15, 70, 61.2, '112/72', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (6, 16, 82, 95.0, '142/92', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (7, 17, 66, 58.8, '108/68', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (8, 18, 74, 76.5, '120/78', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (9, 19, 71, 63.0, '116/74', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (10, 20, 69, 80.2, '122/80', 'INACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (11, 21, 77, 67.9, '114/72', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (12, 22, 73, 84.7, '126/82', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (13, 23, 65, 59.5, '110/68', 'ARCHIVED');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (14, 24, 80, 72.4, '118/76', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (15, 25, 76, 78.9, '138/88', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (16, 26, 90, 24.5, '95/60', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (17, 27, 92, 20.1, '92/58', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (18, 28, 88, 26.3, '98/62', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (19, 29, 86, 32.8, '102/64', 'ACTIVE');
INSERT INTO public.medical_history OVERRIDING SYSTEM VALUE VALUES (20, 30, 94, 18.7, '90/56', 'ACTIVE');


--
-- TOC entry 3590 (class 0 OID 25526)
-- Dependencies: 223
-- Data for Name: parent_guardian; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.parent_guardian VALUES (11, 26);
INSERT INTO public.parent_guardian VALUES (12, 27);
INSERT INTO public.parent_guardian VALUES (13, 28);
INSERT INTO public.parent_guardian VALUES (14, 29);
INSERT INTO public.parent_guardian VALUES (15, 30);


--
-- TOC entry 3589 (class 0 OID 25512)
-- Dependencies: 222
-- Data for Name: patient; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.patient VALUES (11, '284519037');
INSERT INTO public.patient VALUES (12, '391728465');
INSERT INTO public.patient VALUES (13, '517264830');
INSERT INTO public.patient VALUES (14, '602938175');
INSERT INTO public.patient VALUES (15, '748193526');
INSERT INTO public.patient VALUES (16, '835027461');
INSERT INTO public.patient VALUES (17, '926481350');
INSERT INTO public.patient VALUES (18, '173650982');
INSERT INTO public.patient VALUES (19, '264907318');
INSERT INTO public.patient VALUES (20, '359182746');
INSERT INTO public.patient VALUES (21, '481576209');
INSERT INTO public.patient VALUES (22, '570293841');
INSERT INTO public.patient VALUES (23, '693814072');
INSERT INTO public.patient VALUES (24, '718406593');
INSERT INTO public.patient VALUES (25, '829351604');
INSERT INTO public.patient VALUES (26, '936720158');
INSERT INTO public.patient VALUES (27, '147593620');
INSERT INTO public.patient VALUES (28, '258604931');
INSERT INTO public.patient VALUES (29, '369715042');
INSERT INTO public.patient VALUES (30, '470826153');


--
-- TOC entry 3603 (class 0 OID 25677)
-- Dependencies: 236
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (1, 1, 120.00, 'VISA', '2026-08-04 09:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (2, 2, 105.00, 'DEBIT', '2026-08-04 11:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (3, 3, 78.50, 'MASTERCARD', '2026-08-05 09:35:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (4, 4, 90.00, 'CASH', '2026-08-05 12:05:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (5, 5, 110.00, 'VISA', '2026-08-06 13:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (6, 6, 50.00, 'DEBIT', '2026-08-07 10:20:00-06', 'Partial payment at time of visit');
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (7, 6, 45.00, 'CASH', '2026-08-21 12:00:00-06', 'Remaining balance paid');
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (8, 7, 115.00, 'MASTERCARD', '2026-08-10 14:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (9, 8, 75.00, 'DEBIT', '2026-08-11 10:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (10, 9, 180.00, 'VISA', '2026-08-12 16:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (11, 10, 95.00, 'CASH', '2026-08-13 10:05:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (12, 11, 100.00, 'MASTERCARD', '2026-08-14 11:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (13, 12, 97.50, 'DEBIT', '2026-08-17 14:35:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (14, 13, 70.00, 'VISA', '2026-08-18 09:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (15, 14, 95.00, 'CASH', '2026-08-19 11:35:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (16, 15, 50.00, 'DEBIT', '2026-08-20 15:05:00-06', 'Partial payment; balance outstanding');
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (17, 16, 97.00, 'VISA', '2026-08-21 09:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (18, 17, 110.00, 'MASTERCARD', '2026-08-24 10:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (19, 18, 105.00, 'DEBIT', '2026-08-25 10:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (20, 19, 170.00, 'VISA', '2026-08-26 12:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (21, 20, 105.00, 'CASH', '2026-09-01 10:05:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (22, 22, 60.00, 'DEBIT', '2026-09-15 11:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (23, 23, 85.00, 'VISA', '2026-01-08 09:20:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (24, 24, 75.00, 'DEBIT', '2026-01-13 09:50:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (25, 25, 72.50, 'MASTERCARD', '2026-01-15 14:20:00-07', 'Partial payment at time of visit');
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (26, 25, 72.50, 'DEBIT', '2026-01-29 14:20:00-07', 'Remaining balance paid');
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (27, 26, 75.00, 'CASH', '2026-01-20 09:20:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (28, 27, 97.00, 'VISA', '2026-01-22 09:35:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (29, 28, 120.00, 'DEBIT', '2026-01-27 10:50:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (30, 29, 75.00, 'MASTERCARD', '2026-02-03 10:20:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (31, 30, 130.00, 'CASH', '2026-02-10 11:50:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (32, 31, 85.00, 'VISA', '2026-02-12 15:50:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (33, 32, 60.00, 'DEBIT', '2026-02-19 14:50:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (34, 33, 75.00, 'MASTERCARD', '2026-02-24 10:35:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (35, 34, 60.00, 'CASH', '2026-02-24 10:50:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (36, 35, 65.00, 'VISA', '2026-02-26 09:20:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (37, 36, 75.00, 'DEBIT', '2026-03-03 11:20:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (38, 37, 85.00, 'MASTERCARD', '2026-03-05 09:50:00-07', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (39, 38, 100.00, 'CASH', '2026-03-10 09:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (40, 39, 75.00, 'VISA', '2026-03-12 09:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (41, 40, 75.00, 'DEBIT', '2026-03-17 15:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (42, 41, 77.00, 'MASTERCARD', '2026-03-19 10:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (43, 42, 90.00, 'CASH', '2026-03-24 14:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (44, 43, 60.00, 'VISA', '2026-04-02 14:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (45, 44, 60.00, 'DEBIT', '2026-04-07 10:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (46, 45, 75.00, 'MASTERCARD', '2026-04-08 10:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (47, 46, 100.00, 'CASH', '2026-04-14 11:05:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (48, 47, 57.50, 'VISA', '2026-04-16 09:50:00-06', 'Partial payment; balance outstanding');
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (49, 48, 160.00, 'DEBIT', '2026-04-21 14:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (50, 49, 85.00, 'MASTERCARD', '2026-04-28 10:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (51, 50, 90.00, 'CASH', '2026-05-05 10:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (52, 51, 77.00, 'VISA', '2026-05-07 09:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (53, 52, 90.00, 'DEBIT', '2026-05-12 11:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (54, 53, 100.00, 'MASTERCARD', '2026-05-14 15:05:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (55, 54, 30.00, 'CASH', '2026-05-19 11:50:00-06', 'Partial payment; balance outstanding');
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (56, 55, 37.50, 'VISA', '2026-05-26 13:50:00-06', 'Partial payment; balance outstanding');
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (57, 56, 140.00, 'DEBIT', '2026-05-27 16:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (58, 57, 85.00, 'MASTERCARD', '2026-05-28 15:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (59, 58, 85.00, 'CASH', '2026-06-04 11:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (60, 59, 150.00, 'VISA', '2026-06-09 12:05:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (61, 60, 60.00, 'DEBIT', '2026-06-11 14:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (62, 61, 195.00, 'MASTERCARD', '2026-06-17 09:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (63, 62, 75.00, 'CASH', '2026-06-23 14:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (64, 63, 65.00, 'VISA', '2026-06-25 10:05:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (65, 64, 100.00, 'DEBIT', '2026-06-30 15:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (66, 65, 85.00, 'MASTERCARD', '2026-07-16 14:35:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (67, 66, 60.00, 'CASH', '2026-08-19 15:35:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (68, 67, 105.00, 'VISA', '2026-08-25 16:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (69, 68, 60.00, 'DEBIT', '2026-08-28 10:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (70, 69, 65.00, 'MASTERCARD', '2026-09-02 16:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (71, 70, 60.00, 'CASH', '2026-09-09 09:50:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (72, 71, 60.00, 'VISA', '2026-09-21 15:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (73, 72, 60.00, 'DEBIT', '2026-09-22 10:05:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (74, 73, 60.00, 'MASTERCARD', '2026-09-22 14:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (75, 74, 75.00, 'CASH', '2026-09-23 14:20:00-06', NULL);
INSERT INTO public.payment OVERRIDING SYSTEM VALUE VALUES (76, 75, 100.00, 'VISA', '2026-09-23 16:35:00-06', NULL);


--
-- TOC entry 3587 (class 0 OID 25485)
-- Dependencies: 220
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (1, 'Amara', 'Okafor', 'amara.okafor@example.com', '403-555-0101');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (2, 'Liam', 'Chen', 'liam.chen@example.com', '403-555-0102');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (3, 'Priya', 'Sharma', 'priya.sharma@example.com', '403-555-0103');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (4, 'Daniel', 'Tremblay', 'daniel.tremblay@example.com', '403-555-0104');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (5, 'Sofia', 'Rossi', 'sofia.rossi@example.com', '403-555-0105');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (6, 'Marcus', 'Johnson', 'marcus.johnson@example.com', '403-555-0106');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (7, 'Hannah', 'Kowalski', 'hannah.kowalski@example.com', '403-555-0107');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (8, 'Omar', 'Haddad', 'omar.haddad@example.com', '403-555-0108');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (9, 'Emily', 'Nguyen', 'emily.nguyen@example.com', '403-555-0109');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (10, 'Robert', 'MacDonald', 'robert.macdonald@example.com', '403-555-0110');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (11, 'Olivia', 'Bennett', 'olivia.bennett@example.com', '403-555-0111');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (12, 'Noah', 'Campbell', 'noah.campbell@example.com', '403-555-0112');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (13, 'Ava', 'Singh', 'ava.singh@example.com', '403-555-0113');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (14, 'Ethan', 'Roy', 'ethan.roy@example.com', '403-555-0114');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (15, 'Isabella', 'Martin', 'isabella.martin@example.com', '403-555-0115');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (16, 'Lucas', 'Fraser', 'lucas.fraser@example.com', '403-555-0116');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (17, 'Mia', 'Gagnon', 'mia.gagnon@example.com', '403-555-0117');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (18, 'Benjamin', 'Wong', NULL, '403-555-0118');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (19, 'Charlotte', 'Dubois', 'charlotte.dubois@example.com', '403-555-0119');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (20, 'William', 'Murray', 'william.murray@example.com', '403-555-0120');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (21, 'Amelia', 'Patel', 'amelia.patel@example.com', '403-555-0121');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (22, 'James', 'Sutherland', 'james.sutherland@example.com', NULL);
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (23, 'Harper', 'Stewart', 'harper.stewart@example.com', '403-555-0123');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (24, 'Henry', 'Kim', 'henry.kim@example.com', '403-555-0124');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (25, 'Evelyn', 'Clarke', 'evelyn.clarke@example.com', '403-555-0125');
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (26, 'Jack', 'Bennett', NULL, NULL);
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (27, 'Emma', 'Campbell', NULL, NULL);
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (28, 'Leo', 'Singh', NULL, NULL);
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (29, 'Zoe', 'Roy', NULL, NULL);
INSERT INTO public.person OVERRIDING SYSTEM VALUE VALUES (30, 'Maya', 'Martin', NULL, NULL);


--
-- TOC entry 3594 (class 0 OID 25570)
-- Dependencies: 227
-- Data for Name: visit; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (1, 1, 'Routine physical exam; lab requisition issued', 'No acute concerns', 'Follow-up in 4 weeks to review lab results');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (2, 2, 'Chest exam; cough suppressant prescribed', 'Acute bronchitis', 'Rest and fluids advised');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (3, 3, 'Blood work reviewed; dietary counselling', 'Mild iron deficiency', 'Iron supplement started');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (4, 4, 'Physiotherapy referral; anti-inflammatory prescribed', 'Lumbar strain', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (5, 5, 'Topical corticosteroid cream prescribed', 'Contact dermatitis', 'Avoid suspected irritant');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (6, 6, 'Blood pressure monitoring; lifestyle counselling', 'Mild hypertension', 'Recheck in 3 to 4 weeks');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (7, 7, 'Knee exam; physiotherapy referral', 'Patellofemoral pain syndrome', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (8, 8, 'Antihistamine prescribed', 'Seasonal allergic rhinitis', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (9, 9, 'Migraine medication prescribed; headache diary started', 'Migraine without aura', 'Bring headache diary to next visit');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (10, 10, 'Routine physical exam', 'Healthy, no concerns', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (11, 11, 'Sleep hygiene counselling; thyroid panel ordered', 'Fatigue, cause under investigation', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (12, 12, 'Ankle wrapped; RICE protocol explained', 'Grade 1 ankle sprain', 'Return if swelling worsens');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (13, 13, 'Tetanus and influenza vaccines administered', 'Immunization update', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (14, 14, 'Throat exam; rapid strep test negative', 'Viral pharyngitis', 'Fluids and rest');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (15, 15, 'Lipid panel reviewed; diet counselling', 'Borderline high cholesterol', 'Repeat panel in 3 months');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (16, 16, 'Antibiotic ear drops prescribed', 'Otitis media', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (17, 17, 'School-entry vaccinations administered', 'Immunization update', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (18, 18, 'Inhaler technique reviewed; controller dose adjusted', 'Mild persistent asthma', 'Review again in 3 months');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (19, 19, 'Wrist X-ray; splint applied', 'Wrist sprain, no fracture', 'Splint for 7 to 10 days');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (20, 20, 'Rapid strep test positive; antibiotics prescribed', 'Strep throat', 'Stay home until 24h after first dose');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (21, 21, 'Lab results reviewed', 'Mild vitamin D deficiency', 'Vitamin D supplement started');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (22, 22, 'Physiotherapy progress reviewed', 'Lumbar strain, improving', 'Continue exercises');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (23, 31, 'Supportive care', 'Common cold', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (24, 32, 'Symptomatic treatment; fluids and rest', 'Upper respiratory infection', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (25, 33, 'ECG normal; blood work ordered', 'Non-cardiac chest discomfort', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (26, 34, 'Rest, fluids and fever control', 'Influenza-like illness', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (27, 35, 'Reliever inhaler prescribed', 'Asthma, newly diagnosed', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (28, 36, 'Blood pressure measured; ECG performed', 'Elevated blood pressure', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (29, 37, 'Routine physical exam', 'Healthy, no concerns', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (30, 38, 'Spirometry performed', 'Mild exercise-induced asthma', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (31, 39, 'Dietary review; fluids advised', 'Mild gastroenteritis', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (32, 40, 'Elevated LDL noted; diet counselling', 'Elevated LDL cholesterol', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (33, 41, 'Stretching and heat therapy advised', 'Mild back strain', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (34, 42, 'Home monitoring started', 'Elevated blood pressure', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (35, 43, 'Inhaler technique taught', 'Mild asthma', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (36, 44, 'Exercises reviewed; avoid overhead lifting', 'Rotator cuff strain', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (37, 45, 'Ear exam; watchful waiting', 'Early otitis media', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (38, 46, 'Blood work ordered', 'Fatigue, cause under investigation', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (39, 47, 'Routine physical exam', 'Healthy, no concerns', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (40, 48, 'Dietary changes; antacid recommended', 'Gastroesophageal reflux', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (41, 49, 'Antibiotics prescribed', 'Otitis media', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (42, 50, 'Wound cleaned and dressed; tetanus status confirmed', 'Minor laceration', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (43, 51, 'Dietary changes reviewed', 'Elevated LDL cholesterol', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (44, 52, 'Lifestyle counselling; sodium reduction', 'Stage 1 hypertension', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (45, 53, 'Saline rinse; decongestant advised', 'Acute sinusitis', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (46, 54, 'Sports medicine assessment; core exercises', 'Recurrent lumbar strain', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (47, 55, 'Nebulizer treatment in clinic', 'Asthma exacerbation', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (48, 56, 'Hepatitis A vaccine administered', 'Immunization update', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (49, 57, 'Growth and development assessment', 'Healthy, on track', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (50, 58, 'Proton pump inhibitor prescribed', 'Gastroesophageal reflux disease', 'Review in 8 weeks');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (51, 59, 'Controller inhaler started', 'Mild persistent asthma', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (52, 60, 'Reliever inhaler prescribed', 'Exercise-induced asthma', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (53, 61, 'Fasting glucose and HbA1c ordered', 'Screening, results pending', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (54, 62, 'Home readings reviewed', 'Mild hypertension', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (55, 63, 'Physiotherapy plan reviewed', 'Lumbar strain, slow recovery', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (56, 64, 'Topical treatment prescribed', 'Mild acne vulgaris', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (57, 65, 'Growth and development assessment', 'Healthy, on track', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (58, 66, 'Growth and development assessment', 'Healthy, on track', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (59, 67, 'Neurological exam; headache diary started', 'Tension-type headache', 'Reduce screen time and improve hydration');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (60, 68, 'Results reviewed; glucose normal', 'Normal glucose levels', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (61, 69, 'Hepatitis A and typhoid vaccines administered', 'Immunization update', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (62, 70, 'Symptoms reviewed; endoscopy not required', 'GERD, well controlled', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (63, 71, 'Symptoms well controlled', 'Mild persistent asthma', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (64, 72, 'Lab panel ordered', 'Routine screening', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (65, 73, 'Repeat lipid panel ordered', 'Borderline high cholesterol', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (66, 74, 'Exercise plan adjusted', 'Lumbar strain, improving', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (67, 75, 'Topical cream prescribed', 'Hand eczema', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (68, 76, 'Home readings reviewed', 'Mild hypertension', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (69, 77, 'Ear exam; infection cleared', 'Otitis media, resolved', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (70, 78, 'Medication options discussed', 'Mild hypertension', 'Rebooked after missed Sep 2 visit');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (71, 79, 'Results reviewed; within normal range', 'Fatigue, thyroid normal', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (72, 80, 'Repeat blood work reviewed', 'Iron deficiency improving', 'Continue supplement until October visit');
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (73, 81, 'Lipid panel improved; continue plan', 'Borderline high cholesterol, improving', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (74, 82, 'Rash resolved; cream discontinued', 'Contact dermatitis, resolved', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (75, 83, 'Headache diary reviewed; medication continued', 'Migraine without aura, improving', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (76, 84, 'Readings reviewed', 'Hypertension, improving', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (77, 85, 'Dose reviewed after August adjustment', 'Mild persistent asthma, stable', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (78, 86, 'Repeat lab results reviewed', 'Vitamin D level improving', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (79, 87, 'Ankle strengthening exercises reviewed', 'Ankle sprain, healed', NULL);
INSERT INTO public.visit OVERRIDING SYSTEM VALUE VALUES (80, 88, 'Discharged from active treatment', 'Lumbar strain, resolved', 'Return if pain recurs');


--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 224
-- Name: appointment_appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_appointment_id_seq', 89, false);


--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 231
-- Name: bill_bill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bill_bill_id_seq', 81, false);


--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 233
-- Name: bill_lines_bill_line_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bill_lines_bill_line_id_seq', 120, true);


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 228
-- Name: medical_history_medical_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medical_history_medical_history_id_seq', 21, false);


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 235
-- Name: payment_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_payment_id_seq', 76, true);


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 219
-- Name: person_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.person_person_id_seq', 31, false);


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 226
-- Name: visit_visit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visit_visit_id_seq', 81, false);


--
-- TOC entry 3404 (class 2606 OID 25558)
-- Name: appointment pk_appointment_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT pk_appointment_id PRIMARY KEY (appointment_id);


--
-- TOC entry 3416 (class 2606 OID 25641)
-- Name: bill pk_bill_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT pk_bill_id PRIMARY KEY (bill_id);


--
-- TOC entry 3420 (class 2606 OID 25670)
-- Name: bill_lines pk_bill_line_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill_lines
    ADD CONSTRAINT pk_bill_line_id PRIMARY KEY (bill_line_id);


--
-- TOC entry 3394 (class 2606 OID 25504)
-- Name: doctor pk_doctor_person_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT pk_doctor_person_id PRIMARY KEY (person_id);


--
-- TOC entry 3414 (class 2606 OID 25616)
-- Name: med_history_updates pk_med_history_update_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.med_history_updates
    ADD CONSTRAINT pk_med_history_update_id PRIMARY KEY (medical_history_id, visit_id);


--
-- TOC entry 3410 (class 2606 OID 25598)
-- Name: medical_history pk_medical_history_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_history
    ADD CONSTRAINT pk_medical_history_id PRIMARY KEY (medical_history_id);


--
-- TOC entry 3402 (class 2606 OID 25532)
-- Name: parent_guardian pk_parent_guardian; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_guardian
    ADD CONSTRAINT pk_parent_guardian PRIMARY KEY (patient_id, person_id);


--
-- TOC entry 3398 (class 2606 OID 25518)
-- Name: patient pk_patient_person_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT pk_patient_person_id PRIMARY KEY (person_id);


--
-- TOC entry 3422 (class 2606 OID 25691)
-- Name: payment pk_payment; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT pk_payment PRIMARY KEY (payment_id);


--
-- TOC entry 3388 (class 2606 OID 25492)
-- Name: person pk_person_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT pk_person_id PRIMARY KEY (person_id);


--
-- TOC entry 3406 (class 2606 OID 25578)
-- Name: visit pk_visit_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT pk_visit_id PRIMARY KEY (visit_id);


--
-- TOC entry 3418 (class 2606 OID 25643)
-- Name: bill uq_bill_visit_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT uq_bill_visit_id UNIQUE (visit_id);


--
-- TOC entry 3400 (class 2606 OID 25520)
-- Name: patient uq_healthcare_number; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT uq_healthcare_number UNIQUE (healthcare_number);


--
-- TOC entry 3412 (class 2606 OID 25600)
-- Name: medical_history uq_med_history_patient_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_history
    ADD CONSTRAINT uq_med_history_patient_id UNIQUE (patient_id);


--
-- TOC entry 3396 (class 2606 OID 25506)
-- Name: doctor uq_minc_prac_number; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT uq_minc_prac_number UNIQUE (minc_number, prac_id);


--
-- TOC entry 3390 (class 2606 OID 25494)
-- Name: person uq_person_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT uq_person_email UNIQUE (email);


--
-- TOC entry 3392 (class 2606 OID 25496)
-- Name: person uq_person_phone; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT uq_person_phone UNIQUE (phone_number);


--
-- TOC entry 3408 (class 2606 OID 25580)
-- Name: visit uq_visit_appointment_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT uq_visit_appointment_id UNIQUE (appointment_id);


--
-- TOC entry 3427 (class 2606 OID 25564)
-- Name: appointment fk_appointment_doctor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT fk_appointment_doctor_id FOREIGN KEY (doctor_id) REFERENCES public.doctor(person_id);


--
-- TOC entry 3428 (class 2606 OID 25559)
-- Name: appointment fk_appointment_patient_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT fk_appointment_patient_id FOREIGN KEY (patient_id) REFERENCES public.patient(person_id);


--
-- TOC entry 3433 (class 2606 OID 25649)
-- Name: bill fk_bill_doctor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT fk_bill_doctor_id FOREIGN KEY (doctor_id) REFERENCES public.doctor(person_id);


--
-- TOC entry 3436 (class 2606 OID 25671)
-- Name: bill_lines fk_bill_line_bill_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill_lines
    ADD CONSTRAINT fk_bill_line_bill_id FOREIGN KEY (bill_id) REFERENCES public.bill(bill_id);


--
-- TOC entry 3434 (class 2606 OID 25654)
-- Name: bill fk_bill_patient_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT fk_bill_patient_id FOREIGN KEY (patient_id) REFERENCES public.patient(person_id);


--
-- TOC entry 3435 (class 2606 OID 25644)
-- Name: bill fk_bill_visit_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill
    ADD CONSTRAINT fk_bill_visit_id FOREIGN KEY (visit_id) REFERENCES public.visit(visit_id);


--
-- TOC entry 3423 (class 2606 OID 25507)
-- Name: doctor fk_doctor_person_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT fk_doctor_person_id FOREIGN KEY (person_id) REFERENCES public.person(person_id);


--
-- TOC entry 3425 (class 2606 OID 25533)
-- Name: parent_guardian fk_guardian_patient_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_guardian
    ADD CONSTRAINT fk_guardian_patient_id FOREIGN KEY (patient_id) REFERENCES public.patient(person_id);


--
-- TOC entry 3426 (class 2606 OID 25538)
-- Name: parent_guardian fk_guardian_person_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_guardian
    ADD CONSTRAINT fk_guardian_person_id FOREIGN KEY (person_id) REFERENCES public.person(person_id);


--
-- TOC entry 3431 (class 2606 OID 25617)
-- Name: med_history_updates fk_med_history_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.med_history_updates
    ADD CONSTRAINT fk_med_history_id FOREIGN KEY (medical_history_id) REFERENCES public.medical_history(medical_history_id);


--
-- TOC entry 3430 (class 2606 OID 25601)
-- Name: medical_history fk_med_history_patient_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_history
    ADD CONSTRAINT fk_med_history_patient_id FOREIGN KEY (patient_id) REFERENCES public.patient(person_id);


--
-- TOC entry 3432 (class 2606 OID 25622)
-- Name: med_history_updates fk_med_history_update_visit_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.med_history_updates
    ADD CONSTRAINT fk_med_history_update_visit_id FOREIGN KEY (visit_id) REFERENCES public.visit(visit_id);


--
-- TOC entry 3424 (class 2606 OID 25521)
-- Name: patient fk_patient_person_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patient
    ADD CONSTRAINT fk_patient_person_id FOREIGN KEY (person_id) REFERENCES public.person(person_id);


--
-- TOC entry 3437 (class 2606 OID 25692)
-- Name: payment fk_payment_bill_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT fk_payment_bill_id FOREIGN KEY (bill_id) REFERENCES public.bill(bill_id);


--
-- TOC entry 3429 (class 2606 OID 25581)
-- Name: visit fk_visit_appointment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visit
    ADD CONSTRAINT fk_visit_appointment_id FOREIGN KEY (appointment_id) REFERENCES public.appointment(appointment_id);


-- Completed on 2026-10-01 17:53:18 MDT

--
-- PostgreSQL database dump complete
--

\unrestrict YgY3CB3FA6phb4qx000G7Z0t0u4Q9bJcd5AEtshhzAj4I0D9RWpjCaEs75G3Ga9

