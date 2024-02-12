select* 
from album2;

show tables;
describe invoice_line;
describe customer;

-- 1. Who is the senior most employee based on job title?

select*
from employee
order by levels desc
limit 1;

-- 2. Which countries have the most Invoices?

select count(*) as country, billing_country
from invoice
group by billing_country
order by country desc
limit 1;

--  3. What are top 3 values of total invoice?

select*
from invoice
order by total desc
limit 3;

-- 4. Which city has the best customers? We would like to throw a promotional Music
-- Festival in the city we made the most money. Write a query that returns one city that
-- has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

select sum(total), billing_city
from invoice
group by billing_city
order by sum(total) desc
limit 1;

-- 5. Who is the best customer? The customer who has spent the most money will be declared the best customer.
 -- Write a query that returns the person who has spent the most money Question
 
 select customer_id, concat(first_name, " " ,last_name) as "Full_Name", sum(total) as "Total" 
 from invoice join customer  using (customer_id)
 group by customer_id, Full_Name
 order by Total desc
 limit 1;
 
 -- 6 Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
 -- Return your list ordered alphabetically by email starting with A
 
 
  select concat(first_name," ",last_name) as "NAME", email, genre.name, customer_id
 from customer join invoice using (customer_id) join invoice_line using (invoice_id) join track using (track_id) join genre using (genre_id)
 where email like "A%" and genre.name like "Rock"
 group by  NAME, email, genre.name, customer_id;
 
 -- 7 Let's invite the artists who have written the most rock music in our dataset. 
 -- Write a query that returns the Artist name and total track count of the top 10 rock bands

select name , count(artist_id) as "total_track"
from artist join album2 using (artist_id)
group by name
order by total_track desc
limit 10;

-- 8 Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

select name, milliseconds
from track
where  milliseconds >  (select  avg(milliseconds)
from track)
order by milliseconds desc ;

-- 9 Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent

select concat(first_name," ",last_name) as "Custumer_Name", sum(total), artist.name as "Artist Name"
from customer join invoice using (customer_id) join invoice_line using (invoice_id) join track using (track_id) join 
album2 using (album_id) join artist using (artist_id)
group by 1, 3
order by sum(total) desc;

 
 
 -- 10 We want to find out the most popular music Genre for each country.
 -- We determine the most popular genre as the genre with the highest amount of purchases.
 -- Write a query that returns each country along with the top Genre. 
 -- For countries where the maximum number of purchases is shared return all Genres
  
select count(quantity) as Quantity, genre.name as Genre_name, genre_id 
from invoice join invoice_line using (invoice_id) join track using (track_id) join genre using (genre_id)
group by Genre_name,  genre_id 
order by Quantity desc;
 
select count(quantity) as Quantity, genre.name as Genre_name, genre_id , billing_country
from invoice join invoice_line using (invoice_id) join track using (track_id) join genre using (genre_id)
group by Genre_name,  genre_id , billing_country
order by Quantity desc;

-- 11. Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount

WITH RECURSIVE
	sales_per_country AS(
		SELECT COUNT(*) AS purchases_per_genre, customer.country, genre.name, genre.genre_id
		FROM invoice_line
		JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
		JOIN customer ON customer.customer_id = invoice.customer_id
		JOIN track ON track.track_id = invoice_line.track_id
		JOIN genre ON genre.genre_id = track.genre_id
		GROUP BY 2,3,4
		ORDER BY 2
	),
	max_genre_per_country AS (SELECT MAX(purchases_per_genre) AS max_genre_number, country
		FROM sales_per_country
		GROUP BY 2
		ORDER BY 2)

SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;

 
 