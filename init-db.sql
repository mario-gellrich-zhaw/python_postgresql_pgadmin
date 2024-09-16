-- init-db.sql
CREATE ROLE postgres WITH LOGIN PASSWORD 'geheim' SUPERUSER;

-- Create the northwind database
CREATE DATABASE northwind;
