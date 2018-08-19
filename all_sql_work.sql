SELECT r.inventory_id, 
	MIN(r.rental_date) as first_rented,
    MAX(r.rental_date) as last_rented , 
    (
		SELECT count(*) 
        FROM rental r2
        WHERE r2.inventory_id = r.inventory_id
        AND r2.rental_date < MIN(r.rental_date) + INTERVAL 90 DAY
        
    ) as rented_times_first_90_days
    

FROM rental r
GROUP BY 1 
ORDER BY 2


-- customer_Id, first_order_value, first 30 days order value sum

SELECT p.customer_id, p.amount
MIN(p.payment_date) as first_payment_date
(
select count(*)
from payment p2
where p2.customer_id=p.customer_id
and p.payment_date = min(p.payment_date)
 
 )
 as first order date
 
SELECT p.customer_id, p.amount, SUM(p.amount)
MIN(p.payment_date) as first_payment_date
(
select count(*)
from payment p2
where p2.customer_id=p1.customer_id
AND p2.payment date < MIN(p. payment_date) + INTERVAL 30 DAY
 
 )
 as total value in 30 days
 from payment p
 group by 1
 order by 2
 
 select * 
 
 
-- 1. Join the address & city tables to return a dataset showing addresses & their cities.

select a.address, c.city
from address a
join city c 
on (a.city_id=c.city_id)

-- how to select all rows in city not in address?? 600 v. 603
select * 
from city



--  customers who rent from NC17!
-- select distinct t.customer_id from will just show the customers

create view 'customer_nc-17' AS

SELECT distinct t.customer_id, t.cust_em 

FROM (
	SELECT r.inventory_id, r.customer_id, i.film_id, f.title, f.rating, c.email as cust_em
	FROM rental r
		JOIN inventory i ON i.inventory_id = r.inventory_id
		JOIN film f on f.film_id = i.film_id
        LEFT JOIN customer c ON c.customer_id = r.customer_id
		WHERE f.rating = 'NC-17'
) as t


-- count movies by first letter 
select LEFT (f.title, 2), count(*)
from film f
group by 1 order by 1 desc


-- day 1 exercises

USE storestuff;

CREATE TABLE people (
	name VARCHAR(30) NOT NULL,
		has_pet BOOLEAN NOT NULL,
        pet_name VARCHAR(30),
			pet_age INTEGER(10)
);

INSERT INTO people (name, has_pet, pet_name, pet_age)
Values ('Jacob', true, 'Misty', 10)

INSERT INTO people (name, has_pet, pet_name, pet_age)
VALUES ('ahmed', true, 'Rockington', 100);

INSERT INTO people (name, has_pet)
Values ('Peter', false);

SET SQL_SAFE_UPDATES = 0;

UPDATE people
SET pet_age = 55
WHERE name = 'Peter';


SELECT count(name), has_pet, pet_name, pet_age
FROM people
group by name

-- join practice

-- customers that have spent the most
SELECT 
    p.customer_id, c.first_name, c.last_name,
    SUM(amount) as rental_total

FROM payment p

JOIN customer c ON c.customer_id=p.customer_id
GROUP BY 1,2,3
order by 4 desc
limit 10


SELECT customer_id, SUM(amount) >100
FROM payment


SELECT last_name, email, address_id
FROM customer
WHERE address_id IS NULL


Select 
customer_id, amount, payment_date
count(customer_id) c_id
FROM payment
group by customer_id

SELECT * FROM film;

-- # of titles by rating category
	SELECT COUNT(title)/1000 as titles_pct, rating
	FROM film
	group by 2
	order by 1 desc


-- select title, rating, group by rating order by desc HAVING? 
SELECT title, rating
from film 
Order by rating


-- rating of top 100 grossing films grouped by rating ordered by rating desc
select f.film_id, title
from film f
JOIN films ON f.film_id=payment.rental_id
group by title

SELECT * FROM seasons_stats

SELECT COUNT(distinct Player) FROM seasons_stats 


SELECT Player, GROUP_CONCAT(distinct Pos)
FROM seasons_stats
GROUP BY 1 ORDER BY 2 DESC

SELECT p.Player
FROM players p
WHERE p.player NOT IN (....)

SELECT distinct 

SELECT * FROM seasons_stats ss LIMIT 10


SELECT avg(FGA) FROM seasons_stats

SELECT ss.Player, SUM(FGA) as total_points
FROM seasons_stats ss
GROUP BY 1
as t WHERE t.t

    
    
SELECT avg(AGE) 
FROM seasons_stats ss
group by 1, 2
having count(disctinct ss.pos) >1
order by 3 desc


SELECT pa.Player, pa  FROM seasons_stats WHERE AGE>(
SELECT avg(age)
	FROM seasons_stats
)
WHERE Pos = 'c'

SELECT SS.PLAYER, COUNT(DISTINCT SS.POS)
GROUP BY 1
WHERE COUNT(DISTINCT SS.POS) >1
ORDER BY 2 DESC

SELECT ss.Player, p.college, COUNT(DISTINCT ss.Pos) 
FROM season_stats ss JOIN players p ON p.Player = ss.Player
GROUP BY 1 , 2
HAVING COUNT(DISTINCT ss.Pos)  > 1
ORDER BY 3 DESC

CREATE VIEW 'players_older_than_avg
