
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

# Multi-Dimenzionálny Model Hviezdy pre Predaj Hudby


## Faktová tabuľka: `Fact_Sales`

- **Kľúče:**
  - `SaleId` (Primárny kľúč): Unikátny identifikátor pre každý záznam o predaji.
  - `InvoiceId`, `TrackId`, `AlbumId`, `ArtistId`, `GenreId` (Cudzie kľúče): Tieto cudzie kľúče odkazujú na príslušné dimenzionálne tabuľky, kde sa nachádzajú podrobnosti o faktúrach, skladbách, albumoch, umelcoch a žánroch.

- **Metriky:**
  - `UnitPrice`  Cena jednej skladby pri predaji.
  - `Quantity`  Počet predaných kusov konkrétnej skladby.
  - `TotalAmount`  Celková suma za predanú skladbu, ktorá je výsledkom násobenia ceny za jednotku a počtu predaných kusov.

---

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