-- Filter bnbs based on specific criteria


SELECT booking_id,
	listing_name,
	host_id,
	host_name,
	neighbourhood,
	room_type,
	price
FROM PortfolioProject..bnb_nyc_2019
WHERE neighbourhood_group = 'Manhattan' AND room_type = 'Entire home/apt' AND price <= 200;


-- Finding the top hosts with the most listings



SELECT TOP (10) host_id,
	COUNT(*) AS listing_count

FROM PortfolioProject..bnb_nyc_2019
GROUP BY host_id
ORDER BY listing_count DESC;



-- Finding the highest-rated listings



SELECT TOP (10) booking_id,
	listing_name,
	neighbourhood,
	room_type,
	price,
	number_of_reviews

FROM PortfolioProject..bnb_nyc_2019
ORDER BY number_of_reviews DESC;



-- OVER


-- Average Price with OVER


SELECT
	booking_id,
	listing_name,
	neighbourhood_group,
	AVG(price) OVER() AS avg_price
FROM PortfolioProject..bnb_nyc_2019;


-- Average, Minimum, Maximum price with OVER


SELECT
	booking_id,
	listing_name,
	neighbourhood_group,
	AVG(price) OVER() avg_price,
	MIN(price) OVER() min_price,
	MAX(price) OVER() max_price
FROM PortfolioProject..bnb_nyc_2019;


-- Difference from average price with OVER and rounding the average price into 2 decimal points.


SELECT
	booking_id,
	listing_name,
	neighbourhood_group,
	price,
	ROUND(AVG(price) OVER(), 2) AS avg_price,
	ROUND((price- AVG(price) OVER()), 2) AS diff_from_avg
FROM PortfolioProject..bnb_nyc_2019;


-- Percent of average price with OVER


SELECT
	booking_id,
	listing_name,
	neighbourhood_group,
	price,
	ROUND(AVG(price) OVER(), 2) AS avg_price,
	ROUND((price / AVG(price) OVER() * 100), 2) AS percent_of_avg_price
FROM PortfolioProject..bnb_nyc_2019;


-- Percent difference from average price: calculating the percentage difference between each booking's price and the overall average price.


SELECT
	booking_id,
	listing_name,
	neighbourhood_group,
	price,
	ROUND(AVG(price) OVER(), 2) AS avg_price,
	ROUND((price / AVG(price) OVER() - 1) * 100, 2) AS percent_diff_from_avg_price
FROM PortfolioProject..bnb_nyc_2019;


-- PARTITION BY

-- PARTITION BY neighbourhood group


SELECT
	booking_id,
	listing_name,
	neighbourhood_group,
	neighbourhood,
	price,
	AVG(price) OVER (
	PARTITION BY neighbourhood_group
	) AS avg_price_by_neigh_group

FROM PortfolioProject..bnb_nyc_2019;



-- PARTITION BY neighbourhood group and neighbourhood

SELECT
	booking_id,
	listing_name,
	neighbourhood_group,
	neighbourhood,
	price,
	AVG(price) OVER (PARTITION BY neighbourhood_group) AS avg_price_by_neigh_group,
	AVG(price) OVER (PARTITION BY neighbourhood_group, neighbourhood) AS avg_price_by_neigh_group_and_neigh

FROM PortfolioProject..bnb_nyc_2019;


-- ROW NUMBER

-- Overall price rank

SELECT
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	booking_id,
	listing_name,
	neighbourhood_group,
	neighbourhood,
	price

FROM PortfolioProject..bnb_nyc_2019;


-- neighbourhood price rank

SELECT
	ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh_group_price_rank,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	booking_id,
	listing_name,
	neighbourhood_group,
	neighbourhood,
	price

FROM PortfolioProject..bnb_nyc_2019;


-- Top 3

SELECT
	ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh_group_price_rank,
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	booking_id,
	listing_name,
	neighbourhood_group,
	neighbourhood,
	price,
	CASE
		WHEN ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) <= 3 THEN 'Yes'
		ELSE 'No'
	END AS top3_flag

FROM PortfolioProject..bnb_nyc_2019;

-- Using RANK

SELECT
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	RANK() OVER(ORDER BY price DESC) AS overall_price_rank_with_rank,
	ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh_group_price_rank,
	RANK() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh_group_price_rank_with_rank,
	booking_id,
	listing_name,
	neighbourhood_group,
	neighbourhood,
	price

FROM PortfolioProject..bnb_nyc_2019;


 -- Dense Rank

 SELECT
	ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
	RANK() OVER(ORDER BY price DESC) AS overall_price_rank_with_rank,
	DENSE_RANK() OVER(ORDER BY price DESC) AS overall_price_rank_with_dense_rank,
	booking_id,
	listing_name,
	neighbourhood_group,
	neighbourhood,
	price

FROM PortfolioProject..bnb_nyc_2019;


-- LAG 

SELECT
	booking_id,
	listing_name,
	host_name,
	price,
	last_review,
	LAG(price) OVER(PARTITION BY host_name ORDER BY last_review)

FROM PortfolioProject..bnb_nyc_2019;  


-- LAG by 2 periods

SELECT
	booking_id,
	listing_name,
	host_name,
	price,
	last_review,
	LAG(price, 2) OVER(PARTITION BY host_name ORDER BY last_review)

FROM PortfolioProject..bnb_nyc_2019;  


-- LEAD

SELECT
	booking_id,
	listing_name,
	host_name,
	price,
	last_review,
	LEAD(price) OVER(PARTITION BY host_name ORDER BY last_review)

FROM PortfolioProject..bnb_nyc_2019;  

-- LEAD by 2 period

SELECT
	booking_id,
	listing_name,
	host_name,
	price,
	last_review,
	LEAD(price, 2) OVER(PARTITION BY host_name ORDER BY last_review)

FROM PortfolioProject..bnb_nyc_2019;  


-- Top 3 flags with subquery to select only the 'Yes' values in the top3_flag column

SELECT * FROM (
	SELECT
		ROW_NUMBER() OVER(ORDER BY price DESC) AS overall_price_rank,
		ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) AS neigh_group_price_rank,
		booking_id,
		listing_name,
		neighbourhood_group,
		neighbourhood,
		price,
		CASE
			WHEN ROW_NUMBER() OVER(PARTITION BY neighbourhood_group ORDER BY price DESC) <= 3 THEN 'Yes'
			ELSE 'No'
		END AS top3_flag
	FROM PortfolioProject..bnb_nyc_2019
	) a
WHERE top3_flag = 'Yes'