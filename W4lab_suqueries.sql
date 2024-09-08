-- Challenge

-- Write SQL queries to perform the following tasks using the Sakila database:

-- 1) Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

USE sakila;

SELECT 
    COUNT(*) AS number_of_copies
FROM 
    sakila.inventory AS i
WHERE 
    i.film_id = (
        SELECT 
            f.film_id
        FROM 
            sakila.film AS f
        WHERE 
            f.title = 'Hunchback Impossible'
    );


-- 2) List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT 
    title, 
    length
FROM 
    sakila.film
WHERE 
    length > (SELECT AVG(length) FROM sakila.film);



-- 3 )Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT a.first_name, a.last_name
FROM sakila.actor AS a
JOIN sakila.film_actor AS fa 
ON fa.actor_id = a.actor_id
JOIN sakila.film AS f ON f.film_id = fa.film_id
WHERE f.title = 'Alone Trip';


-- Bonus:

-- 4) Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

SELECT f.title 
FROM sakila.film as f
JOIN sakila.film_category as fc
ON fc.film_id = f.film_id
JOIN sakila.category as c
ON c.category_id = fc.category_id
WHERE c.name ="Family";


-- 5 )Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT c.last_name,c.first_name, c.email
FROM sakila.customer as c
JOIN sakila.address as a
ON a.address_id = c.address_id
JOIN sakila.city as ci
ON ci.city_id = a.city_id
JOIN sakila.country as co
ON co.country_id = ci.country_id
WHERE co.country = "Canada";

-- 6) Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.


SELECT actor_id, COUNT(actor_id) AS actor_count
FROM sakila.film_actor
GROUP BY actor_id
ORDER BY actor_count DESC
LIMIT 1;


-- 7) Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.


SELECT customer_id, cust_amount
FROM (
    SELECT customer_id, SUM(amount) AS cust_amount
    FROM sakila.payment
    GROUP BY customer_id
) AS subquery
ORDER BY cust_amount DESC
LIMIT 1;
WITH max_customer AS (
    SELECT customer_id
    FROM (
        SELECT customer_id, SUM(amount) AS cust_amount
        FROM sakila.payment
        GROUP BY customer_id
    ) AS subquery
    ORDER BY cust_amount DESC
    LIMIT 1
)

SELECT f.film_id, f.title
FROM sakila.rental r
JOIN max_customer mc ON r.customer_id = mc.customer_id
JOIN sakila.inventory i ON r.inventory_id = i.inventory_id
JOIN sakila.film f ON i.film_id = f.film_id;





-- 8)  Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

SELECT AVG(cust_amount) AS avg_amount
FROM (
    SELECT customer_id, SUM(amount) AS cust_amount
    FROM sakila.payment
    GROUP BY customer_id
) AS subquery1;
