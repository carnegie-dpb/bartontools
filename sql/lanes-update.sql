--
-- change condition to mean the transgenic condition, regardless of time
-- add column time to indicate the time after Dex application
--

ALTER TABLE lanes ADD COLUMN time float8;

UPDATE lanes SET time=0.0 WHERE condition LIKE '%.0';
UPDATE lanes SET time=30.0 WHERE condition LIKE '%.30';
UPDATE lanes SET time=60.0 WHERE condition LIKE '%.60';
UPDATE lanes SET time=120.0 WHERE condition LIKE '%.120';

UPDATE lanes SET condition = 'Col' WHERE condition LIKE 'Col%';
UPDATE lanes SET condition = 'AS2' WHERE condition LIKE 'AS2%';
UPDATE lanes SET condition = 'Rev' WHERE condition LIKE 'Rev%';
UPDATE lanes SET condition = 'Kan' WHERE condition LIKE 'Kan%';
UPDATE lanes SET condition = 'STM' WHERE condition LIKE 'STM%';

