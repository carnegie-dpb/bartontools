--
-- Add new internalscale field, default 1. Will divide FPKM by internalscale in plots, etc.
--

ALTER TABLE samples ADD column internalscale double precision NOT NULL DEFAULT 1.0;
