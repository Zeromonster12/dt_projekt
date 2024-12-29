
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

### 1.3 ERD diagram, ktorý znázorňuje vzťahy medzi tabuľkami
Tento diagram ukazuje, ako sú rôzne údaje prepojené a ako môžeme vykonávať analýzy na rôznych úrovniach (zákazníci, faktúry, skladby, albumy, žánre, umelci).

![Obrázok 1 ERD schéma](https://github.com/Zeromonster12/dt_projekt/blob/main/ERD%20sch%C3%A9ma.png?raw=true)

## 2. Návrh dimenzionálneho modelu

### Faktová tabuľka: `Fact_Sales`

- **Kľúče:**
  - `SaleId` (Primárny kľúč): Unikátny identifikátor pre každý záznam o predaji.
  - `InvoiceId`, `TrackId`, `AlbumId`, `ArtistId`, `GenreId` (Cudzie kľúče): Tieto cudzie kľúče odkazujú na príslušné dimenzionálne tabuľky, kde sa nachádzajú podrobnosti o faktúrach, skladbách, albumoch, umelcoch a žánroch.

- **Metriky:**
  - `UnitPrice`  Cena jednej skladby pri predaji.
  - `Quantity`  Počet predaných kusov konkrétnej skladby.
  - `TotalAmount`  Celková suma za predanú skladbu, ktorá je výsledkom násobenia ceny za jednotku a počtu predaných kusov.

## Dimenzionálne tabuľky

### 1. **Dim_Invoice** (SCD typu 2)
   - **Atributy:**
     - `InvoiceId`: Identifikátor faktúry.
     - `InvoiceDate`: Dátum vydania faktúry.
     - `BillingAddress`, `BillingCity`, `BillingState`, `BillingCountry`, `BillingPostalCode`: Podrobnosti o adrese fakturácie.
     - `Total`: Celková suma faktúry.
   - Táto dimenzia obsahuje informácie o faktúrach, ktoré sa generujú pri nákupe skladieb. Faktúra je prepojená s faktovou tabuľkou cez `InvoiceId`.

### 2. **Dim_Track** (SCD typu 1)
   - **Atributy:**
     - `TrackId`: Identifikátor skladby.
     - `Name`: Názov skladby.
     - `Composer`: Meno skladateľa.
     - `Milliseconds`: Dĺžka skladby v milisekundách.
     - `Bytes`: Veľkosť skladby v bajtoch.
     - `UnitPrice`: Cena skladby.
   - Táto dimenzia obsahuje podrobnosti o jednotlivých skladbách. Každá skladba v faktovej tabuľke je spojená s touto dimenziou cez `TrackId`. 

### 3. **Dim_Album** (SCD typu 1)
   - **Atributy:**
     - `AlbumId`: Identifikátor albumu.
     - `Title`: Názov albumu.
   -  Táto dimenzia obsahuje informácie o albumoch, ku ktorým skladby patria. V faktovej tabuľke je každá skladba spojená s albumom cez `AlbumId`.

### 4. **Dim_Artist** (SCD typu 1)
   - **Atributy:**
     - `ArtistId`: Identifikátor umelca.
     - `Name`: Meno umelca.
   - Záto dimenzia obsahuje informácie o umelcoch, ktorí vytvorili skladby. V faktovej tabuľke je každá skladba spojená s umelcom cez `ArtistId`.


![Obrázok 2 Schéma Hviezdy](https://github.com/Zeromonster12/dt_projekt/blob/main/Star%20schema.png?raw=true)

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
Transformačná fáza ETL procesu v tomto prípade spočívala v spracovaní a úprave dát z dočasných staging tabuliek do dimenzií a faktovej tabuľky. Tento krok je kľúčový, pretože zaisťuje, že dáta sú vo forme, ktorá je vhodná na analýzu a reporting. Tu je podrobný popis tohto procesu:


### 1. Vytvorenie dimenzií
Dimenzionálne tabuľky (napr. `dim_artist`, `dim_album`, `dim_genre`, `dim_track`, `dim_invoice`) sú nevyhnutné na zorganizovanie dát tak, aby sa dali efektívne používať v analýzach. Každá z týchto tabuliek obsahuje jedinečné hodnoty pre každý atribút a slúži ako referenčná tabuľka pre faktovú tabuľku. Kľúčovým aspektom transformácie je výber a extrakcia relevantných údajov zo staging tabuliek.
#### Príklady dimenzií:
- **Dim_Artist:** Obsahuje jedinečné informácie o umelcoch, ako sú `ArtistId` a `Name`. Vytvára sa tým základ pre priradenie predajov k umelcom.
```sql
CREATE TABLE dim_artistAS
SELECT DISTINCT
	ar.ArtistId AS dim_artistId,
	ar.Name AS artist_name
FROM artist_staging ar;
```
- **Dim_Genre:** Tento krok extrahuje a uchováva informácie o hudobných žánroch. Tento atribút je dôležitý pre analýzu predajov podľa žánrov.
```sql
CREATE TABLE dim_genre AS
SELECT DISTINCT
	g.Genre_Id AS dim_genreId,
	g.GenreName AS genre_name
FROM genre_staging g;
```

- **Dim_Track:** Táto tabuľka uchováva informácie o skladbách, ako je názov, skladateľ, dĺžka skladby a cena.
```sql
CREATE TABLE dim_track AS
SELECT DISTINCT t.TrackId AS dim_trackId,
	t.Name AS track_name,
	t.Composer AS track_composer,
	t.Milliseconds AS track_duration_ms,
	t.Bytes AS track_size_bytes,
	t.UnitPrice AS track_price
FROM track_staging t;
```
- **Dim_Invoice:** Táto tabuľka uchováva podrobnosti o faktúrach, vrátane adresy, mesta a celkovej sumy faktúry.
```sql
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
```
- **Faktová tabuľka**: obsahuje agregované a podrobné údaje o predaji. V tomto prípade sa vytvára `fact_sales`, ktorá spája dimenziu faktúry, skladby, albumu, umelca a žánru a uchováva metriky ako cena za skladbu, množstvo predaných kusov a celková suma.
```sql
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
```
Transformácia zahŕňa spojenie údajov z rôznych staging tabuliek, aby sa vytvorili riadky, ktoré sa ukladajú do faktovej tabuľky.

### 3.3 Load

Po úspešnom vytvorení dimenzií a faktovej tabuľky boli dáta načítané do konečného formátu. Na záver boli staging tabuľky vymazané, čo prispelo k efektívnejšiemu využitiu úložiska.

- **Vymazanie staging tabuliek**:
```sql
DROP TABLE IF EXISTS album_staging;
DROP TABLE IF EXISTS artist_staging;
DROP TABLE IF EXISTS genre_staging;
DROP TABLE IF EXISTS invoice_staging;
DROP TABLE IF EXISTS invoiceline_staging;
DROP TABLE IF EXISTS track_staging;
```

## 4. Vizualizácia dát
Dashboard obsahuje 5 vizualizácií, ktoré poskytujú prehľad o predajoch hudby na základe rôznych faktorov ako žánre, krajiny, umelci, albumy a čas. Tieto grafy umožňujú analyzovať, ktoré produkty a regióny generujú najväčší príjem, a identifikovať predajné trendy v závislosti od času, čo pomáha lepšie porozumieť spotrebiteľským preferenciám a trhovým podmienkam.


### 1. Graf: Predaj podľa hudobných žánrov
Tento graf zobrazuje celkový predaj podľa jednotlivých hudobných žánrov. Pomáha zodpovedať otázku, ktorý hudobný žáner generuje najvyššie príjmy z predaja.

```sql
SELECT g.genre_name, SUM(fs.total_amount) AS total_sales
FROM fact_sales fs
JOIN dim_genre g ON fs.dim_genreId = g.dim_genreId
GROUP BY g.genre_name
ORDER BY total_sales DESC;
```


### **Graf 2: Predaj podľa krajiny zákazníkov**
Tento graf zobrazuje celkový predaj podľa krajiny fakturácie. Pomáha zodpovedať otázku, v ktorých krajinách sa dosahujú najvyššie príjmy z predaja.

```sql
SELECT i.billing_country, SUM(fs.total_amount) AS total_sales
FROM fact_sales fs
JOIN dim_invoice i ON fs.dim_invoiceId = i.dim_invoiceId
GROUP BY i.billing_country
ORDER BY total_sales DESC;	
```

###  **Graf 3: Najpredávanejší umelci**
Tento graf zobrazuje celkový predaj podľa umelcov. Pomáha zodpovedať otázku, ktorí umelci dosahujú najvyššie príjmy z predaja.

```sql
SELECT a.artist_name, SUM(fs.total_amount) AS total_sales
FROM fact_sales fs
JOIN dim_artist a ON fs.dim_artistId = a.dim_artistId
GROUP BY a.artist_name
ORDER BY total_sales DESC;
```
###  **Graf 4: Predaje podľa albumu**
Tento graf zobrazuje celkový predaj podľa albumov. Pomáha zodpovedať otázku, ktoré albumy generujú najvyššie príjmy z predaja.
```sql
SELECT al.album_title, SUM(fs.total_amount) AS total_sales
FROM fact_sales fs
JOIN dim_album al ON fs.dim_albumId = al.dim_albumId
GROUP BY al.album_title
ORDER BY total_sales DESC;
```


### **Graf 5: Vývoj predaja v čase**
Tento graf zobrazuje celkový predaj podľa dátumu fakturácie. Pomáha zodpovedať otázku, ako sa príjmy z predaja menili v priebehu času.
 ```sql 
 SELECT DATE(i.invoice_date) AS sale_date,
 SUM(fs.total_amount) AS total_sales
 FROM fact_sales fs
 JOIN dim_invoice i ON fs.dim_invoiceId = i.dim_invoiceId
 GROUP BY sale_date ORDER BY sale_date;
```
