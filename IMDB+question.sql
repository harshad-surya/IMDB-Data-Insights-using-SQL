USE imdb;
/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
 
 -- Lets examine the tables for understanding data
 
SELECT * FROM movie;

SELECT * FROM ratings;

SELECT * FROM genre;

SELECT * FROM director_mapping;

SELECT * FROM role_mapping;

SELECT * FROM names;

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT count(*) as num_of_rows FROM movie;
SELECT count(*) as num_of_rows FROM genre;
SELECT count(*) as num_of_rows FROM director_mapping;
SELECT count(*) as num_of_rows FROM role_mapping;
SELECT count(*) as num_of_rows FROM ratings;
SELECT count(*) as num_of_rows FROM names;  

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT COUNT(*)-COUNT(id) As id, COUNT(*)-COUNT(title) As title_nulls, 
COUNT(*)-COUNT(year) As year,COUNT(*)-COUNT(date_published) As date_published_nulls,
COUNT(*)-COUNT(duration) As duration,COUNT(*)-COUNT(country) As country_nulls,
COUNT(*)-COUNT(worlwide_gross_income) As worlwide_gross_income_nulls,
COUNT(*)-COUNT(languages) As languages,COUNT(*)-COUNT(production_company) As production_company_nulls 
FROM movie; 

-- There are 20 nulls in country; 3724 nulls in worlwide_gross_income; 194 nulls in languages; 528 nulls in production_company.
 -- and id is primary key as per ERD


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- First Part
SELECT year as Year,count(id) as number_of_movies FROM movie group by year order by number_of_movies DESC;

-- Second Part 

SELECT MONTH(date_published) month_num, count(*) number_of_movies from movie group by MONTH(date_published) order by month_num;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
-- SELECT COUNT(*) FROM MOVIE WHERE COUNTRY='India' OR COUNTRY='USA' AND YEAR='2019';

select count(id) as num_of_movies from movie where (lower(country) LIKE '%india%'
   OR lower(country) LIKE '%usa%')
   AND year = 2019;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT GENRE AS GENRE FROM GENRE;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT GENRE, COUNT(movie_id) AS movie_count FROM GENRE GROUP BY GENRE ORDER BY movie_count DESC LIMIT 1;

-- Extracting only Genre Name Query
SELECT GENRE FROM GENRE GROUP BY GENRE ORDER BY COUNT(movie_id) DESC LIMIT 1;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


with genre_one as (
SELECT COUNT(*) AS COUNT FROM GENRE as G INNER JOIN MOVIE as M ON M.ID=G.MOVIE_ID GROUP BY G.MOVIE_ID HAVING COUNT=1)
SELECT COUNT(*) as num_of_movies FROM genre_one;



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT G.GENRE,AVG(M.DURATION) AS AVG_DURATION FROM GENRE as G LEFT JOIN MOVIE as M ON M.ID=G.MOVIE_ID GROUP BY G.GENRE;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
with rank_summary as (
select genre, count(movie_id) as movie_count,
RANK() OVER( ORDER BY count(movie_id) DESC) as genre_rank
from genre
GROUP BY genre)
select * from rank_summary where genre = 'Thriller';

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT MIN(avg_rating) AS min_avg_rating, MAX(avg_rating) AS max_avg_rating, 
MIN(total_votes) AS min_total_votes, MAX(total_votes) AS max_total_votes,
MIN(median_rating) AS min_median_rating, MAX(median_rating) AS max_median_rating 
from ratings;
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT title,avg_rating,
RANK() OVER(ORDER BY avg_rating DESC) as movie_rank 
FROM MOVIE as M left join RATINGS as R ON M.ID=R.MOVIE_ID
LIMIT 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating, COUNT(movie_id) AS movie_count FROM RATINGS GROUP BY MEDIAN_RATING ORDER BY MEDIAN_RATING ASC;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,COUNT(id)AS movie_count,
RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank 
FROM MOVIE INNER JOIN RATINGS ON ID=MOVIE_ID 
WHERE AVG_RATING>8 AND production_company IS NOT NULL GROUP BY production_company limit 1;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with movie_summary as (

select m.id from movie as m inner join ratings as r on m.id = r.movie_id where 
(lower(m.country) like '%usa%') and (m.year = 2017) and (r.total_votes > 1000)
and (extract(month from m.date_published) = 3))
select g.genre,count(id) as movie_count from genre as g inner join movie_summary on g.movie_id = movie_summary.id
group by g.genre
order by movie_count desc;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT title,avg_rating,genre
FROM movie AS m INNER JOIN genre AS g ON m.id =g.movie_id INNER JOIN ratings AS r ON m.id = r.movie_id
WHERE title like 'The%' AND avg_rating>8
ORDER BY  avg_rating,genre DESC;




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(id) as num_movies
FROM MOVIE as M INNER JOIN RATINGS as R ON M.ID=R.MOVIE_ID 
WHERE (M.date_published between '2018-04-01' AND  '2019-04-01') AND R.MEDIAN_RATING = 8;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


WITH votes_summary AS
(
SELECT 
	COUNT(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN m.id END) AS german_movie_count,
	COUNT(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN m.id END) AS italian_movie_count,
	SUM(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN r.total_votes END) AS german_movie_votes,
	SUM(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN r.total_votes END) AS italian_movie_votes
FROM movie AS m INNER JOIN ratings AS r ON m.id = r.movie_id
)
SELECT 
    ROUND(german_movie_votes / german_movie_count, 2) AS german_votes,
    ROUND(italian_movie_votes / italian_movie_count, 2) AS italian_votes
FROM votes_summary;



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT COUNT(*)-COUNT(name) As name_nulls,COUNT(*)-COUNT(height) As height_nulls,
COUNT(*)-COUNT(date_of_birth) As date_of_birth_nulls,  
COUNT(*)-COUNT(known_for_movies) As known_for_movies_nulls
FROM names; 


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_rated_genres AS
(
SELECT genre,COUNT(m.id) AS movie_count,
	RANK () OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM genre AS g LEFT JOIN movie AS m ON g.movie_id = m.id INNER JOIN ratings AS r ON m.id=r.movie_id
WHERE avg_rating>8
GROUP BY genre
)
SELECT n.name as director_name,COUNT(m.id) AS movie_count
FROM names AS n INNER JOIN director_mapping AS d ON n.id=d.name_id
	INNER JOIN movie AS m ON d.movie_id = m.id INNER JOIN ratings AS r ON m.id=r.movie_id
	INNER JOIN genre AS g ON g.movie_id = m.id
WHERE g.genre IN (SELECT DISTINCT genre FROM top_rated_genres WHERE genre_rank<=3)
		AND avg_rating>8
GROUP BY name
ORDER BY movie_count DESC
LIMIT 3;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT N.name as actor_name,count(*) as movie_count 
FROM ROLE_MAPPING as R INNER JOIN NAMES as N ON R.NAME_ID=N.ID
INNER JOIN RATINGS as RA ON R.MOVIE_ID=RA.MOVIE_ID
WHERE  R.CATEGORY='actor' and RA.median_rating>=8
group by N.name  
order by count(*) desc limit 2;



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH top_prod_summary AS
(
SELECT m.production_company,SUM(r.total_votes) AS vote_count,
RANK() OVER (ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM movie AS m LEFT JOIN ratings AS r ON m.id = r.movie_id
WHERE m.production_company IS NOT NULL
GROUP BY m.production_company
)
SELECT * FROM top_prod_summary WHERE prod_comp_rank <= 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
with movie_summary as (
select m.id,r.avg_rating,r.total_votes,n.name  from
ratings as r inner join movie as m on r.movie_id = m.id
inner join role_mapping as rm on rm.movie_id = m.id
inner join names as n on n.id = rm.name_id
where lower(m.country) like '%india%'
and rm.category = 'actor'),
count_summary as ( 
select name,count(id) as movie_count,sum(total_votes) as total_votes,
round(sum(total_votes*avg_rating)/sum(total_votes),2) as weighted_avg
from  movie_summary
group by name)
select name as actor_name,total_votes,movie_count,weighted_avg as actor_avg_rating,
RANK() OVER(ORDER BY weighted_avg desc,total_votes desc) AS actor_rank 
 from count_summary where movie_count >= 5 
 order by weighted_avg desc
;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_ratings AS
(
SELECT n.name as actress_name,SUM(r.total_votes) AS total_votes,COUNT(m.id) as movie_count,
	ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actress_avg_rating
FROM names AS n INNER JOIN role_mapping AS a ON n.id=a.name_id
INNER JOIN movie AS m ON a.movie_id = m.id
INNER JOIN ratings AS r ON m.id=r.movie_id
WHERE category = 'actress' AND LOWER(languages) like '%hindi%'
GROUP BY actress_name
)
SELECT *,
	ROW_NUMBER() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM actress_ratings WHERE movie_count>=3 LIMIT 5;




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT title,
CASE
    WHEN avg_rating > 8 THEN 'Superhit movies'
    WHEN avg_rating between 7 and 8 THEN 'Hit movies'
    WHEN avg_rating between 5 and 7  THEN 'One-time-watch movies'
    WHEN avg_rating <5 THEN 'Flop movies'
END AS CATEGORY
FROM genre g INNER JOIN ratings r INNER JOIN movie m on m.id=g.movie_id and m.id=r.movie_id and genre='Thriller'; 


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_summary AS
(
SELECT genre,ROUND(AVG(duration),2) AS avg_duration
FROM genre AS g INNER JOIN movie AS m ON g.movie_id = m.id
GROUP BY genre
)
SELECT *,
	SUM(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    AVG(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration
FROM
	genre_summary;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_genres_summary AS
(
SELECT genre,COUNT(m.id) AS movie_count,
	RANK () OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM genre AS g INNER JOIN movie AS m ON g.movie_id = m.id
GROUP BY genre
),
top_grossing_summary AS
(
SELECT g.genre,year,m.title as movie_name,worlwide_gross_income,
    RANK() OVER 
    (PARTITION BY g.genre, year ORDER BY CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) 
    AS movie_rank
FROM movie AS m INNER JOIN genre AS g ON g.movie_id = m.id
WHERE g.genre IN (SELECT DISTINCT genre FROM top_genres_summary WHERE genre_rank<=3)
)
SELECT * FROM top_grossing_summary WHERE movie_rank<=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


WITH top_prod_summary AS
(
SELECT m.production_company,COUNT(m.id) AS movie_count,
RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
FROM movie AS m LEFT JOIN ratings AS r ON m.id = r.movie_id
WHERE median_rating>=8 AND m.production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY m.production_company
)
SELECT * FROM top_prod_summary WHERE prod_comp_rank <= 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH actress_ratings AS
(
SELECT n.name as actress_name,SUM(r.total_votes) AS total_votes,COUNT(m.id) as movie_count,
	ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actress_avg_rating
FROM names AS n INNER JOIN role_mapping AS rm ON n.id=rm.name_id
INNER JOIN movie AS m ON rm.movie_id = m.id
INNER JOIN ratings AS r ON m.id=r.movie_id
INNER JOIN genre AS g ON m.id=g.movie_id
WHERE category = 'actress' AND lower(g.genre) ='drama' and r.avg_rating>8
GROUP BY actress_name
)
SELECT *,
	ROW_NUMBER() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM actress_ratings LIMIT 3;
 

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH top_directors_summary AS
(
SELECT n.id as director_id,n.name as director_name,COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) as director_rank
FROM names AS n INNER JOIN director_mapping AS d ON n.id=d.name_id
INNER JOIN movie AS m ON d.movie_id = m.id
GROUP BY n.id
),
movie_summary AS
(
SELECT n.id as director_id,n.name as director_name,m.id AS movie_id,
    m.date_published,r.avg_rating,r.total_votes,m.duration,
    LEAD(date_published) OVER (PARTITION BY n.id ORDER BY m.date_published) AS next_date_published,
    DATEDIFF(LEAD(date_published) OVER (PARTITION BY n.id ORDER BY m.date_published),date_published) AS inter_movie_days
FROM names AS n INNER JOIN director_mapping AS d ON n.id=d.name_id
INNER JOIN movie AS m ON d.movie_id = m.id
INNER JOIN ratings AS r ON m.id=r.movie_id
WHERE n.id IN (SELECT director_id FROM top_directors_summary WHERE director_rank<=9)
)
SELECT director_id,director_name,COUNT(DISTINCT movie_id) as number_of_movies,
	ROUND(AVG(inter_movie_days),0) AS avg_inter_movie_days,
	ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM movie_summary
GROUP BY director_id
ORDER BY number_of_movies DESC, avg_rating DESC;