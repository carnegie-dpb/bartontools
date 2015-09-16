-- define foreign keys for feature, attribute, name and parent2child tables to hopefully speed up searches and deletes

ALTER TABLE attribute DROP CONSTRAINT feature_fk;
ALTER TABLE attribute ADD CONSTRAINT feature_fk FOREIGN KEY (id) REFERENCES feature (id) ON DELETE CASCADE;

ALTER TABLE "name" DROP CONSTRAINT feature_fk;
ALTER TABLE "name" ADD CONSTRAINT feature_fk FOREIGN KEY (id) REFERENCES feature (id) ON DELETE CASCADE;

ALTER TABLE parent2child DROP CONSTRAINT feature_fk;
ALTER TABLE parent2child ADD CONSTRAINT feature_fk FOREIGN KEY (id) REFERENCES feature (id) ON DELETE CASCADE;

ALTER TABLE feature DROP CONSTRAINT typelist_fk;
ALTER TABLE feature ADD CONSTRAINT typelist_fk FOREIGN KEY (typeid) REFERENCES typelist (id) ON DELETE CASCADE;

ALTER TABLE attribute DROP CONSTRAINT attributelist_fk;
ALTER TABLE attribute ADD CONSTRAINT attributelist_fk FOREIGN KEY (attribute_id) REFERENCES attributelist (id) ON DELETE CASCADE;

