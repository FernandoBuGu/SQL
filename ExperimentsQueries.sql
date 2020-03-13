/*Find the names of experiments performed by Prof. Pain after Jan 1, 2004. */
SELECT name
FROM Experiments
WHERE whoperformed = 'Prof. Pain'
AND date > '2004-01-01';