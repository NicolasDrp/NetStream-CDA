--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 16.0

-- Started on 2023-12-20 16:00:16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: NetStream
--


ALTER SCHEMA public OWNER TO "NetStream";

--
-- TOC entry 3386 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: NetStream
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 226 (class 1255 OID 16502)
-- Name: create_log(); Type: FUNCTION; Schema: public; Owner: NetStream
--

CREATE FUNCTION public.create_log() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
old_last VARCHAR(255);
new_last VARCHAR(255);
old_first VARCHAR(255);
new_first VARCHAR(255);
old_email VARCHAR(255);
new_email VARCHAR(255);
old_password VARCHAR(255);
new_password VARCHAR(255);
old_role VARCHAR(255);
new_role VARCHAR(255);

BEGIN old_last := OLD.lastname;
new_last := NEW.lastname;
old_first := OLD.firstname;
new_first := NEW.firstname;
old_email := OLD.email;
new_email := NEW.email;
old_password := OLD.password;
new_password := NEW.password;
old_role := OLD.role;
new_role := NEW.role;

-- Insert into Log table if there is a change in the value
IF old_last IS DISTINCT
FROM
    new_last THEN
INSERT INTO
    Public."Log" (id_user, name_value, old_value, new_value)
VALUES
    (NEW.id_user, 'user_lastname', old_last, new_last);
END IF;

IF old_first IS DISTINCT
FROM
    new_first THEN
INSERT INTO
    Public."Log" (id_user, name_value, old_value, new_value)
VALUES
    (NEW.id_user, 'user_firstname', old_first, new_first);
END IF;

IF old_email IS DISTINCT
FROM
    new_email THEN
INSERT INTO
    Public."Log" (id_user, name_value, old_value, new_value)
VALUES
    (NEW.id_user, 'email', old_email, new_email);
END IF;

IF old_password IS DISTINCT
FROM
    new_password THEN
INSERT INTO
    Public."Log" (id_user, name_value, old_value, new_value)
VALUES
    (NEW.id_user, 'password', old_password, new_password);
END IF;

IF old_role IS DISTINCT
FROM
    new_role THEN
INSERT INTO
    Public."Log" (id_user, name_value, old_value, new_value)
VALUES
    (NEW.id_user, 'role', old_role, new_role);
END IF;
RETURN NEW;
END;$$;


ALTER FUNCTION public.create_log() OWNER TO "NetStream";

--
-- TOC entry 235 (class 1255 OID 24604)
-- Name: movies_director(character varying, character varying); Type: FUNCTION; Schema: public; Owner: NetStream
--

CREATE FUNCTION public.movies_director(f character varying, l character varying) RETURNS TABLE(titre character varying)
    LANGUAGE sql
    AS $$
SELECT title 
FROM public."Movie" INNER JOIN public."Direct" on "Movie".id_movie = "Direct".id_movie 
WHERE "Direct".id_director = (SELECT id_director FROM public."Director" WHERE firstname = f AND lastname = l)
$$;


ALTER FUNCTION public.movies_director(f character varying, l character varying) OWNER TO "NetStream";

--
-- TOC entry 222 (class 1255 OID 16495)
-- Name: update_modified_at(); Type: FUNCTION; Schema: public; Owner: NetStream
--

CREATE FUNCTION public.update_modified_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_modified_at() OWNER TO "NetStream";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16414)
-- Name: Act; Type: TABLE; Schema: public; Owner: NetStream
--

CREATE TABLE public."Act" (
    id_movie integer NOT NULL,
    id_actor integer NOT NULL,
    role character varying(50) NOT NULL
);


ALTER TABLE public."Act" OWNER TO "NetStream";

--
-- TOC entry 212 (class 1259 OID 16394)
-- Name: Actor; Type: TABLE; Schema: public; Owner: NetStream
--

CREATE TABLE public."Actor" (
    id_actor integer NOT NULL,
    firstname character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    birthday date NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."Actor" OWNER TO "NetStream";

--
-- TOC entry 211 (class 1259 OID 16393)
-- Name: Actor_id_actor_seq; Type: SEQUENCE; Schema: public; Owner: NetStream
--

ALTER TABLE public."Actor" ALTER COLUMN id_actor ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Actor_id_actor_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 215 (class 1259 OID 16409)
-- Name: Direct; Type: TABLE; Schema: public; Owner: NetStream
--

CREATE TABLE public."Direct" (
    id_movie integer NOT NULL,
    id_director integer NOT NULL
);


ALTER TABLE public."Direct" OWNER TO "NetStream";

--
-- TOC entry 214 (class 1259 OID 16402)
-- Name: Director; Type: TABLE; Schema: public; Owner: NetStream
--

CREATE TABLE public."Director" (
    id_director integer NOT NULL,
    lastname character varying(50) NOT NULL,
    firstname character varying(50) NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."Director" OWNER TO "NetStream";

--
-- TOC entry 213 (class 1259 OID 16401)
-- Name: Director_id_directora_seq; Type: SEQUENCE; Schema: public; Owner: NetStream
--

ALTER TABLE public."Director" ALTER COLUMN id_director ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Director_id_directora_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 16433)
-- Name: Like; Type: TABLE; Schema: public; Owner: NetStream
--

CREATE TABLE public."Like" (
    id_movie integer NOT NULL,
    id_user integer NOT NULL
);


ALTER TABLE public."Like" OWNER TO "NetStream";

--
-- TOC entry 220 (class 1259 OID 16427)
-- Name: Log; Type: TABLE; Schema: public; Owner: NetStream
--

CREATE TABLE public."Log" (
    id_log integer NOT NULL,
    id_user integer NOT NULL,
    name_value character varying(15) NOT NULL,
    old_value character varying(100) NOT NULL,
    new_value character varying(100) NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."Log" OWNER TO "NetStream";

--
-- TOC entry 219 (class 1259 OID 16426)
-- Name: Log_id_log_seq; Type: SEQUENCE; Schema: public; Owner: NetStream
--

ALTER TABLE public."Log" ALTER COLUMN id_log ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Log_id_log_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 210 (class 1259 OID 16386)
-- Name: Movie; Type: TABLE; Schema: public; Owner: NetStream
--

CREATE TABLE public."Movie" (
    id_movie integer NOT NULL,
    title character varying(50) NOT NULL,
    duration integer NOT NULL,
    year integer NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."Movie" OWNER TO "NetStream";

--
-- TOC entry 209 (class 1259 OID 16385)
-- Name: Movie_id_movie_seq; Type: SEQUENCE; Schema: public; Owner: NetStream
--

ALTER TABLE public."Movie" ALTER COLUMN id_movie ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Movie_id_movie_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 16420)
-- Name: User; Type: TABLE; Schema: public; Owner: NetStream
--

CREATE TABLE public."User" (
    id_user integer NOT NULL,
    lastname character varying(50) NOT NULL,
    firstname character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    role character varying(15) NOT NULL,
    created_at timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."User" OWNER TO "NetStream";

--
-- TOC entry 217 (class 1259 OID 16419)
-- Name: User_id_user_seq; Type: SEQUENCE; Schema: public; Owner: NetStream
--

ALTER TABLE public."User" ALTER COLUMN id_user ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."User_id_user_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3375 (class 0 OID 16414)
-- Dependencies: 216
-- Data for Name: Act; Type: TABLE DATA; Schema: public; Owner: NetStream
--

COPY public."Act" (id_movie, id_actor, role) FROM stdin;
1	1	Lead
3	1	Supporting
3	2	Cameo
16	3	Lead
2	16	Supporting
\.


--
-- TOC entry 3371 (class 0 OID 16394)
-- Dependencies: 212
-- Data for Name: Actor; Type: TABLE DATA; Schema: public; Owner: NetStream
--

COPY public."Actor" (id_actor, firstname, lastname, birthday, created_at, updated_at) FROM stdin;
16	florian	poteaux	1947-05-15	2023-12-19 10:50:05	2023-12-19 10:51:18
17	florian	potaut	1947-05-15	2023-12-19 10:50:05	2023-12-19 10:51:18
15	florantino	poto	1947-05-15	2023-12-19 10:50:05	2023-12-19 11:18:21
19	Phlorient	Pauteau	2013-04-05	2023-12-19 14:39:13	2023-12-19 14:39:13
\.


--
-- TOC entry 3374 (class 0 OID 16409)
-- Dependencies: 215
-- Data for Name: Direct; Type: TABLE DATA; Schema: public; Owner: NetStream
--

COPY public."Direct" (id_movie, id_director) FROM stdin;
1	3
3	1
2	1
\.


--
-- TOC entry 3373 (class 0 OID 16402)
-- Dependencies: 214
-- Data for Name: Director; Type: TABLE DATA; Schema: public; Owner: NetStream
--

COPY public."Director" (id_director, lastname, firstname, created_at, updated_at) FROM stdin;
2	Tarantino	Quentin	2023-12-19 00:00:00	2023-12-19 00:00:00
3	Spielberg	Steven	2023-12-19 00:00:00	2023-12-19 00:00:00
1	Nolan	Chisto	2023-12-19 00:00:00	2023-12-19 11:21:18
\.


--
-- TOC entry 3380 (class 0 OID 16433)
-- Dependencies: 221
-- Data for Name: Like; Type: TABLE DATA; Schema: public; Owner: NetStream
--

COPY public."Like" (id_movie, id_user) FROM stdin;
1	1
1	2
2	3
3	1
3	2
\.


--
-- TOC entry 3379 (class 0 OID 16427)
-- Dependencies: 220
-- Data for Name: Log; Type: TABLE DATA; Schema: public; Owner: NetStream
--

COPY public."Log" (id_log, id_user, name_value, old_value, new_value, updated_at) FROM stdin;
1	1	user_firstname	John	Chisto	2023-12-19 13:00:46
2	1	user_lastname	Doe	Nonol	2023-12-19 13:01:13
3	1	user_lastname	Nonol	Nonoll	2023-12-19 13:01:31
4	1	user_firstname	Chisto	Chistoo	2023-12-19 13:01:31
\.


--
-- TOC entry 3369 (class 0 OID 16386)
-- Dependencies: 210
-- Data for Name: Movie; Type: TABLE DATA; Schema: public; Owner: NetStream
--

COPY public."Movie" (id_movie, title, duration, year, created_at, updated_at) FROM stdin;
1	Les Mystères de l Infini	120	2022	2023-12-19 00:00:00	2023-12-19 00:00:00
2	L Odyssée du Futur	105	2020	2023-12-19 00:00:00	2023-12-19 00:00:00
3	Éclats de Lumière	150	2019	2023-12-19 00:00:00	2023-12-19 00:00:00
4	Nouveau Titre	123	2014	2023-12-19 14:37:00	2023-12-19 14:37:00
\.


--
-- TOC entry 3377 (class 0 OID 16420)
-- Dependencies: 218
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: NetStream
--

COPY public."User" (id_user, lastname, firstname, email, password, role, created_at) FROM stdin;
2	Smith	Jane	jane.smith@example.com	hashed_password_2	user	2023-12-19 00:00:00
3	Johnson	Robert	robert.johnson@example.com	hashed_password_3	user	2023-12-19 00:00:00
1	Nonoll	Chistoo	john.doe@example.com	hashed_password_1	admin	2023-12-19 00:00:00
\.


--
-- TOC entry 3396 (class 0 OID 0)
-- Dependencies: 211
-- Name: Actor_id_actor_seq; Type: SEQUENCE SET; Schema: public; Owner: NetStream
--

SELECT pg_catalog.setval('public."Actor_id_actor_seq"', 19, true);


--
-- TOC entry 3397 (class 0 OID 0)
-- Dependencies: 213
-- Name: Director_id_directora_seq; Type: SEQUENCE SET; Schema: public; Owner: NetStream
--

SELECT pg_catalog.setval('public."Director_id_directora_seq"', 3, true);


--
-- TOC entry 3398 (class 0 OID 0)
-- Dependencies: 219
-- Name: Log_id_log_seq; Type: SEQUENCE SET; Schema: public; Owner: NetStream
--

SELECT pg_catalog.setval('public."Log_id_log_seq"', 4, true);


--
-- TOC entry 3399 (class 0 OID 0)
-- Dependencies: 209
-- Name: Movie_id_movie_seq; Type: SEQUENCE SET; Schema: public; Owner: NetStream
--

SELECT pg_catalog.setval('public."Movie_id_movie_seq"', 4, true);


--
-- TOC entry 3400 (class 0 OID 0)
-- Dependencies: 217
-- Name: User_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: NetStream
--

SELECT pg_catalog.setval('public."User_id_user_seq"', 3, true);


--
-- TOC entry 3218 (class 2606 OID 16418)
-- Name: Act Act_pkey; Type: CONSTRAINT; Schema: public; Owner: NetStream
--

ALTER TABLE ONLY public."Act"
    ADD CONSTRAINT "Act_pkey" PRIMARY KEY (id_movie, id_actor);


--
-- TOC entry 3212 (class 2606 OID 16400)
-- Name: Actor Actor_pkey; Type: CONSTRAINT; Schema: public; Owner: NetStream
--

ALTER TABLE ONLY public."Actor"
    ADD CONSTRAINT "Actor_pkey" PRIMARY KEY (id_actor);


--
-- TOC entry 3216 (class 2606 OID 16413)
-- Name: Direct Direct_pkey; Type: CONSTRAINT; Schema: public; Owner: NetStream
--

ALTER TABLE ONLY public."Direct"
    ADD CONSTRAINT "Direct_pkey" PRIMARY KEY (id_movie, id_director);


--
-- TOC entry 3214 (class 2606 OID 16408)
-- Name: Director Director_pkey; Type: CONSTRAINT; Schema: public; Owner: NetStream
--

ALTER TABLE ONLY public."Director"
    ADD CONSTRAINT "Director_pkey" PRIMARY KEY (id_director);


--
-- TOC entry 3224 (class 2606 OID 16437)
-- Name: Like Like_pkey; Type: CONSTRAINT; Schema: public; Owner: NetStream
--

ALTER TABLE ONLY public."Like"
    ADD CONSTRAINT "Like_pkey" PRIMARY KEY (id_movie, id_user);


--
-- TOC entry 3222 (class 2606 OID 16432)
-- Name: Log Log_pkey; Type: CONSTRAINT; Schema: public; Owner: NetStream
--

ALTER TABLE ONLY public."Log"
    ADD CONSTRAINT "Log_pkey" PRIMARY KEY (id_log);


--
-- TOC entry 3210 (class 2606 OID 16392)
-- Name: Movie Movie_pkey; Type: CONSTRAINT; Schema: public; Owner: NetStream
--

ALTER TABLE ONLY public."Movie"
    ADD CONSTRAINT "Movie_pkey" PRIMARY KEY (id_movie);


--
-- TOC entry 3220 (class 2606 OID 16425)
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: NetStream
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id_user);


--
-- TOC entry 3228 (class 2620 OID 16503)
-- Name: User create_log_trigger; Type: TRIGGER; Schema: public; Owner: NetStream
--

CREATE TRIGGER create_log_trigger AFTER UPDATE ON public."User" FOR EACH ROW EXECUTE FUNCTION public.create_log();


--
-- TOC entry 3226 (class 2620 OID 16500)
-- Name: Actor trigger_update_modified_at; Type: TRIGGER; Schema: public; Owner: NetStream
--

CREATE TRIGGER trigger_update_modified_at BEFORE UPDATE ON public."Actor" FOR EACH ROW EXECUTE FUNCTION public.update_modified_at();


--
-- TOC entry 3227 (class 2620 OID 16501)
-- Name: Director trigger_update_modified_at; Type: TRIGGER; Schema: public; Owner: NetStream
--

CREATE TRIGGER trigger_update_modified_at BEFORE UPDATE ON public."Director" FOR EACH ROW EXECUTE FUNCTION public.update_modified_at();


--
-- TOC entry 3225 (class 2620 OID 16499)
-- Name: Movie trigger_update_modified_at; Type: TRIGGER; Schema: public; Owner: NetStream
--

CREATE TRIGGER trigger_update_modified_at AFTER UPDATE ON public."Movie" FOR EACH ROW EXECUTE FUNCTION public.update_modified_at();


--
-- TOC entry 3387 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: NetStream
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;

CREATE ROLE "Client" WITH LOGIN PASSWORD 'MDPclient';


--
-- TOC entry 3388 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE "Act"; Type: ACL; Schema: public; Owner: NetStream
--

GRANT SELECT ON TABLE public."Act" TO "Client";


--
-- TOC entry 3389 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE "Actor"; Type: ACL; Schema: public; Owner: NetStream
--

GRANT SELECT ON TABLE public."Actor" TO "Client";


--
-- TOC entry 3390 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE "Direct"; Type: ACL; Schema: public; Owner: NetStream
--

GRANT SELECT ON TABLE public."Direct" TO "Client";


--
-- TOC entry 3391 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE "Director"; Type: ACL; Schema: public; Owner: NetStream
--

GRANT SELECT ON TABLE public."Director" TO "Client";


--
-- TOC entry 3392 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE "Like"; Type: ACL; Schema: public; Owner: NetStream
--

GRANT SELECT ON TABLE public."Like" TO "Client";


--
-- TOC entry 3393 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE "Log"; Type: ACL; Schema: public; Owner: NetStream
--

GRANT SELECT ON TABLE public."Log" TO "Client";


--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE "Movie"; Type: ACL; Schema: public; Owner: NetStream
--

GRANT SELECT ON TABLE public."Movie" TO "Client";


--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE "User"; Type: ACL; Schema: public; Owner: NetStream
--

GRANT SELECT ON TABLE public."User" TO "Client";


-- Completed on 2023-12-20 16:00:17

--
-- PostgreSQL database dump complete
--

