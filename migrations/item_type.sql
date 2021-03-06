-- 1 up

CREATE TABLE item_type(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	genesis TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
	name TEXT NOT NULL,
	active BOOLEAN NOT NULL CHECK (active IN (0,1)) DEFAULT 1
);



-- 1 down

DROP TABLE item_type;