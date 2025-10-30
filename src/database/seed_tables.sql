-- Use the database created during initialization
USE `opencourtDB`;

INSERT INTO users (user_name) VALUES ("Augy"), ("Rebecca");
INSERT INTO locations (location_name, address) VALUES ("Game Farm Park", "3030 R ST SE Auburn, WA 98002"), ("Les Gove Park", "910 9th ST SE Auburn, WA 98002");
INSERT INTO games (game_name, location_id) VALUES ("Pickle at the Farm", 1);
INSERT INTO games_users (user_id, game_id) VALUES (1, 1), (2, 1);

SELECT * FROM users;
SELECT * FROM locations;
SELECT * FROM games;
SELECT * FROM games_users;