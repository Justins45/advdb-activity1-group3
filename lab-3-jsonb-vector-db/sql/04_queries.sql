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