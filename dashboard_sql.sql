-- Graf 1 Predaj podľa žánru
SELECT 
    g.genre_name, 
    SUM(fs.quantity * fs.unit_price) AS total_sales
FROM fact_sales fs
JOIN dim_genre g ON fs.genre_id = g.dim_genreid
GROUP BY g.genre_name
ORDER BY total_sales DESC;

-- Graf 2 Predaj podľa krajiny zákazníka
SELECT 
    c.country, 
    SUM(fs.quantity * fs.unit_price) AS total_sales
FROM fact_sales fs
JOIN dim_customer c ON fs.customer_id = c.dim_customerid
GROUP BY c.country
ORDER BY total_sales DESC;

-- Graf 3 Predaj podľa umelca
SELECT 
    ar.artist_name, 
    SUM(fs.quantity * fs.unit_price) AS total_sales
FROM fact_sales fs
JOIN dim_album a ON fs.album_id = a.dim_albumid
JOIN dim_artist ar ON a.artist_id = ar.dim_artistid
GROUP BY ar.artist_name
ORDER BY total_sales DESC;

-- Graf 4 Predaj podľa albumov
SELECT 
    a.album_title, 
    SUM(fs.quantity * fs.unit_price) AS total_sales
FROM fact_sales fs
JOIN dim_album a ON fs.album_id = a.dim_albumid
GROUP BY a.album_title
ORDER BY total_sales DESC
LIMIT 10;


-- Graf 5 Vývoj predaja v čase
SELECT 
    d.date, 
    SUM(fs.quantity * fs.unit_price) AS total_sales
FROM fact_sales fs
JOIN dim_date d ON fs.date_id = d.dim_dateid
GROUP BY d.date
ORDER BY d.date;
