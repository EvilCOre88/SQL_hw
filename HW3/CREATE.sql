CREATE TABLE IF NOT EXISTS artists (
	artist_id   SERIAL       PRIMARY KEY,
	artist_name VARCHAR(200) NOT NULL	
);

CREATE TABLE IF NOT EXISTS genres (
	genre_id   SERIAL       PRIMARY KEY,
	genre_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS artist_genre (
	artist_id INTEGER REFERENCES artists(id),
	genre_id  INTEGER REFERENCES genres(id),
	          CONSTRAINT key_artist_genre 
              PRIMARY KEY (artist_id, genre_id)
);

CREATE TABLE IF NOT EXISTS albums (
	album_id     SERIAL       PRIMARY KEY,
	album_name   VARCHAR(500) NOT NULL,
	release_year INTEGER      NOT NULL
                 CHECK(release_year BETWEEN 1860 AND 2030)
);

CREATE TABLE IF NOT EXISTS artist_album (
	album_id  INTEGER REFERENCES albums(id),
	artist_id INTEGER REFERENCES artists(id),
	          CONSTRAINT key_artist_album 
                  PRIMARY KEY (album_id, artist_id)
);

CREATE TABLE IF NOT EXISTS songs (
	song_id     SERIAL       PRIMARY KEY,
	song_name   VARCHAR(500) NOT NULL,
	lasting     INTEGER      NOT NULL
                CHECK(listen_time BETWEEN 5 AND 1000),
	album_id    INTEGER      NOT NULL 
                REFERENCES albums(id)
);

CREATE TABLE IF NOT EXISTS collections (
	collection_id   SERIAL       PRIMARY KEY,
	collection_name VARCHAR(500) NOT NULL,
	release_year    INTEGER      NOT NULL
                    CHECK(release_year BETWEEN 1860 AND 2030)

);

CREATE TABLE IF NOT EXISTS collection_song (
	collection_id INTEGER REFERENCES collections(id),
	song_id       INTEGER REFERENCES songs(id),
	              CONSTRAINT key_collection_song 
                  PRIMARY KEY (collection_id, song_id)
)