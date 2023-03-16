SELECT *
FROM actor 

-- Join film to film_actor
SELECT*
FROM film_actor  
JOIN film 
ON film.film_id = film_actor.film_id ; 


SELECT *
FROM film_actor 
JOIN actor 
ON film_actor.actor_id = actor.actor_id ;

-- Multi Join
SELECT f.film_id, f.title, f.release_year, a.actor_id, a.first_name, a.last_name
FROM film_actor fa
JOIN film f 
ON fa.film_id = f.film_id 
JOIN actor a 
ON fa.actor_id = a.actor_id ;

-- JOIN actor to category ------- actor -> film_actor -> film -> film_category - > category
----------------------------------  1  -----  2  -------  3  -------  4  -----------  5  --

SELECT a.first_name, a.last_name, c.name
-----  1  -------
FROM actor a
-------  2  ----------
JOIN film_actor fa 
------  1  ------  2  ------  
ON a.actor_id = fa.actor_id 
-----  3  ------------
JOIN film f 
-----  3  ------  2  --------
ON f.film_id = fa.film_id 
---------  4  --------
JOIN film_category fc 
----  4  ---------  3  ------
ON fc.film_id = f.film_id 
--------  5  --------
JOIN category c 
-------  5  -----------  4  ------
ON c.category_id = fc.category_id;

-----  SUBQUERIES  ------------
-- Subqueries are queries that happen within another query

-- Ex. Which films have exactly 12 actors in them?

-- Step 1. Get the ID's of the movies that have 12 actors 
SELECT film_id
FROM film_actor 
GROUP BY film_id 
HAVING count(*) = 12;

SELECT film_id
FROM film_actor 
group by film_id 
HAVING count(*) = 12;

-- film_id

--529
--802
--34
--892
--414
--517

-- Step 2. Get rows from the film table that have films in the above list
SELECT *
FROM film 
WHERE film_id IN (
	529,
	802,
	34,
	892,
	414,
	517
);

-- Create a Subquery: Combine the two steps into one query. The query that you want to execute
-- first is the subquery. ** Subquery must return only 1 column **
--                      ** unless used in a FROM clause **

SELECT *
FROM film 
WHERE film_id IN (
	SELECT film_id
	FROM film_actor 
	GROUP BY film_id 
	HAVING count(*) = 12
);


SELECT customer_id , sum(amount)
FROM payment 
GROUP BY customer_id 
HAVING sum(amount) > 175;

SELECT*
FROM customer;

SELECT*
FROM customer 
WHERE customer_id in(144, 526, 178, 459, 137, 148);















--1. List all customers who live in Texas (use JOINs)
SELECT c.first_name , c.last_name , a.district  
FROM customer c
JOIN address a 
ON c.address_id = a.address_id 
WHERE district = 'Texas';


--2. List all payments of more than $7.00 with the customer’s first and last name
--SELECT *
--FROM customer;
--
--SELECT *
--FROM payment ;

SELECT c.first_name, c.last_name, p.amount 
FROM customer c
JOIN payment p 
ON c.customer_id = p.customer_id 
WHERE amount > 7;

--3. Show all customer names who have made over $175 in payments (use
--subqueries)

SELECT *
FROM customer 
WHERE customer_id IN (
	SELECT customer_id
	FROM payment 
	GROUP BY customer_id 
	HAVING sum(amount) > 175
);


--4. List all customers that live in Argentina (use the city table)

SELECT cus.first_name, cus.last_name, a.district , ci.city, co.country
FROM country co
JOIN city ci
ON co.country_id = ci.country_id 
JOIN address a 
ON a.city_id = ci.city_id 
JOIN customer cus
ON cus.address_id = a.address_id 
WHERE ci.city_id IN (
	SELECT city_id
	FROM city 
	WHERE country_id = 6)


--5. Show all the film categories with their count in descending order

SELECT cat.category_id, name, count(*)
FROM film 
JOIN film_category fc
ON film.film_id = fc.film_id 
JOIN category cat
ON cat.category_id = fc.category_id 
GROUP BY cat.category_id, name
ORDER BY count(*) DESC

--6. What film had the most actors in it (show film info)?

SELECT  f.film_id, f.title, count(*)
FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id 
JOIN actor a 
ON a.actor_id = fa.actor_id 
GROUP BY f.film_id
ORDER BY count(*) DESC
LIMIT 1;



--7. Which actor has been in the least movies?

SELECT a.actor_id, first_name, last_name, count(*)
FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id 
JOIN actor a 
ON a.actor_id = fa.actor_id 
GROUP BY first_name, last_name, a.actor_id
ORDER BY count(*) ASC
LIMIT 1;

--8. Which country has the most cities?

SELECT country.country_id, count(*), country.country
FROM city
JOIN country 
ON city.country_id = country.country_id 
GROUP BY country.country_id
ORDER BY count(*) DESC
LIMIT 3

--9. List the actors who have been in between 20 and 25 films.

SELECT a.actor_id,  a.first_name, a.last_name, count(*)
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id 
JOIN film f 
ON f.film_id = fa.film_id 
GROUP BY a.actor_id, a.first_name , a.last_name 
HAVING count(*) BETWEEN 20 AND 25
ORDER BY count(*) DESC;



