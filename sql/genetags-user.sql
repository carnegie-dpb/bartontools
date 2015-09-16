--
-- add user_id to genetags
--

ALTER TABLE genetags ADD COLUMN user_id int REFERENCES users(id);
UPDATE genetags SET user_id=1;
ALTER TABLE genetags ALTER COLUMN user_id SET NOT NULL;

DROP INDEX genetags_unique;
CREATE UNIQUE INDEX genetags_unique ON genetags(id, tag, user_id);

