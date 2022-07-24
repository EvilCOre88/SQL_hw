/* �������� � ��� ������ ��������, �������� � 2018 ���� */
SELECT album_name AS "�������� �������",
       release_year AS "��� ������"
  FROM albums
 WHERE release_year = 2018;

/* �������� � ����������������� ������ ����������� ����� */
SELECT song_name AS "�������� �����",
       lasting / 60 AS "�����������������, ���",
       lasting % 60 AS "���"
  FROM songs
 WHERE lasting = (
       SELECT MAX(lasting)
	     FROM songs);

/* �������� ������, ����������������� ������� �� ����� 3,5 ������ */
SELECT song_name AS "�������� �����"
  FROM songs
 WHERE lasting >= 210;

/* �������� ���������, �������� � ������ � 2018 �� 2020 ��� ������������ */
SELECT collection_name AS "�������� �������"
  FROM collections
 WHERE release_year BETWEEN 2018 AND 2020;

/* �����������, ��� ��� ������� �� 1 ����� */
SELECT artist_name AS "�����������"
  FROM artists
 WHERE artist_name NOT LIKE '% %';

/* �������� ������, ������� �������� ����� "���"/"my" */
SELECT song_name AS "�������� �����"
  FROM songs
 WHERE LOWER(song_name) LIKE '%my%'
	OR LOWER(song_name) LIKE '%���%';

