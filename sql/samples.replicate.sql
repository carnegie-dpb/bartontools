--
-- update samples table to contain numeric replicate field which numbers the replicates per condition 0, 1, 2
-- this is to be able to load expression correctly from Cuffdiff genes.read_group_tracking
--

ALTER TABLE public.samples ADD COLUMN replicate integer;
