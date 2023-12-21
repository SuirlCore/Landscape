-- ------------------------------------------------------------------------------------------
-- create database---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------


DROP DATABASE IF EXISTS landscape;

CREATE DATABASE landscape;

USE landscape;


-- ------------------------------------------------------------------------------------------
-- landscape tables--------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------

-- shows what entities are in what locations at the current time
CREATE TABLE IF NOT EXISTS locations (
    xLoc int NOT NULL,
    yLoc int NOT NULL,
    zLoc int NOT NULL,
    entityID int NOT NULL,
    PRIMARY KEY (xLoc, yLoc, zLoc)
);

-- lists the entities that exist on the landscape
CREATE TABLE IF NOT EXISTS entities (
    entityID int NOT NULL AUTO_INCREMENT,
    entityName char(255) NOT NULL,
    entityType int NOT NULL, -- either "visible" or "invisible"
    PRIMARY KEY (entityID)
);

-- lists type of entities that can exist
CREATE TABLE IF NOT EXISTS entityType (
    typeID int NOT NULL AUTO_INCREMENT,
    typeName char(255) NOT NULL,
    visible binary NOT NULL,
    PRIMARY KEY (typeID)
);

-- list of patterns that can be produced
CREATE TABLE IF NOT EXISTS patterns (
    patternID int NOT NULL AUTO_INCREMENT,
    patternName char (255) NOT NULL,
    PRIMARY KEY (patternID)
);

-- blueprints for what entites go where in a pattern
CREATE TABLE IF NOT EXISTS patternPixels (
    pixelLocID int NOT NULL AUTO_INCREMENT,
    patternID int NOT NULL,
    pixelLocX int NOT NULL,
    pixelLocY int NOT NULL,
    pixelLocZ int NOT NULL,
    PRIMARY KEY (pixelLocID)
);

-- entities that need moved, drones pick their tasks from this list
CREATE TABLE IF NOT EXISTS tasks (
    taskID int NOT NULL AUTO_INCREMENT,
    entityID int NOT NULL,
    endLocX int NOT NULL,
    endLocY int NOT NULL,
    endLocZ int NOT NULL,
    taskClaimed binary NOT NULL,
    claimedBy int,
    taskComplete binary NOT NULL,
    PRIMARY KEY(taskID)
);

-- the path that drones take across the landscape to complete tasks
CREATE TABLE IF NOT EXISTS routes (
    routeID int NOT NULL AUTO_INCREMENT,
    entityID int NOT NULL,
    routeComplete binary NOT NULL,
    PRIMARY KEY(routeID)
);

-- the individual stops along the way for routes
CREATE TABLE IF NOT EXISTS routeNodes (
    nodeID int NOT NULL AUTO_INCREMENT,
    routeID int NOT NULL,
    nodeNum int NOT NULL,
    LocX int NOT NULL,
    locY int NOT NULL,
    locZ int NOT NULL,
    PRIMARY KEY(nodeID)
);

-- ------------------------------------------------------------------------------------------
-- Foreign Keys------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------


ALTER TABLE locations
ADD FOREIGN KEY (entityID) REFERENCES entities(entityID);

ALTER TABLE entities
ADD FOREIGN KEY (entityType) REFERENCES entityType(typeDI);

ALTER TABLE patternPixels
ADD FOREIGN KEY (patternID) REFERENCES patterns(patternID);

ALTER TABLE tasks
ADD FOREIGN KEY (entityID) REFERENCES entities(entityID);

ALTER TABLE tasks
ADD FOREIGN KEY (claimedBY) REFERENCES entities(entityID);

ALTER TABLE routes
ADD FOREIGN KEY (entityID) REFERENCES entities(entityID);

ALTER TABLE routeNodes
ADD FOREIGN KEY (routeID) REFERENCES routes(routeID);


-- ------------------------------------------------------------------------------------------
-- Populate Tables---------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------


-- generate entity types
INSERT INTO entities (entityID, entityName, entityType) VALUES (1, "nothing", "visible");
INSERT INTO entities (entityID, entityName, entityType) VALUES (2, "queen", "visible");
INSERT INTO entities (entityID, entityName, entityType) VALUES (3, "drone", "visible");
INSERT INTO entities (entityID, entityName, entityType) VALUES (4, "pixel", "visible");
INSERT INTO entities (entityID, entityName, entityType) VALUES (5, "fieldBoundry", "invisible");
INSERT INTO entities (entityID, entityName, entityType) VALUES (6, "warehouseBoundry", "invisible");


-- 35 wide by 10 high
-- generate boundaries for the field
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (0, 0, 0, 5);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (34, 0, 0, 5);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (0, 9, 0, 5);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (34, 9, 0, 5);

-- 35 wide by 4 high
-- generate boundaries for the warehouse to hold extra pixels
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (0, 10, 0, 6);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (34, 10, 0, 6);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (0, 13, 0, 6);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (34, 13, 0, 6);

-- generate pixels to be moved around (52 needed for clock), and place them in the warehouse
INSERT INTO entities (entityID, entityName, entityType) VALUES (1, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (1, 11, 0, 1);
INSERT INTO entities (entityID, entityName, entityType) VALUES (2, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (2, 11, 0, 2);
INSERT INTO entities (entityID, entityName, entityType) VALUES (3, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (3, 11, 0, 3);
INSERT INTO entities (entityID, entityName, entityType) VALUES (4, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (4, 11, 0, 4);
INSERT INTO entities (entityID, entityName, entityType) VALUES (5, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (5, 11, 0, 5);
INSERT INTO entities (entityID, entityName, entityType) VALUES (6, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (6, 11, 0, 6);
INSERT INTO entities (entityID, entityName, entityType) VALUES (7, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (7, 11, 0, 7);
INSERT INTO entities (entityID, entityName, entityType) VALUES (8, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (8, 11, 0, 8);
INSERT INTO entities (entityID, entityName, entityType) VALUES (9, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (9, 11, 0, 9);
INSERT INTO entities (entityID, entityName, entityType) VALUES (10, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (10, 11, 0, 10);
INSERT INTO entities (entityID, entityName, entityType) VALUES (11, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (11, 11, 0, 11);
INSERT INTO entities (entityID, entityName, entityType) VALUES (12, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (12, 11, 0, 12);
INSERT INTO entities (entityID, entityName, entityType) VALUES (13, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (13, 11, 0, 13);
INSERT INTO entities (entityID, entityName, entityType) VALUES (14, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (14, 11, 0, 14);
INSERT INTO entities (entityID, entityName, entityType) VALUES (15, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (15, 11, 0, 15);
INSERT INTO entities (entityID, entityName, entityType) VALUES (16, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (16, 11, 0, 16);
INSERT INTO entities (entityID, entityName, entityType) VALUES (17, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (17, 11, 0, 17);
INSERT INTO entities (entityID, entityName, entityType) VALUES (18, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (18, 11, 0, 18);
INSERT INTO entities (entityID, entityName, entityType) VALUES (19, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (19, 11, 0, 19);
INSERT INTO entities (entityID, entityName, entityType) VALUES (20, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (20, 11, 0, 20);
INSERT INTO entities (entityID, entityName, entityType) VALUES (21, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (21, 11, 0, 21);
INSERT INTO entities (entityID, entityName, entityType) VALUES (22, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (23, 11, 0, 22);
INSERT INTO entities (entityID, entityName, entityType) VALUES (23, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (24, 11, 0, 23);
INSERT INTO entities (entityID, entityName, entityType) VALUES (24, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (25, 11, 0, 24);
INSERT INTO entities (entityID, entityName, entityType) VALUES (25, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (26, 11, 0, 25);
INSERT INTO entities (entityID, entityName, entityType) VALUES (26, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (1, 12, 0, 26);
INSERT INTO entities (entityID, entityName, entityType) VALUES (27, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (2, 12, 0, 27);
INSERT INTO entities (entityID, entityName, entityType) VALUES (28, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (3, 12, 0, 28);
INSERT INTO entities (entityID, entityName, entityType) VALUES (29, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (4, 12, 0, 29);
INSERT INTO entities (entityID, entityName, entityType) VALUES (30, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (5, 12, 0, 30);
INSERT INTO entities (entityID, entityName, entityType) VALUES (31, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (6, 12, 0, 31);
INSERT INTO entities (entityID, entityName, entityType) VALUES (32, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (7, 12, 0, 32);
INSERT INTO entities (entityID, entityName, entityType) VALUES (33, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (8, 12, 0, 33);
INSERT INTO entities (entityID, entityName, entityType) VALUES (34, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (9, 12, 0, 34);
INSERT INTO entities (entityID, entityName, entityType) VALUES (35, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (10, 12, 0, 35);
INSERT INTO entities (entityID, entityName, entityType) VALUES (36, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (11, 12, 0, 36);
INSERT INTO entities (entityID, entityName, entityType) VALUES (37, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (12, 12, 0, 37);
INSERT INTO entities (entityID, entityName, entityType) VALUES (38, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (13, 12, 0, 38);
INSERT INTO entities (entityID, entityName, entityType) VALUES (39, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (14, 12, 0, 39);
INSERT INTO entities (entityID, entityName, entityType) VALUES (40, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (15, 12, 0, 40);
INSERT INTO entities (entityID, entityName, entityType) VALUES (41, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (16, 12, 0, 41);
INSERT INTO entities (entityID, entityName, entityType) VALUES (42, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (17, 12, 0, 42);
INSERT INTO entities (entityID, entityName, entityType) VALUES (43, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (18, 12, 0, 43);
INSERT INTO entities (entityID, entityName, entityType) VALUES (44, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (19, 12, 0, 44);
INSERT INTO entities (entityID, entityName, entityType) VALUES (45, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (20, 12, 0, 45);
INSERT INTO entities (entityID, entityName, entityType) VALUES (46, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (21, 12, 0, 46);
INSERT INTO entities (entityID, entityName, entityType) VALUES (47, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (22, 12, 0, 47);
INSERT INTO entities (entityID, entityName, entityType) VALUES (48, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (23, 12, 0, 48);
INSERT INTO entities (entityID, entityName, entityType) VALUES (49, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (24, 12, 0, 49);
INSERT INTO entities (entityID, entityName, entityType) VALUES (50, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (25, 12, 0, 50);
INSERT INTO entities (entityID, entityName, entityType) VALUES (51, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (26, 12, 0, 51);
INSERT INTO entities (entityID, entityName, entityType) VALUES (52, "pixel", 4);
INSERT INTO locations (xLoc, yLoc, zLoc, entityID) VALUES (27, 12, 0, 52);

-- generate patterns and patternPixels for numbers
INSERT INTO patterns (patternID, patternName) VALUES (1, "1");
INSERT INTO patterns (patternID, patternName) VALUES (2, "2");
INSERT INTO patterns (patternID, patternName) VALUES (3, "3");
INSERT INTO patterns (patternID, patternName) VALUES (4, "4");
INSERT INTO patterns (patternID, patternName) VALUES (5, "5");
INSERT INTO patterns (patternID, patternName) VALUES (6, "6");
INSERT INTO patterns (patternID, patternName) VALUES (7, "7");
INSERT INTO patterns (patternID, patternName) VALUES (8, "8");
INSERT INTO patterns (patternID, patternName) VALUES (9, "9");
INSERT INTO patterns (patternID, patternName) VALUES (10, "0");
INSERT INTO patterns (patternID, patternName) VALUES (11, ":");

-- x is left right, left starts with 0
-- y is up down, bottom starts with 0

-- pattern for "1"
-- 0010
-- 0110
-- 0010
-- 0010
-- 0010
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (1, 2, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (1, 1, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (1, 2, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (1, 2, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (1, 2, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (1, 2, 0, 0);

-- pattern for "2"
-- 0110
-- 1001
-- 0010
-- 0100
-- 1111
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (2, 1, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (2, 2, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (2, 0, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (2, 4, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (2, 2, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (2, 1, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (2, 0, 0, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (2, 1, 0, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (2, 2, 0, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (2, 3, 0, 0);

-- pattern for "3"
-- 0110
-- 1001
-- 0010
-- 1001
-- 0110
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (3, 1, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (3, 2, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (3, 0, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (3, 3, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (3, 2, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (3, 0, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (3, 3, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (3, 1, 0, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (3, 2, 0, 0);

-- pattern for "4"
-- 0011
-- 0101
-- 1111
-- 0001
-- 0001
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (4, 2, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (4, 3, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (4, 1, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (4, 3, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (4, 0, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (4, 1, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (4, 2, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (4, 3, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (4, 3, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (4, 3, 0, 0);

-- pattern for "5"
-- 1111
-- 1110
-- 0001
-- 1001
-- 0110
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (5, 0, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (5, 1, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (5, 2, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (5, 3, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (5, 0, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (5, 1, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (5, 2, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (5, 3, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (5, 0, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (5, 3, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (5, 1, 0, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (5, 2, 0, 0);

-- pattern for "6"
-- 0010
-- 0100
-- 1110
-- 1001
-- 0110
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (6, 2, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (6, 1, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (6, 0, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (6, 1, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (6, 2, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (6, 0, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (6, 3, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (6, 1, 0, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (6, 2, 0, 0);

-- pattern for "7"
-- 1111
-- 0001
-- 0010
-- 0100
-- 1000
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (7, 0, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (7, 1, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (7, 2, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (7, 3, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (7, 3, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (7, 2, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (7, 1, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (7, 0, 0, 0);

-- pattern for "8"
-- 0110
-- 1001
-- 0110
-- 1001
-- 0110
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (8, 1, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (8, 2, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (8, 0, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (8, 3, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (8, 1, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (8, 2, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (8, 0, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (8, 3, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (8, 1, 0, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (8, 2, 0, 0);

-- pattern for "9"
-- 0110
-- 1001
-- 0111
-- 0010
-- 0100
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (9, 1, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (9, 2, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (9, 0, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (9, 3, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (9, 1, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (9, 2, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (9, 3, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (9, 2, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (9, 1, 0, 0);

-- pattern for "0"
-- 0110
-- 1001
-- 1001
-- 1001
-- 0110
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (10, 1, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (10, 2, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (10, 0, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (10, 3, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (10, 0, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (10, 3, 2, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (10, 0, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (10, 3, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (10, 1, 0, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (10, 2, 0, 0);

-- pattern for ":"
-- 0010
-- 0010
-- 0000
-- 0010
-- 0010
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (11, 2, 4, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (11, 2, 3, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (11, 2, 1, 0);
INSERT INTO patternPixels (patternID, pixelLocX, pixelLocY, pixelLocZ) VALUES (11, 2, 0, 0);



-- ------------------------------------------------------------------------------------------
-- users and privelages----------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------


-- stuff


-- ------------------------------------------------------------------------------------------
-- procedures--------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------


-- function to find the entityID at a specifix x, y, z location and add it to the routes 
-- to be removed
DELIMITER //
CREATE PROCEDURE removePixel(IN xLocIn INT, yLocIn INT, zLocIn INT)
BEGIN
    -- find the entityID at a location
    SET @currentEntityID = (SELECT entityID FROM entities WHERE (xLoc = xLocIn) AND (yLoc = yLocIn) AND (zLoc = zLocIn));

    -- find an empty spot on the warehouse
    SET @emptySpot = (SELECT xLoc, yLoc, zLoc )
    
    -- insert a task to move the entityID to the empty spot
    more things go here

END //
DELIMITER ;





-- shows what entities are in what locations at the current time
CREATE TABLE IF NOT EXISTS locations (
    xLoc int NOT NULL,
    yLoc int NOT NULL,
    zLoc int NOT NULL,
    entityID int NOT NULL,
    PRIMARY KEY (xLoc, yLoc, zLoc)
);

-- lists the entities that exist on the landscape
CREATE TABLE IF NOT EXISTS entities (
    entityID int NOT NULL AUTO_INCREMENT,
    entityName char(255) NOT NULL,
    entityType int NOT NULL, -- either "visible" or "invisible"
    PRIMARY KEY (entityID)
);

-- lists type of entities that can exist
CREATE TABLE IF NOT EXISTS entityType (
    typeID int NOT NULL AUTO_INCREMENT,
    typeName char(255) NOT NULL,
    visible binary NOT NULL,
    PRIMARY KEY (typeID)
);