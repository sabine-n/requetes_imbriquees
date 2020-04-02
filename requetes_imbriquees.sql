USE sakila;

-- 1. Avec une requête imbriquée sélectionner tout les acteurs ayant joués dans les films ou a joué « MCCONAUGHEY CARY ».

SELECT DISTINCT concat(a.first_name, ' ', a.last_name) as acteur
FROM actor a
JOIN film_actor fa on a.actor_id = fa.actor_id
JOIN film f on fa.film_id = f.film_id
WHERE  f.film_id in (
SELECT f.film_id 
FROM film  f
JOIN film_actor fa on f.film_id = fa.film_id 
JOIN actor a on a.actor_id = fa.actor_id and (a.last_name = "MCCONAUGHEY" and a.first_name = "CARY"));

-- 2. Afficher tout les acteurs n’ayant pas joués dans les films ou a joué « MCCONAUGHEY CARY ».
SELECT DISTINCT concat(a.first_name, ' ', a.last_name) as acteur
FROM actor a
JOIN film_actor fa on a.actor_id = fa.actor_id
JOIN film f on fa.film_id = f.film_id
WHERE  f.film_id not in (
SELECT f.film_id 
FROM film  f
JOIN film_actor fa on f.film_id = fa.film_id 
JOIN actor a on a.actor_id = fa.actor_id and (a.last_name = "MCCONAUGHEY" and a.first_name = "CARY"));

-- 3. Afficher Uniquement le nom du film qui contient le plus d'acteur et le nombre d'acteurs associé sans utiliser LIMIT (2 niveaux de sousrequêtes).
SELECT f.title, count(actor_id) as nb
FROM film  f
JOIN film_actor fa on f.film_id = fa.film_id 
GROUP BY f.film_id
--  JOIN actor a on a.actor_id = fa.actor_id
having nb = (SELECT max(a.cnt) FROM (
	SELECT count(actor_id) as cnt from film_actor
    group by film_id) a);

-- Afficher les acteurs ayant joué uniquement dans des films d’actions (Utiliser EXISTS)

SELECT DISTINCT concat(a.first_name, ' ', a.last_name) as acteur
FROM actor a
JOIN film_actor fa on a.actor_id = fa.actor_id
JOIN film f on fa.film_id = f.film_id
WHERE EXISTS (
SELECT f.film_id FROM film f
JOIN film_category fc on f.film_id = fc.film_id
JOIN category c on fc.category_id = c.category_id and c.name = 'action'
)
	