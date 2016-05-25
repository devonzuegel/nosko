--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: articles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE articles (
    id integer NOT NULL,
    user_id integer,
    permalink_id integer NOT NULL,
    title character varying,
    source_url character varying,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locked boolean DEFAULT false,
    visibility integer DEFAULT 0 NOT NULL
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE articles_id_seq OWNED BY articles.id;


--
-- Name: evernote_accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE evernote_accounts (
    id integer NOT NULL,
    auth_token character varying,
    last_accessed_at timestamp without time zone,
    user_id integer
);


--
-- Name: evernote_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE evernote_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evernote_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE evernote_accounts_id_seq OWNED BY evernote_accounts.id;


--
-- Name: evernote_extractors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE evernote_extractors (
    id integer NOT NULL,
    guid character varying,
    last_accessed_at timestamp without time zone,
    evernote_account_id integer,
    article_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: evernote_extractors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE evernote_extractors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evernote_extractors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE evernote_extractors_id_seq OWNED BY evernote_extractors.id;


--
-- Name: followings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE followings (
    id integer NOT NULL,
    leader_id integer NOT NULL,
    follower_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: followings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE followings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: followings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE followings_id_seq OWNED BY followings.id;


--
-- Name: highlights; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE highlights (
    id integer NOT NULL,
    article_id integer NOT NULL,
    permalink_id integer NOT NULL,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: highlights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE highlights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: highlights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE highlights_id_seq OWNED BY highlights.id;


--
-- Name: permalinks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE permalinks (
    id integer NOT NULL,
    path text NOT NULL,
    publicized boolean DEFAULT false,
    trashed boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: permalinks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE permalinks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permalinks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE permalinks_id_seq OWNED BY permalinks.id;


--
-- Name: que_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE que_jobs (
    priority smallint DEFAULT 100 NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL,
    job_id bigint NOT NULL,
    job_class text NOT NULL,
    args json DEFAULT '[]'::json NOT NULL,
    error_count integer DEFAULT 0 NOT NULL,
    last_error text,
    queue text DEFAULT ''::text NOT NULL
);


--
-- Name: TABLE que_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE que_jobs IS '3';


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE que_jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE que_jobs_job_id_seq OWNED BY que_jobs.job_id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sharings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sharings (
    id integer NOT NULL,
    share_by_default integer DEFAULT 0,
    reminders_frequency integer DEFAULT 0,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sharings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sharings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sharings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sharings_id_seq OWNED BY sharings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying,
    provider character varying,
    uid character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles ALTER COLUMN id SET DEFAULT nextval('articles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY evernote_accounts ALTER COLUMN id SET DEFAULT nextval('evernote_accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY evernote_extractors ALTER COLUMN id SET DEFAULT nextval('evernote_extractors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY followings ALTER COLUMN id SET DEFAULT nextval('followings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY highlights ALTER COLUMN id SET DEFAULT nextval('highlights_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY permalinks ALTER COLUMN id SET DEFAULT nextval('permalinks_id_seq'::regclass);


--
-- Name: job_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_jobs ALTER COLUMN job_id SET DEFAULT nextval('que_jobs_job_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharings ALTER COLUMN id SET DEFAULT nextval('sharings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: evernote_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY evernote_accounts
    ADD CONSTRAINT evernote_accounts_pkey PRIMARY KEY (id);


--
-- Name: evernote_extractors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY evernote_extractors
    ADD CONSTRAINT evernote_extractors_pkey PRIMARY KEY (id);


--
-- Name: followings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY followings
    ADD CONSTRAINT followings_pkey PRIMARY KEY (id);


--
-- Name: highlights_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY highlights
    ADD CONSTRAINT highlights_pkey PRIMARY KEY (id);


--
-- Name: permalinks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY permalinks
    ADD CONSTRAINT permalinks_pkey PRIMARY KEY (id);


--
-- Name: que_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY que_jobs
    ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id);


--
-- Name: sharings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sharings
    ADD CONSTRAINT sharings_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_articles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_articles_on_user_id ON articles USING btree (user_id);


--
-- Name: index_evernote_accounts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_evernote_accounts_on_user_id ON evernote_accounts USING btree (user_id);


--
-- Name: index_evernote_extractors_on_article_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_evernote_extractors_on_article_id ON evernote_extractors USING btree (article_id);


--
-- Name: index_evernote_extractors_on_evernote_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_evernote_extractors_on_evernote_account_id ON evernote_extractors USING btree (evernote_account_id);


--
-- Name: index_followings_on_follower_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_followings_on_follower_id ON followings USING btree (follower_id);


--
-- Name: index_followings_on_leader_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_followings_on_leader_id ON followings USING btree (leader_id);


--
-- Name: index_highlights_on_article_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_highlights_on_article_id ON highlights USING btree (article_id);


--
-- Name: index_sharings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sharings_on_user_id ON sharings USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_0b98d01ed6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY evernote_extractors
    ADD CONSTRAINT fk_rails_0b98d01ed6 FOREIGN KEY (article_id) REFERENCES articles(id);


--
-- Name: fk_rails_27934fb901; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT fk_rails_27934fb901 FOREIGN KEY (permalink_id) REFERENCES permalinks(id);


--
-- Name: fk_rails_3d31dad1cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT fk_rails_3d31dad1cc FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_a4cf4050db; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY evernote_extractors
    ADD CONSTRAINT fk_rails_a4cf4050db FOREIGN KEY (evernote_account_id) REFERENCES evernote_accounts(id);


--
-- Name: fk_rails_aaa0b25c62; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY highlights
    ADD CONSTRAINT fk_rails_aaa0b25c62 FOREIGN KEY (article_id) REFERENCES articles(id);


--
-- Name: fk_rails_b3532aba26; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY highlights
    ADD CONSTRAINT fk_rails_b3532aba26 FOREIGN KEY (permalink_id) REFERENCES permalinks(id);


--
-- Name: fk_rails_bb38e3d979; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY evernote_accounts
    ADD CONSTRAINT fk_rails_bb38e3d979 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_ca39e9873e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sharings
    ADD CONSTRAINT fk_rails_ca39e9873e FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20160108013350');

INSERT INTO schema_migrations (version) VALUES ('20160320232313');

INSERT INTO schema_migrations (version) VALUES ('20160324171930');

INSERT INTO schema_migrations (version) VALUES ('20160403051932');

INSERT INTO schema_migrations (version) VALUES ('20160403080010');

INSERT INTO schema_migrations (version) VALUES ('20160420054125');

INSERT INTO schema_migrations (version) VALUES ('20160513010347');

INSERT INTO schema_migrations (version) VALUES ('20160517015522');

