
# Téma projektu
Téma projektu sa zameriava na analýzu predaja hudby v rámci databázy **Chinook**.  Projekt využíva analýzu dát na získanie kľúčových informácií, ako sú predaje podľa hudobných žánrov, krajín zákazníkov, umelcov, albumov a vývoj predaja v čase.

## 1. Úvod a popis zdrojových dát

### 1.1  Úvod a popis zdrojových dát

Účelom analýzy je identifikovať trendy v predaji, porovnávať výkon rôznych hudobných žánrov a umelcov a analyzovať vplyv rôznych faktorov na predaj hudby.

### 1.2 Základný popis každej tabuľky

1. **Invoice**: Táto tabuľka zaznamenáva údaje o faktúrach, vrátane dátumu nákupu, identifikátora zákazníka, celkovej sumy faktúry a identifikátora predaja. Tieto informácie sú nevyhnutné na analýzu predaja podľa jednotlivých transakcií.

2. **InvoiceLine**: Táto tabuľka obsahuje detaily o položkách na faktúrach, ako je identifikátor faktúry, identifikátor skladby, množstvo a cena za jednotku. Je dôležitá na určenie predaja na úrovni jednotlivých skladieb.

3. **Track**: Obsahuje údaje o skladbách, vrátane názvu skladby, dĺžky trvania, ceny a albumu, z ktorého skladba pochádza. Tieto údaje sú dôležité pre analýzu predaja na úrovni skladieb a albumov.

4. **Album**: Táto tabuľka obsahuje informácie o albumoch, ako je názov albumu a identifikátor interpreta. Je kľúčová na analýzu predaja podľa albumov.

5. **Artist**: Zaznamenáva údaje o umelcoch, vrátane ich názvov. Tieto informácie sú užitočné pre analýzu predaja podľa umelcov.

6. **Genre**: Obsahuje údaje o hudobných žánroch, vrátane názvu žánru. Táto tabuľka je nevyhnutná na analýzu predaja podľa žánrov.

7. **MediaType**: Obsahuje informácie o mediálnych typoch (napr. MP3, AAC). Tieto údaje sú dôležité pre analýzu predaja podľa typu média, ktorý zákazník zakúpil.

8. **Employee**: Obsahuje údaje o zamestnancoch, ako sú meno, titul, nadriadený (prostredníctvom cudzího kľúča), dátum narodenia, dátum nástupu, adresu, mesto, štát a krajinu. Táto tabuľka sa využíva na prepojenie medzi zamestnancami a zákazníkmi, kde zamestnanci môžu byť priradení ako podporní pracovníci zákazníkov.

9. **Customer**: Zaznamenáva údaje o zákazníkoch, ako sú meno, priezvisko, adresa, telefón, email a priradený podporovateľ (zamestnanec). Táto tabuľka je základom pre analýzu predaja podľa zákazníkov.

10. **Playlist**: Obsahuje údaje o playlistoch, vrátane názvu playlistu. Táto tabuľka je dôležitá na analýzu predaja podľa playlistov.

11. **PlaylistTrack**: Zaznamenáva vzťahy medzi skladbami a playlistami. Každý záznam obsahuje identifikátor playlistu a skladby. Táto tabuľka umožňuje získať informácie o predaji skladieb v rámci playlistov.

### 1.3 ERD diagram, ktorý znázorňuje vzťahy medzi tabuľkami
Tento diagram ukazuje, ako sú rôzne údaje prepojené a ako môžeme vykonávať analýzy na rôznych úrovniach (zákazníci, faktúry, skladby, albumy, žánre, umelci, ...).

<p align="center">
  <img src="https://github.com/Zeromonster12/dt_projekt/blob/main/erd_schema.png?raw=true" alt="ERD Schema">
  <br>
  <em>Obrázok 1 Entitno-relačná schéma ChinookDB</em>
</p>

## 2. Návrh dimenzionálneho modelu

## Faktová tabuľka: `Fact_Sales`
Faktová tabuľka `Fact_Sales` obsahuje hlavné metriky a kľúče, ktoré sa používajú pri analýze predajov skladieb. Táto tabuľka obsahuje transakčné dáta o predajoch, ako aj kľúče, ktoré sa spájajú s dimenzionálnymi tabuľkami.

### Hlavné metriky:
- **Quantity**: Množstvo predaných skladieb.
- **UnitPrice**: Cena za jednu skladbu.

### Kľúče vo faktovej tabuľke:
- **InvoiceLineId**: Primárny kľúč faktového riadku.
- **InvoiceId**: Cudzí kľúč, ktorý odkazuje na faktúru v tabuľke `Dim_Invoice`.
- **TrackId**: Cudzí kľúč, ktorý odkazuje na skladbu v tabuľke `Dim_Track`.
- **DateId**: Cudzí kľúč, ktorý odkazuje na dátum predaja v tabuľke `Dim_Date`.
- **CustomerId**: Cudzí kľúč, ktorý odkazuje na zákazníka v tabuľke `Dim_Customer`.
- **EmployeeId**: Cudzí kľúč, ktorý odkazuje na zamestnanca v tabuľke `Dim_Employee`.
- **MediaTypeId**: Cudzí kľúč, ktorý odkazuje na typ média v tabuľke `Dim_MediaType`.
- **AlbumId**: Cudzí kľúč, ktorý odkazuje na album v tabuľke `Dim_Album`.
- **ArtistId**: Cudzí kľúč, ktorý odkazuje na umelca v tabuľke `Dim_Artist`.
- **GenreId**: Cudzí kľúč, ktorý odkazuje na žáner v tabuľke `Dim_Genre`.

---

## Dimenzionálne tabuľky

### 1. **`Dim_Track` (Dimenzia: Skladby)**
- **Údaje**: Obsahuje informácie o jednotlivých skladbách, ako sú názov skladby, skladateľ, dĺžka skladby, veľkosť súboru, cena a umelec.
- **Typ dimenzie**: (SCD typu 1), pretože informácie o skladbách sa nemenia počas času.

### 2. **`Dim_Employee` (Dimenzia: Zamestnanci)**
- **Údaje**: Uchováva informácie o zamestnancoch. Zahrnuté sú údaje ako meno, titul, adresa, telefónne číslo.
- **Typ dimenzie**: (SCD typu 1), pretože informácie o zamestnancoch sú zvyčajne stabilné a nemenia sa.

### 3. **`Dim_Customer` (Dimenzia: Zákazníci)**
- **Údaje**: Obsahuje údaje o zákazníkoch, vrátane ich mien, adries, telefónnych čísel, emailov a informácií o spoločnosti.
- **Typ dimenzie**: (SCD typu 2) nám umožní uchovávať historické verzie týchto zmien, čo je užitočné pre analýzu správania zákazníkov v čase.

### 4. **`Dim_Invoice` (Dimenzia: Faktúry)**
- **Údaje**: Uchováva informácie o faktúrach, ako dátum vystavenia faktúry, adresa fakturácie, mesto, štát, krajina a celková suma faktúry.
- **Typ dimenzie**: (SCD typu 2), faktúry môžu obsahovať údaje, ktoré sa menia v čase (napr. fakturačná adresa, stav faktúry, krajina). SCD typu 2 je vhodné, pretože umožňuje uchovávať historické verzie týchto zmien, čo je užitočné pre analýzu zmien v čase, ako aj pre presné sledovanie vývoja fakturácie.

### 5. **`Dim_Date` (Dimenzia: Dátumy)**
- **Údaje**: Obsahuje informácie o dátumoch, ako kalendárny dátum, rok, mesiac, deň, názov dňa, týždeň a štvrťrok.
- **Typ dimenzie**: (SCD typu 1), pretože dáta o dátumoch sú konštantné a nemenia sa.

### 6. **`Dim_MediaType` (Dimenzia: Typy médií)**
- **Údaje**: Obsahuje rôzne typy médií, ako sú formáty skladieb (napríklad MP3, WAV).
- **Typ dimenzie**: (SCD typu 1), pretože typy médií sa nemenia a nie sú závislé na čase.

### 7. **`Dim_Album` (Dimenzia: Albumy)**
- **Údaje**: Obsahuje informácie o albumoch, ako je názov albumu.
- **Typ dimenzie**: (SCD typu 1), pretože názvy albumov sa nemenia, ale môžu byť aktualizované, ak je vydaný nový album.

### 8. **`Dim_Artist` (Dimenzia: Umelci)**
- **Údaje**: Uchováva informácie o umelcoch, ako je ich meno.
- **Typ dimenzie**: (SCD typu 1), pretože údaje o umelcoch sú relatívne stabilné.

### 9. **`Dim_Genre` (Dimenzia: Žánre)**
- **Údaje**: Obsahuje informácie o hudobných žánroch, ako je názov žánru.
- **Typ dimenzie**: (SCD typu 1), pretože žánre sú stabilné a nemenia sa.

---

<p align="center">
  <img src="https://github.com/Zeromonster12/dt_projekt/blob/main/star_schema.png?raw=true" alt="Star Schema">
  <br>
  <em>Obrázok 2 Schéma hviezdy pre ChinookDB</em>
</p>

## 3. ETL proces v Snowflake
### 3.1 Extract
Tento krok sa zameriava na získanie dát zo súborov (napríklad CSV súborov) uložených v **stage** a ich načítanie do dočasných tabuliek (staging tabuliek) v Snowflake.

- **Vytvorenie stage**:
```sql
CREATE OR REPLACE STAGE my_stage;
```
Tento príkaz vytvára stage, ktorý sa používa na uloženie súborov (ako napríklad CSV súbory) pred ich spracovaním.
- **Načítanie dát do staging tabuliek (COPY INTO)**:
```sql
COPY INTO genre_staging
FROM @my_stage/genre.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
```
Tento príkaz načítava dáta z CSV súboru (`genre.csv`) uloženého v stage do staging tabuľky `genre_staging`. 

### 3.2 Transform
Transformačná fáza ETL procesu v tomto prípade spočívala v spracovaní a úprave dát z dočasných staging tabuliek do dimenzií a faktovej tabuľky. Tento krok je kľúčový, pretože zaisťuje, že dáta sú vo forme, ktorá je vhodná na analýzu a reporting.

#### Vytvorenie dimenzií
Dimenzionálne tabuľky (napr. `dim_artist`, `dim_album`, `dim_genre`, `dim_media_type`, `dim_track`, `dim_customer`, `dim_employee`, `dim_invoice`, `dim_date`) sú nevyhnutné na zorganizovanie dát tak, aby sa dali efektívne používať v analýzach. Každá z týchto tabuliek obsahuje jedinečné hodnoty pre každý atribút a slúži ako referenčná tabuľka pre faktovú tabuľku. Kľúčovým aspektom transformácie je výber a extrakcia relevantných údajov zo staging tabuliek.

#### Príklady dimenzií:
- **Dim_Artist:** Obsahuje informácie o umelcoch, ako sú `artistid` a `name`.

```sql
CREATE TABLE dim_artist AS
SELECT DISTINCT
    ar.artistid AS dim_artistid,
    ar.name AS artist_name
FROM artist_staging ar;
```

- **Dim_Album**: Uchováva informácie o albumoch, vrátane albumu a priradeného umelca.

```sql
CREATE TABLE dim_album AS
SELECT DISTINCT
    a.albumid AS dim_albumid,
    a.title AS album_title,
    ar.artistid AS artist_id
FROM album_staging a
JOIN artist_staging ar ON a.artistid = ar.artistid;
```

- **Dim_Genre**: Uchováva informácie o hudobných žánroch.
```sql
CREATE TABLE dim_genre AS
SELECT DISTINCT
    g.genreid AS dim_genreid,
    g.name AS genre_name
FROM genre_staging g;
```

- **Dim_Media_Type**: Uchováva informácie o typoch médií.
```sql
CREATE TABLE dim_media_type AS
SELECT DISTINCT
    m.mediatypeid AS dim_media_typeid,
    m.name AS media_type_name
FROM mediatype_staging m;
```

- **Dim_Track**: Uchováva informácie o skladbách, ako sú názov skladby, skladateľ, dĺžka a cena.
```sql
CREATE TABLE dim_track AS
SELECT DISTINCT
    t.trackid AS dim_trackid,
    t.name AS track_name,
    t.composer AS composer,
    t.miliseconds AS duration_ms,
    t.bytes AS size_bytes,
    t.unitprice AS price
FROM track_staging t;
```

- **Dim_Customer**: Uchováva informácie o zákazníkoch, vrátane ich kontaktných údajov a informácií o podporovaní zástupcovi.
```sql
CREATE TABLE IF NOT EXISTS dim_customer AS
SELECT DISTINCT
    c.customerid AS dim_customerid,
    c.firstname AS first_name,
    c.lastname AS last_name,
    c.company AS company,
    c.address AS address,
    c.city AS city,
    c.state AS state,
    c.country AS country,
    c.postalcode AS postal_code,
    c.phone AS phone,
    c.fax AS fax,
    c.email AS email,
    e.firstname AS support_rep_first_name,
    e.lastname AS support_rep_last_name
FROM customer_staging c
JOIN employee_staging e ON c.supportrepid = e.employeeid;
```

- **Dim_Employee**: Uchováva informácie o zamestnancoch.
```sql
CREATE TABLE dim_employee AS
SELECT DISTINCT
    e.employeeid AS dim_employeeid,
    e.lastname AS last_name,
    e.firstname AS first_name,
    e.title AS title,
    e.reportsto AS reports_to,
    e.birthdate AS birth_date,
    e.hiredate AS hire_date,
    e.address AS address,
    e.city AS city,
    e.state AS state,
    e.country AS country,
    e.postalcode AS postal_code,
    e.phone AS phone,
    e.fax AS fax,
    e.email AS email
FROM employee_staging e;
```

- **Dim_Invoice**: Uchováva informácie o faktúrach, vrátane zákazníka a údajov o platbe.
```sql
CREATE TABLE IF NOT EXISTS dim_invoice AS
SELECT DISTINCT
    i.invoiceid AS dim_invoiceid,
    i.customerid AS customer_id,
    i.invoicedate AS invoice_date,
    i.billingaddress AS billing_address,
    i.billingcity AS billing_city,
    i.billingstate AS billing_state,
    i.billingcountry AS billing_country,
    i.billingpostalcode AS billing_postalcode,
    i.total AS total_amount,
    c.country AS customer_country
FROM invoice_staging i
JOIN customer_staging c ON i.customerid = c.customerid;
```

- **Dim_date**: Uchováva informácie o dátumoch, je využívaná na správu dátumov. Dim_Date obsahuje rôzne časové atribúty, ako je deň, mesiac, rok, štvrťrok, deň v týždni, týždeň a názov dňa, čo umožňuje flexibilné analýzy podľa rôznych časových období.
```sql
CREATE TABLE dim_date AS
SELECT DISTINCT
    ROW_NUMBER() OVER (ORDER BY CAST(i.invoicedate AS DATE)) AS dim_dateid,
    CAST(i.invoicedate AS DATE) AS date,
    DATE_PART('day', i.invoicedate) AS day,
    DATE_PART('month', i.invoicedate) AS month,
    DATE_PART('year', i.invoicedate) AS year,
    DATE_PART('quarter', i.invoicedate) AS quarter,
    CASE
        WHEN DATE_PART('dow', i.invoicedate) = 0 THEN 'Sunday'
        WHEN DATE_PART('dow', i.invoicedate) = 1 THEN 'Monday'
        WHEN DATE_PART('dow', i.invoicedate) = 2 THEN 'Tuesday'
        WHEN DATE_PART('dow', i.invoicedate) = 3 THEN 'Wednesday'
        WHEN DATE_PART('dow', i.invoicedate) = 4 THEN 'Thursday'
        WHEN DATE_PART('dow', i.invoicedate) = 5 THEN 'Friday'
        WHEN DATE_PART('dow', i.invoicedate) = 6 THEN 'Saturday'
    END AS day_name,
    DATE_PART('dow', i.invoicedate) + 1 AS day_week,
    EXTRACT(WEEK FROM DATE_TRUNC('WEEK', i.invoicedate + INTERVAL '1 DAY')) AS week
FROM invoice_staging i;
```
- **Vytvorenie faktovej tabuľky**: Faktová tabuľka fact_sales obsahuje agregované a podrobné údaje o predaji, spájajúce dimenzie, ako sú faktúry, skladby, albumy, umelci, žánre a médiá.
```sql
CREATE TABLE fact_sales AS
SELECT
    il.invoicelineid AS fact_salesid,
    i.invoiceid AS invoice_id,
    il.quantity AS quantity,
    il.unitprice AS unit_price,
    t.trackid AS track_id,
    g.genreid AS genre_id,
    a.albumid AS album_id,
    ar.artistid AS artist_id,
    m.mediatypeid AS media_type_id,
    c.customerid AS customer_id,
    e.employeeid AS employee_id,
    d.dim_dateid AS date_id
FROM invoiceline_staging il
JOIN invoice_staging i ON il.invoiceid = i.invoiceid
JOIN track_staging t ON il.trackid = t.trackid
JOIN genre_staging g ON t.genreid = g.genreid
JOIN album_staging a ON t.albumid = a.albumid
JOIN artist_staging ar ON a.artistid = ar.artistid
JOIN mediatype_staging m ON t.mediatypeid = m.mediatypeid
JOIN customer_staging c ON i.customerid = c.customerid
JOIN employee_staging e ON c.supportrepid = e.employeeid
JOIN dim_date d ON CAST(i.invoicedate AS DATE) = d.date;
```


### 3.3 Load

Po úspešnom vytvorení dimenzií a faktovej tabuľky boli dáta načítané do konečného formátu. Na záver boli staging tabuľky vymazané, čo prispelo k efektívnejšiemu využitiu úložiska.

- **Vymazanie staging tabuliek**:
```sql
DROP TABLE track_staging;
DROP TABLE artist_staging;
DROP TABLE album_staging;
DROP TABLE mediatype_staging;
DROP TABLE genre_staging;
DROP TABLE employee_staging;
DROP TABLE customer_staging;
DROP TABLE invoice_staging;
DROP TABLE invoiceline_staging;
DROP TABLE playlist_staging;
DROP TABLE playlisttrack_staging;

```

## 4. Vizualizácia dát
Dashboard obsahuje 5 vizualizácií, ktoré poskytujú prehľad o predajoch hudby na základe rôznych faktorov ako žánre, krajiny, umelci, albumy a čas. Tieto grafy umožňujú analyzovať, ktoré produkty a regióny generujú najväčší príjem, a identifikovať predajné trendy v závislosti od času, čo pomáha lepšie porozumieť spotrebiteľským preferenciám a trhovým podmienkam.

<p align="center">
  <img src="https://github.com/Zeromonster12/dt_projekt/blob/main/chinook_dashboard.png?raw=true" alt="Dashboard screenshot">
  <br>
  <em>Obrázok 3 Screenshot dashboardu pre ChinookDB</em>
</p>

### **Graf 1: Predaj podľa hudobných žánrov**
Tento graf zobrazuje celkový predaj podľa jednotlivých hudobných žánrov. Pomáha zodpovedať otázku, ktorý hudobný žáner generuje najvyššie príjmy z predaja.

```sql
SELECT 
    g.genre_name, 
    SUM(fs.quantity * fs.unit_price) AS total_sales
FROM fact_sales fs
JOIN dim_genre g ON fs.genre_id = g.dim_genreid
GROUP BY g.genre_name
ORDER BY total_sales DESC;
```


### **Graf 2: Predaj podľa krajiny zákazníkov**
Tento graf zobrazuje celkový predaj podľa krajiny fakturácie. Pomáha zodpovedať otázku, v ktorých krajinách sa dosahujú najvyššie príjmy z predaja.

```sql
SELECT 
    c.country, 
    SUM(fs.quantity * fs.unit_price) AS total_sales
FROM fact_sales fs
JOIN dim_customer c ON fs.customer_id = c.dim_customerid
GROUP BY c.country
ORDER BY total_sales DESC;
```

###  **Graf 3: Najpredávanejší umelci**
Tento graf zobrazuje celkový predaj podľa umelcov. Pomáha zodpovedať otázku, ktorí umelci dosahujú najvyššie príjmy z predaja.

```sql
SELECT 
    ar.artist_name, 
    SUM(fs.quantity * fs.unit_price) AS total_sales
FROM fact_sales fs
JOIN dim_album a ON fs.album_id = a.dim_albumid
JOIN dim_artist ar ON a.artist_id = ar.dim_artistid
GROUP BY ar.artist_name
ORDER BY total_sales DESC;
```
###  **Graf 4: Predaje podľa albumu**
Tento graf zobrazuje celkový predaj podľa albumov. Pomáha zodpovedať otázku, ktoré albumy generujú najvyššie príjmy z predaja.
```sql
SELECT 
    a.album_title, 
    SUM(fs.quantity * fs.unit_price) AS total_sales
FROM fact_sales fs
JOIN dim_album a ON fs.album_id = a.dim_albumid
GROUP BY a.album_title
ORDER BY total_sales DESC
LIMIT 10;
```


### **Graf 5: Vývoj predaja v čase**
Tento graf zobrazuje celkový predaj podľa dátumu fakturácie. Pomáha zodpovedať otázku, ako sa príjmy z predaja menili v priebehu času.
 ```sql 
SELECT 
    d.date, 
    SUM(fs.quantity * fs.unit_price) AS total_sales
FROM fact_sales fs
JOIN dim_date d ON fs.date_id = d.dim_dateid
GROUP BY d.date
ORDER BY d.date;
```

---

**Autor:** Martin Mucha
