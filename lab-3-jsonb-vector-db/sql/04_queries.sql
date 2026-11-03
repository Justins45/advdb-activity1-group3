-- JSONB Query 1
-- Written by Dylane Cunningham
-- This query retrieves the full name of users, the title of the content they rated, the number of stars they gave, and their review text. It filters for ratings with 4 or more stars and orders the results by stars in descending order and full name in ascending order.
SELECT u.f_name || ' ' || u.l_name AS "Full Name", t.title AS "Title", (a.events_data->>'stars')::int AS "Stars", a.events_data->>'review' AS "Review"
FROM activity a 
    JOIN users u ON u.user_id = a.user_id
    JOIN titles t ON t.title_id = a.title_id
WHERE a.events_data @> '{"type": "rate"}'
    AND (a.events_data->>'stars')::int >= 4
ORDER BY "Stars" DESC, "Full Name" ASC;

-- JSONB Query 2
-- Written by Justin S
-- This query gets all the users who have parental controls enabled, and have a set max rating value for their movies. It counts for each time that the rating appears, and orders it in decending order, with the most at the top.
SELECT
  viewing_preferences -> 'parental_controls' ->> 'max_rating' AS max_rating,
  COUNT(*) AS total_user_count
FROM users
WHERE (viewing_preferences -> 'parental_controls' ->> 'enabled')::boolean = true
GROUP BY max_rating
ORDER BY total_user_count DESC;

-- JSONB Query 3
-- Written by Justin S
-- This query gets all the users that have a preferred device list, and takes the count of all the times each device appears from the array in "preferred_devices" within that viewing_preferences JSONB column.
SELECT
  device,
  COUNT(*) AS device_count
FROM users u,
     jsonb_array_elements_text(u.viewing_preferences -> 'preferred_devices') AS device
GROUP BY device
ORDER BY device_count DESC;



-- Vector Query 1 - A search by meaning
-- Written by Umaya
-- Result: Shows top five titles most similar to the search phrase "something scary in the woods".
SELECT
    t.title_id,
    t.title,
    t.embedding <=> (
        SELECT sp.embedding
        FROM search_phrases sp
        WHERE sp.phrase_id = 4
    ) AS similarity
FROM titles t
ORDER BY similarity
LIMIT 5;

-- Vector Query 2 - A vector search combined with a filter from your other data
-- Written by Umaya
-- Result: Shows top five titles most similar to user Chloe Tremblay's (user_id = 5) last watched title, excluding titles they have already watched.
WITH last_watched AS (
    SELECT t.title_id, t.embedding
    FROM activity a
    JOIN titles t ON a.title_id = t.title_id
    WHERE a.user_id = 5
    ORDER BY activity_id DESC
    LIMIT 1
)
SELECT
    t.title_id, t.title, t.embedding <=> lw.embedding AS similarity
FROM titles t
CROSS JOIN last_watched lw
WHERE t.title_id <> lw.title_id
AND NOT EXISTS (
    SELECT 1
    FROM activity a
    WHERE a.user_id = 5
        AND a.title_id = t.title_id
        AND a.events_data ->> 'type' = 'play'
)
ORDER BY similarity
LIMIT 5;
