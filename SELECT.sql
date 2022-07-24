/* Название и год выхода альбомов, вышедших в 2018 году */
SELECT album_name AS "Название альбома",
       release_year AS "Год выхода"
  FROM albums
 WHERE release_year = 2018;

/* Название и продолжительность самого длительного трека */
SELECT song_name AS "Название трека",
       lasting / 60 AS "Продолжительность, мин",
       lasting % 60 AS "сек"
  FROM songs
 WHERE lasting = (
       SELECT MAX(lasting)
	     FROM songs);

/* Название треков, продолжительность которых не менее 3,5 минуты */
SELECT song_name AS "Название трека"
  FROM songs
 WHERE lasting >= 210;

/* Названия сборников, вышедших в период с 2018 по 2020 год включительно */
SELECT collection_name AS "Название альбома"
  FROM collections
 WHERE release_year BETWEEN 2018 AND 2020;

/* Исполнители, чье имя состоит из 1 слова */
SELECT artist_name AS "Исполнитель"
  FROM artists
 WHERE artist_name NOT LIKE '% %';

/* Название треков, которые содержат слово "мой"/"my" */
SELECT song_name AS "Название трека"
  FROM songs
 WHERE LOWER(song_name) LIKE '%my%'
	OR LOWER(song_name) LIKE '%мой%';

