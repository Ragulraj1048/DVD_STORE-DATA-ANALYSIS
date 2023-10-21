
 use sakila;
 
--  film
 select * from actor;
 select * from film_actor;
 select * from film;
 select * from language;
 select * from film_category;
 select * from category;
 
--  store
 select * from city;
 select * from country;
 select * from address;
 select * from store;
 select * from staff;
 select * from inventory;
 
--  payment
 select * from customer;
 select * from rental;
 select * from payment;
 select * from store;
 select * from staff;
 select * from inventory;
 
--  1. What is the total number of movie titles in the store's inventory, categorized by rating (G, PG, PG-13, R)?

--  select film.rating, count(*) from film inner join inventory on film.film_id=inventory.film_id
-- group by rating;

--  select * from film;

select film.rating, count(film.language_id) from film 
group by rating;

-- 2. What are the top 3 most rented movies in the store and how many times have they been rented?

-- select * from rental;
-- select * from film;
-- select * from inventory;

-- SELECT INVENTORY_ID, COUNT(*) FROM RENTAL GROUP BY INVENTORY_ID ORDER BY COUNT(*) DESC ;
-- film>> inventory>> rental

select film.title, COUNT(rental.rental_id) AS rental_count
from film
inner join inventory on film.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
group by film.title
order by rental_count DESC
limit 3;

-- 3. Who are the top 5 customers with the highest total rental payments?

 
-- select * from CUSTOMER;
-- select * from PAYMENT;
-- customer>> payment

select customer.customer_id,
customer.first_name, customer.last_name, sum(payment.amount) as total_amount
from customer 
 inner join payment on customer.customer_id=payment.customer_id 
 group by customer.customer_id
 order by total_amount desc 
 limit 5;


-- 4. What are the top 5 movie genres with the highest replacement cost?

--  select * from film;
--  select * from film_category;
--  select * from category;
-- film>> film_category>> category(genre)
-- rename category as genre, rename  sum(film.replacement_cost) as replacement cost

select category.name as genre, sum(film.replacement_cost) as replacement_cost
from film
inner join film_category on film.film_id=film_category.film_id
inner join category on film_category.category_id=category.category_id
group by category.name
order by sum(film.replacement_cost) desc
limit 5
;


select sum(replacement_cost)from film;
-- select 
--     category.name AS CategoryName,
--     SUM(film.replacement_cost) AS TotalReplacementCost,
--     (SUM(film.replacement_cost) / (select sum(replacement_cost)from film) * 100) AS ReplacementCostPercentage
-- from 
--     film
-- inner join 
--     film_category ON film.film_id = film_category.film_id
-- inner join
--     category ON film_category.category_id = category.category_id
-- group by
--     category.name
-- order by
--     ReplacementCostPercentage DESC
-- ;

-- 5.How many movies in each category have not been rented yet?

 --  select * from film_category;
--  select * from category;
--  select * from inventory;
--   select * from rental ;
  
--   count(*) simply counts all rows

-- SELECT * 
-- FROM category
-- right join film_category ON category.category_id = film_category.category_id
-- left join inventory ON film_category.film_id  = inventory.film_id
-- left join rental ON inventory.inventory_id = rental.inventory_id
-- where rental.rental_id IS NULL
-- ;

-- category(category_id)>> film_category(film_id)>> inventory(inventory_id)>> rental
--
select category.name as genre, COUNT(*) AS notrented_movies
FROM category
left join film_category ON category.category_id = film_category.category_id
left join inventory ON film_category.film_id  = inventory.film_id
left join rental ON inventory.inventory_id = rental.inventory_id
where rental.rental_id is null                                       -- (it  select all rows withn null )
group by genre;

-- 6.What are the top 5 countries with the highest number of customers?

--  select * from city;
--  select * from country;
--  select * from customer;
--  select * from address;
 
--  country>> city>> address>> customer
-- country is renamed as country_name, count(customer.customer_id) renamed as customer_count
select  country.country as country_name, count(customer.customer_id) as customer_count
FROM country
inner join city ON country.country_id = city.country_id
inner join address ON city.city_id = address.city_id
inner join customer ON address.address_id = customer.address_id
group by country.country
order by customer_count desc
limit 5;

-- 7.What is the total no of DVDs in each store?

--  select * from inventory;

select store_id, COUNT(inventory_id) as total_dvds
from inventory
group by store_id;

-- 8.Who are the top 5 actors with the most movie acted?

--  select * from actor;
--  select * from film_actor;

-- actor>> film_actor
-- count(film_actor.film_id) renamed as movies_acted 
select actor.actor_id, actor.first_name, count(film_actor.film_id) as movies_acted 
from actor 
inner join film_actor 
on actor.actor_id= film_actor.actor_id
group by actor.actor_id
order by count(film_actor.film_id) desc
limit 5;
