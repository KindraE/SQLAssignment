
USE sakila;

#1a Actors First and Last Names
SELECT first_name, last_name
FROM actor;

#1b Uppercase FIRST/LAST Name in Single Column
SELECT 
  UPPER(first_name) as Actor_Name 
FROM 
  actor;
SELECT 
	UPPER(CONCAT(first_name,' ',last_name)) as ACTOR_NAME 
FROM 
    actor;

#2a Actor ID, First, Last as "Joe"

SELECT 
  actor_id, 
  first_name, 
  last_name 
FROM 
  actor 
WHERE 
  first_name LIKE "%Joe%";
  
# 2b All Actors with Last Name GEN
SELECT
	last_name
FROM 
	actor
WHERE last_name LIKE "%GEN%";

#2c Actors with Last Name LI ordered by Last and First Name
SELECT
	last_name,
    first_name
FROM 
	actor
WHERE last_name LIKE "%LI%"
ORDER BY 
	last_name,
	first_name;
    
#2d Display country and id of Afghanistan, Bangladesh, and China
SELECT
	country_id as CountryID,
    country as Country
FROM 
	country
	WHERE 
        country IN ('Afghanistan', 'Bangladesh', 'China');
        
#3a Create Column named Description as BLOB

ALTER TABLE actor ADD COLUMN description BLOB;

#3b Delete description column in Actor

ALTER TABLE actor DROP COLUMN description;

#4a List of Actors Last Name and Count
SELECT 
	last_name as LastName,
    COUNT(*) as Total
FROM 
	actor 
GROUP BY
	last_name
;

#4b Names and Number of Actors for at least Two Actors

SELECT 
	last_name,
    COUNT(last_name) as 'Total'
FROM 
	actor 
GROUP BY
	 last_name having 'Total' >= 2
;

#4c Actor Harpo Williams as Groucho
SET SQL_SAFE_UPDATES = 0;

UPDATE
   actor
SET
    first_name = "Harpo"

WHERE
    first_name LIKE "%Groucho%";
    
#4d Change names back to Groucho

UPDATE
   actor
SET
    first_name = "Groucho"

WHERE
    first_name LIKE "%Harpo%";
    
SET SQL_SAFE_UPDATES = 1;

#5a Query to Locate Schema of the Address Table
SHOW CREATE TABLE address

#6a Join to Display First and Last Names & Addresses of staff

SELECT 
	staff.first_name AS FirstName,
		staff.last_name AS LastName,
        address.address AS Address
FROM 
	staff
INNER JOIN 
	address ON
	staff.address_id=address.address_id
;

#6b Join to Dispay Total Amount from Each Staff Member in August 2005 

SELECT 
	SUM(payment.amount) AS Amount,
    #payment.staff_id AS ID,
    staff.first_name AS FirstName,
    staff.last_name AS LastName,
    payment.payment_date AS Date
FROM 
	staff
INNER JOIN 
	payment ON
	staff.staff_id=payment.staff_id
GROUP BY
	payment.staff_id
;

#6c List each Film and Num Actors who are Listed in the Film

SELECT 
	film.title AS Title,
	sum(film_actor.actor_id) AS Actors
FROM 
	film_actor
INNER JOIN 
	film ON
	film_actor.film_id=film.film_id
GROUP BY
	Title
;


#6d Copies of Hunchback Impossible Exist
SELECT COUNT(*) from film
WHERE title = 'Hunchback Impossible';


#6e Join Payment and Customer to list the total paid by customer, Alpha by Last Name

SELECT 
	
    customer.first_name AS 'First Name',
    customer.last_name AS LastName,
    SUM(payment.amount) AS 'Total Amount Paid',
    payment.customer_ID AS ID 
FROM 
	payment
JOIN 
	customer ON
	customer.customer_id=payment.customer_id
GROUP BY
	LastName
;

#7a Display Movies with Titles Starting with K and Q and in English

SELECT Title
FROM film

WHERE 
	Title LIKE "K%"
    OR Title LIKE "Q%"
AND 
	language_id IN 
    (
    SELECT language_id
    FROM language
    WHERE name = 'English'
);


#7b Use Subqueries to Disply Actors in Alone Trip

SELECT 
	first_name,
    last_name
FROM actor
WHERE actor_id IN(
    SELECT
		actor_id
	FROM 
		film_actor
	WHERE 
		film_id =
        (
        SELECT film_id
        FROM film
		WHERE title = 'Alone Trip'
)
);


#7c Use Join for all Names and Email Addresses of Canadian Customers

SELECT 
  cus.first_name, 
  cus.last_name, 
  cus.email 
FROM 
  customer cus 
  JOIN address a ON (cus.address_id = a.address_id) 
  JOIN city cty ON (cty.city_id = a.city_id) 
  JOIN country ON (
    country.country_id = cty.country_id
  ) 
WHERE 
  country.country = 'Canada';

#7d Identify all Family Films

SELECT 
  title, 
  description 
FROM 
  film 
WHERE 
  film_id IN (
    SELECT 
      film_id 
    FROM 
      film_category 
    WHERE 
      category_id IN (
        SELECT 
          category_id 
        FROM 
          category 
        WHERE 
          name = "Family"
      )
  );


#7e Most Frequently Rented Movies in Descending Order

SELECT 
  f.title, 
  COUNT(rental_id) AS 'Times Rented' 
FROM 
  rental r 
  JOIN inventory i ON (r.inventory_id = i.inventory_id) 
  JOIN film f ON (i.film_id = f.film_id) 
GROUP BY 
  f.title 
ORDER BY 
  `Times Rented` DESC;

#7f Query of how Much Business in $ each Store Made

SELECT 
  s.store_id, 
  SUM(amount) AS 'Revenue' 
FROM 
  payment p 
  JOIN rental r ON (p.rental_id = r.rental_id) 
  JOIN inventory i ON (i.inventory_id = r.inventory_id) 
  JOIN store s ON (s.store_id = i.store_id) 
GROUP BY 
  s.store_id;

#7g Display Each Store ID, City, Country

SELECT 
  s.store_id, 
  cty.city, 
  country.country 
FROM 
  store s 
  JOIN address a ON (s.address_id = a.address_id) 
  JOIN city cty ON (cty.city_id = a.city_id) 
  JOIN country ON (
    country.country_id = cty.country_id
  );

#7h Top Five Genres of Gross Revenue Descending

SELECT 
  c.name AS 'Genre', 
  SUM(p.amount) AS 'Gross' 
FROM 
  category c 
  JOIN film_category fc ON (c.category_id = fc.category_id) 
  JOIN inventory i ON (fc.film_id = i.film_id) 
  JOIN rental r ON (i.inventory_id = r.inventory_id) 
  JOIN payment p ON (r.rental_id = p.rental_id) 
GROUP BY 
  c.name 
ORDER BY 
  Gross 
LIMIT 
  5;

#8a Top Five Genres by Gross Revenue

SELECT 
  c.name AS 'Genre', 
  SUM(p.amount) AS 'Gross' 
FROM 
  category c 
  JOIN film_category fc ON (c.category_id = fc.category_id) 
  JOIN inventory i ON (fc.film_id = i.film_id) 
  JOIN rental r ON (i.inventory_id = r.inventory_id) 
  JOIN payment p ON (r.rental_id = p.rental_id) 
GROUP BY 
  c.name 
ORDER BY 
  Gross 
LIMIT 
  5;

#8b View of 8a
SELECT * from genre_revenue;

#8c. Delete the View top_five_genres

DROP VIEW genre_revenue;