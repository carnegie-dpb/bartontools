--
-- add a confirmation key to users, which is non-null for unconfirmed users, also a timestamp
--

ALTER TABLE users ADD COLUMN confirmationkey varchar;
ALTER TABLE users ADD COLUMN timecreated timestamp(0) NOT NULL DEFAULT now();


