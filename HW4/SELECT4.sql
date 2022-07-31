/* количество исполнителей в каждом жанре */
SELECT g.genre_name AS "Жанр",
       COUNT(a.artist_name) AS "Количество исполнителей"
  FROM artists AS a
       INNER JOIN artist_genre AS ag
	           ON a.artist_id = ag.artist_id
       INNER JOIN genres AS g
               ON ag.genre_id = g.genre_id
 GROUP BY g.genre_name
 ORDER BY COUNT(a.artist_name) desc;

/* количество треков, вошедших в альбомы 2019-2020 годов */
SELECT COUNT(s.song_name) AS "Количество треков"
  FROM songs AS s
       INNER JOIN albums AS a
	           ON s.album_id = a.album_id
 WHERE a.release_year BETWEEN 2019 AND 2020;

/* средняя продолжительность треков по каждому альбому */
SELECT a.album_name AS "Название альбома",
       ROUND(AVG(s.lasting)) AS "Среднее время треков, сек"
  FROM songs as s
       INNER JOIN albums AS a
	           ON s.album_id = a.album_id
 GROUP BY a.album_name
 ORDER BY ROUND(AVG(s.lasting));

/* все исполнители, которые не выпустили альбомы в 2020 году */
SELECT artist_name AS "Исполнитель"
  FROM artists
 WHERE artist_name NOT IN(
       SELECT a.artist_name
         FROM artists AS a
        INNER JOIN artist_album AS aa
	            ON a.artist_id = aa.artist_id
	    INNER JOIN albums AS al
	            ON al.album_id = aa.album_id
	    WHERE al.release_year = 2020
	    GROUP BY a.artist_name);
	   
/* названия сборников, в которых присутствует конкретный исполнитель (Little Big) */
SELECT c.collection_name AS "Сборники с Little Big"
  FROM collections as c
 INNER JOIN collection_song AS cs
	     ON c.collection_id = cs.collection_id
 INNER JOIN songs AS s
	     ON s.song_id = cs.song_id
 INNER JOIN albums AS al
	     ON al.album_id = s.album_id
 INNER JOIN artist_album AS aa
	     ON al.album_id = aa.album_id
 INNER JOIN artists AS a
	     ON a.artist_id = aa.artist_id
 WHERE artist_name ILIKE 'little big'
 GROUP BY c.collection_name;

/* название альбомов, в которых присутствуют исполнители более 1 жанра */
SELECT DISTINCT al.album_name AS "Альбом"
  FROM albums AS al
 INNER JOIN artist_album 	AS 	aa 
         ON al.album_id = aa.album_id 
 INNER JOIN artists AS a 
         ON a.artist_id = aa.artist_id
 INNER JOIN artist_genre AS ag 
         ON ag.artist_id = a.artist_id 
 INNER JOIN genres AS g 
         ON g.genre_id = ag.genre_id 
 GROUP BY al.album_name, 
          a.artist_name
HAVING COUNT(DISTINCT g.genre_name) > 1;

/* наименование треков, которые не входят в сборники */

/* вариант 1 */
SELECT song_name AS "Треки не входящие в сборники"
  FROM songs
 WHERE song_name NOT IN(
               SELECT s.song_name
                 FROM songs AS s
                INNER JOIN collection_song AS cs
	                    ON s.song_id = cs.song_id
                INNER JOIN collections AS c
	                    ON c.collection_id = cs.collection_id
                GROUP BY s.song_name);
               
/* вариант 2 */
SELECT s.song_name  AS "Треки не входящие в сборники"
  FROM songs AS s
  LEFT JOIN collection_song AS cs
	     ON s.song_id = cs.song_id
 WHERE cs.song_id IS NULL;
 
/* исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько) */
SELECT a.artist_name AS "Исполнители"
  FROM artists AS a 
 INNER JOIN artist_album AS aa
	     ON a.artist_id = aa.artist_id
 INNER JOIN albums AS al
	     ON al.album_id = aa.album_id
 INNER JOIN songs AS s
	     ON s.album_id = al.album_id
 WHERE s.lasting = (
       SELECT MIN(lasting) 
         FROM songs);
         
/* название альбомов, содержащих наименьшее количество треков */
SELECT a.album_name AS "Альбом"
  FROM albums AS a 
 INNER JOIN songs AS s
         ON a.album_id = s.album_id 
 GROUP BY a.album_name 
HAVING COUNT(s.song_name) = (
       SELECT MIN(tracks) 
       FROM (
              SELECT COUNT(s.song_name) AS tracks
                FROM albums AS a 
               INNER JOIN songs AS s
                       ON a.album_id = s.album_id 
               GROUP BY a.album_name) 		
                  AS foo);