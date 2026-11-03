-- 1. A search by meaning
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



-- 2. A vector search combined with a filter from your other data
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