-- Graf 1. Predaj podľa hudobných žánrov
SELECT g.genre_name, SUM(fs.total_amount) AS total_sales
FROM fact_sales fs
JOIN dim_genre g ON fs.dim_genreId = g.dim_genreId
GROUP BY g.genre_name
ORDER BY total_sales DESC;

-- Graf 2. Predaj podľa krajiny zákazníkov
SELECT i.billing_country, SUM(fs.total_amount) AS total_sales
FROM fact_sales fs
JOIN dim_invoice i ON fs.dim_invoiceId = i.dim_invoiceId
GROUP BY i.billing_country
ORDER BY total_sales DESC;

-- Graf 3. Najpredávanejší umelci
SELECT a.artist_name, SUM(fs.total_amount) AS total_sales
FROM fact_sales fs
JOIN dim_artist a ON fs.dim_artistId = a.dim_artistId
GROUP BY a.artist_name
ORDER BY total_sales DESC;

-- Graf 4. Predaj podľa albumov
SELECT al.album_title, SUM(fs.total_amount) AS total_sales
FROM fact_sales fs
JOIN dim_album al ON fs.dim_albumId = al.dim_albumId
GROUP BY al.album_title
ORDER BY total_sales DESC;

-- Graf 5. Vývoj predaja v čase
SELECT DATE(i.invoice_date) AS sale_date, SUM(fs.total_amount) AS total_sales
FROM fact_sales fs
JOIN dim_invoice i ON fs.dim_invoiceId = i.dim_invoiceId
GROUP BY sale_date
ORDER BY sale_date;