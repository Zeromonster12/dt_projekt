CREATE DATABASE SCORPION_CHINOOK;
CREATE SCHEMA SCORPION_CHINOOK.staging;

USE DATABASE SCORPION_CHINOOK;
USE SCHEMA SCORPION_CHINOOK.staging;

CREATE OR REPLACE STAGE my_stage;

CREATE TABLE IF NOT EXISTS genre_staging (
    genre_id INT,
    genreName VARCHAR(255)
);

COPY INTO genre_staging
FROM @my_stage/genre.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

COPY INTO genre_staging
FROM @my_stage/genre.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

CREATE TABLE artist_staging (
    ArtistId INT,
    Name VARCHAR(120)
);

COPY INTO artist_staging
FROM @my_stage/artist.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

CREATE TABLE album_staging (
    AlbumId INT ,
    Title VARCHAR(160),
    ArtistId INT
);

COPY INTO album_staging
FROM @my_stage/album.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

CREATE TABLE track_staging (
    TrackId INT,
    Name VARCHAR(200),
    AlbumId INT,
    GenreId INT,
    MediaTypeId INT,
    Composer VARCHAR(220),
    Milliseconds INT,
    Bytes INT,
    UnitPrice DECIMAL(10, 2)
);

COPY INTO track_staging
FROM @my_stage/track.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

CREATE TABLE invoice_staging (
    InvoiceId INT,
    CustomerId INT,
    InvoiceDate DATETIME,
    BillingAddress VARCHAR(70),
    BillingCity VARCHAR(40),
    BillingState VARCHAR(40),
    BillingCountry VARCHAR(40),
    BillingPostalCode VARCHAR(10),
    Total DECIMAL(10, 2)
);

COPY INTO invoice_staging
FROM @my_stage/invoice.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

CREATE TABLE invoiceline_staging (
    InvoiceLineId INT,
    InvoiceId INT,
    TrackId INT,
    UnitPrice DECIMAL(10, 2),
    Quantity INT
);

COPY INTO invoiceline_staging
FROM @my_stage/invoiceline.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

-----------------------
--- TRANSFORM ---
-----------------------

CREATE TABLE dim_artist AS
SELECT DISTINCT
    ar.ArtistId AS dim_artistId,
    ar.Name AS artist_name
FROM artist_staging ar;

CREATE TABLE dim_album AS
SELECT DISTINCT
    al.AlbumId AS dim_albumId,
    al.Title AS album_title
FROM album_staging al;

CREATE TABLE dim_genre AS
SELECT DISTINCT
    g.Genre_Id AS dim_genreId,
    g.GenreName AS genre_name
FROM genre_staging g;

CREATE TABLE dim_track AS
SELECT DISTINCT
    t.TrackId AS dim_trackId,
    t.Name AS track_name,
    t.Composer AS track_composer,
    t.Milliseconds AS track_duration_ms,
    t.Bytes AS track_size_bytes,
    t.UnitPrice AS track_price
FROM track_staging t;

CREATE TABLE dim_invoice AS
SELECT DISTINCT
    i.InvoiceId AS dim_invoiceId,
    i.InvoiceDate AS invoice_date,
    i.BillingAddress AS billing_address,
    i.BillingCity AS billing_city,
    i.BillingState AS billing_state,
    i.BillingCountry AS billing_country,
    i.BillingPostalCode AS billing_postal_code,
    i.Total AS total_amount
FROM invoice_staging i;

CREATE TABLE fact_sales AS
SELECT
    i.InvoiceId AS dim_invoiceId,
    il.TrackId AS dim_trackId,
    al.AlbumId AS dim_albumId,
    ar.ArtistId AS dim_artistId,
    g.Genre_Id AS dim_genreId,
    il.UnitPrice AS track_price,
    il.Quantity AS quantity_sold,
    (il.UnitPrice * il.Quantity) AS total_amount
FROM invoiceline_staging il
JOIN track_staging t ON il.TrackId = t.TrackId
JOIN album_staging al ON t.AlbumId = al.AlbumId
JOIN artist_staging ar ON al.ArtistId = ar.ArtistId
JOIN genre_staging g ON t.GenreId = g.Genre_Id
JOIN invoice_staging i ON il.InvoiceId = i.InvoiceId;

select * from fact_sales

-----------------------
--- LOAD ---
-----------------------
DROP TABLE IF EXISTS album_staging;
DROP TABLE IF EXISTS artist_staging;
DROP TABLE IF EXISTS genre_staging;
DROP TABLE IF EXISTS invoice_staging;
DROP TABLE IF EXISTS invoiceline_staging;
DROP TABLE IF EXISTS track_staging;
