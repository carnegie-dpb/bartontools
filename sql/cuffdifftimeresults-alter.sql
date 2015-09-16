--
-- alter cuffdifftimeresults to more fully reflect the Cuffdiff data
--

ALTER TABLE cuffdifftimeresults ADD COLUMN status character varying[];
ALTER TABLE cuffdifftimeresults ADD COLUMN significant character varying[];
