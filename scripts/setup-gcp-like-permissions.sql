ALTER ROLE postgres RENAME TO cloudsqladmin;
CREATE ROLE cloudsqlsuperuser WITH CREATEDB CREATEROLE;
ALTER DATABASE mydb OWNER TO cloudsqlsuperuser;
CREATE ROLE "postgres" WITH LOGIN CREATEDB CREATEROLE IN ROLE cloudsqlsuperuser;
