-- Starting by scanning the tables

SELECT *
FROM PortfolioProject..chat

SELECT * 
FROM PortfolioProject..video_play

-- Identifying the unique games in video_play table

SELECT DISTINCT game
FROM PortfolioProject..video_play

-- Getting the most popular game in video_play table

SELECT game, COUNT(game)
FROM PortfolioProject..video_play
GROUP BY game
ORDER BY COUNT(game) DESC

-- Creating a list of countries and their number of LOL viewers

SELECT country, COUNT(country)
FROM PortfolioProject..video_play
WHERE game = 'League of Legends'
GROUP BY country
ORDER BY COUNT(country) DESC

-- Creating a list of players and their number of streamers

SELECT player, COUNT(player)
FROM PortfolioProject..video_play
GROUP BY player
ORDER BY COUNT(player) DESC

-- Creating a new column for each of tha game's genre

SELECT game,
	CASE 
		WHEN game = 'DOTA 2'
			THEN 'MOBA'
		WHEN game = 'League of Legends'
			THEN 'MOBA'
		WHEN game = 'Heroes of Storm'
			THEN 'MOBA'
		WHEN game = 'Counter-Strike: Global Offensive'
			THEN 'FPS'
		WHEN game = 'DayZ'
			THEN 'Survival'
		WHEN game = 'ARK: Survival Evolved'
			THEN 'Survival'
		ELSE 'Other'
		END as 'genre',
		COUNT(game) TotalNumberPlayers

FROM PortfolioProject..video_play
Where game is not null
GROUP BY game
ORDER BY COUNT(game) DESC

-- Joing the two tables

SELECT *
FROM PortfolioProject..chat c
JOIN PortfolioProject..video_play vp
	ON c.device_id = vp.device_id

-- Finding the total stream format for each channel

SELECT vp.channel, vp.stream_format, COUNT(vp.stream_format) AS TotalStreamFormat
FROM PortfolioProject..video_play vp
LEFT JOIN PortfolioProject..chat c
	ON vp.device_id = c.device_id 
WHERE vp.stream_format is not null
GROUP BY vp.channel, vp.stream_format
ORDER BY vp.channel, COUNT(vp.stream_format)


