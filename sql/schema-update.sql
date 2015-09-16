--
-- update names, content of schemas
---

DELETE FROM users_experiments WHERE schema='bl2012';
UPDATE experiments SET schema='gse30703',title='Expression data from Arabidopsis GR-REVOLUTA and KANADI1-GR transgenic seedlings (GSE30703); plus GR-AS2 transgenic seedlings'  WHERE schema='bl2012';
ALTER SCHEMA bl2012 RENAME TO gse30703;
INSERT INTO users_experiments VALUES (1, 'gse30703', true);
INSERT INTO users_experiments VALUES (2, 'gse30703', false);

DELETE FROM users_experiments WHERE schema='bl2013';
UPDATE experiments SET schema='gse70796',title='Transcription targets of ASYMMETRIC LEAVES 2 (AS2), KANADI1 (KAN), REVOLUTA (REV) and SHOOT MERISTEMLESS (STM) genes' WHERE schema='bl2013';
ALTER SCHEMA bl2013 RENAME TO gse70796;
INSERT INTO users_experiments VALUES (1, 'gse70796', true);
INSERT INTO users_experiments VALUES (2, 'gse70796', false);


UPDATE experiments SET title='Identification of mRNAs Regulated in Response to Transcriptional Activation of the Arabidopsis Abscisic Acid Insensitive Growth 1 (AIG1) Transcription Factor cDNA' WHERE schema='gse70100';
