Using sakila database;

-- 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name 
	FROM actor 

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT CONCAT(first_name, ' ', last_name) as 'Actor Name' 
	FROM actor 

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
	FROM actor
		WHERE first_name = 'Joe'

-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT first_name, last_name
	FROM actor
		WHERE last_name LIKE '%GEN%'

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT *
	FROM actor
		WHERE last_name LIKE '%L%I%'
	ORDER BY 3, 2

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
	FROM country 
		WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. 
-- Hint: you will need to specify the data type.
SELECT * 
	FROM actor
	ALTER TABLE actor
	ADD COLUMN middle_name VARCHAR(15) AFTER first_name;

-- 3b. You realize that some of these actors have tremendously long last names. 
-- Change the data type of the `middle_name` column to `blobs`.
SELECT * FROM actor
	ALTER TABLE actor MODIFY middle_name BLOB;

-- 3c. Now delete the `middle_name` column.
alter table actor
drop column middle_name

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as num_with_last_name
from actor
group by last_name

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name) as num_with_last_name
from actor
group by last_name 
having count(last_name)>=2
order by 2, 1

-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
update actor
set first_name = 'HARPO'
where first_name = 'Harpo' AND last_name = 'Williams';


-- 4d. if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. 
-- Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. 
-- BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

UPDATE actor
SET SQL_SAFE_UPDATES = 0;
SET first_name = 'harpo'
WHERE first_name = 'groucho-r'

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html

SHOW CREATE TABLE address

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
	FROM staff s
		JOIN address a
		ON s.address_id=a.address_id


-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.first_name, s.last_name, sum(p.amount)
	FROM staff s
		JOIN payment p
		ON s.staff_id=p.staff_id
	WHERE payment_date between '2005-08-01' and '2005-08-31'
	GROUP BY 1,2
    ORDER BY 3 DESC

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title, count(fa.actor_id)
	FROM film f
		JOIN film_actor fa
		ON f.film_id=fa.film_id
	GROUP BY 1

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT f.title, COUNT(i.inventory_id)
	FROM inventory i
    JOIN film f
    ON f.film_id=i.film_id
	WHERE f.title = 'Hunchback Impossible'

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name: ![Total amount paid](Images/total_payment.png)

SELECT c.last_name, SUM(p.amount) AS total_payment
		FROM customer c
        JOIN payment p
        ON p.customer_id=c.customer_id
		GROUP BY 1

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT f2.title
FROM film f2
where f2.title like 'K%' or f2.title like 'Q%' 
AND f2.film_id IN (
SELECT f.film_id
FROM film f
JOIN language l ON l.language_id = f.language_id
WHERE l.name = 'English'
)

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
-- why complicate with a subquery? This is the most efficient way
SELECT a.first_name, a.last_name, f.title
	FROM actor a, film f
	WHERE f.title='Alone Trip'


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
-- of all Canadian customers. Use joins to retrieve this information.
SELECT cu.first_name, cu.last_name, cu.email 
	FROM customer cu
		JOIN address a ON a.address_id=cu.address_id
		JOIN city ci ON ci.city_id=a.city_id
		JOIN country co ON co.country_id=ci.country_id
			WHERE co.country = 'Canada'
  

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films.

SELECT f.title
	FROM film f
	JOIN film_category fc ON f.film_id=fc.film_id
		JOIN category ca ON ca.category_id=fc.category_id
			WHERE ca.name='family'    

-- 7e. Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(r.rental_id) AS most_rented 
	FROM film f
		JOIN inventory i
		ON i.film_id=f.film_id
		JOIN rental r
        ON r.inventory_id = i.inventory_id
			GROUP BY f.title
			ORDER BY 2 desc

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount)
	FROM payment p
		JOIN rental r
			ON p.rental_id=r.rental_id
		JOIN inventory i
			ON i.inventory_id=r.inventory_id
		JOIN store s
			ON s.store_id=i.store_id
				GROUP BY 1
                ORDER BY 2 DESC

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, a.address, co.country
	FROM store s 
		JOIN address a
		ON s.address_id=a.address_id
        JOIN city ci
        ON ci.city_id=a.city_id
        JOIN country co
        ON co.country_id=ci.country_id
			GROUP BY 1, 2, 3
            ORDER BY 1


-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT ca.name, SUM(p.amount) AS total 
	FROM category ca
		JOIN film_category fc ON ca.category_id=fc.category_id        
		JOIN inventory i ON i.film_id=fc.film_id        
		JOIN rental r ON r.inventory_id=i.inventory_id        
		JOIN payment p ON p.rental_id=r.rental_id
			GROUP BY 1
			ORDER BY 2 desc 
            LIMIT 5

