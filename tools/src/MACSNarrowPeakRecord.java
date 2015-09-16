/**
 * Encodes a MACS narrowPeak BED6+4 record. Compare sorts on seqid and start.
 */

public class MACSNarrowPeakRecord implements Comparable {

    public String seqid;
    public int start;
    public int end;
    public String name;
    public int score;
    public char strand;
	public double logFC;
	public double p;
	public double q;
	public int summit;

    /**
     * Instantiate given a narrowPeak file line
     */
    public MACSNarrowPeakRecord(String line) {
		String[] chunks = line.split("\t");
		if (chunks.length==10) {
			seqid = chunks[0];
			start = Integer.parseInt(chunks[1]);
			end = Integer.parseInt(chunks[2]);
			name = chunks[3];
			score = Integer.parseInt(chunks[4]);
			strand = chunks[5].charAt(0);
			logFC = Double.parseDouble(chunks[6]);
			double mlog10p = Double.parseDouble(chunks[7]);
			double mlog10q = Double.parseDouble(chunks[8]);
			p = Math.pow(10.0, -mlog10p);
			q = Math.pow(10.0, -mlog10q);
			summit = Integer.parseInt(chunks[9]);
		}
    }

    /**
     * Compare using alpha on seqid then start then end
     */
    public int compareTo(Object o) {
		MACSNarrowPeakRecord that = (MACSNarrowPeakRecord)o;
		if (!this.seqid.equals(that.seqid)) {
			return this.seqid.compareTo(that.seqid);
		} else if (this.start!=that.start) {
			return this.start - that.start;
		} else {
			return this.end - that.end;
		}
    }

    /**
     * Equal if seqid, start and end are equal
     */
    public boolean equals(Object o) {
		MACSNarrowPeakRecord that = (MACSNarrowPeakRecord)o;
		return this.seqid.equals(that.seqid) && this.start==that.start && this.end==that.end;
    }

	/**
	 * Return true if this peak is inside the object given by the GFF record
	 */
	public boolean insideOf(GFFRecord gff) {
		return seqid.equals(gff.seqid) && end>=gff.start && start<=gff.end;
	}

	/**
	 * Return true if this peak starts to the right of the object given by the GFF record
	 */
	public boolean rightOf(GFFRecord gff) {
		return seqid.equals(gff.seqid) && start>gff.end;
	}
	
	/**
	 * Return true if this peak ends to the left of the object given by the GFF record
	 */
	public boolean leftOf(GFFRecord gff) {
		return seqid.equals(gff.seqid) && end<gff.start;
	}


}
    
