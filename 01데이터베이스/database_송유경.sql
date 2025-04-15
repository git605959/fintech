CREATE DATABASE WORLD;
USE WORLD;

CREATE TABLE country(
	Code varchar(5) primary key not null unique,
    Code2 varchar(5) not null,
    Name varchar(50) not null,
    Continent varchar(100) not null,
    SurfaceArea int,
    Population int,
    LifeExpectancy float(4,1),
    GNP int
    );

SELECT * FROM country;
INSERT INTO country
values
('CHN','CHN','중국','Asia',9572900,1277558000,71.4,982268),
('DEU','EU','독일','Europe',357022,82164700,77.4,2133367),
('GBR','GBR','영국','Europe',242900,59623400,77.7,1378330),
('JPN','JPN','일본','Asia',377829,126714000,80.7,3787042),
('USA','USA','미국','North America',9363520,278357000,77.1,8510700);
	