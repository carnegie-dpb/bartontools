/**
 * Encapsulates a single SAM record. Comparator based on QNAME only.
 * Does NOT support extra fields beyond the mandatory 11.
 */

public class SAMRecord implements Comparable {

    public String qname;
    public int flag;
    public String rname;
    public int pos;
    public int mapq;
    public String cigar;
    public String rnext;
    public int pnext;
    public int tlen;
    public String seq;
    public String qual;

    /**
     * Instantiate from a line from a SAM file.
     */
    public SAMRecord(String line) {
	String[] chunks = line.split("\t");
	if (chunks.length>=11) {
	    qname = chunks[0];
	    flag = Integer.parseInt(chunks[1]);
	    rname = chunks[2];
	    pos = Integer.parseInt(chunks[3]);
	    mapq = Integer.parseInt(chunks[4]);
	    cigar = chunks[5];
	    rnext = chunks[6];
	    pnext = Integer.parseInt(chunks[7]);
	    tlen = Integer.parseInt(chunks[8]);
	    seq = chunks[9];
	    qual = chunks[10];
	}
    }

    /**
     * Compare simply on qname
     */
    public int compareTo(Object o) {
	SAMRecord that = (SAMRecord)o;
	if (this.qname!=null && that.qname!=null) {
	    return this.qname.compareTo(that.qname);
	} else {
	    return 0;
	}
    }

    /**
     * Return true if both have same attribute Name; false otherwise, including one is null.
     */
    public boolean equals(Object o) {
	SAMRecord that = (SAMRecord)o;
	if (this.qname!=null && that.qname!=null) {
	    return this.qname.equals(that.qname);
	} else {
	    return false;
	}
    }

    /**
     * Override toString() to provide a standard tab-delimited SAM line
     */
    public String toString() {
	return qname+"\t"+flag+"\t"+rname+"\t"+pos+"\t"+mapq+"\t"+cigar+"\t"+rnext+"\t"+pnext+"\t"+tlen+"\t"+seq+"\t"+qual;
    }

}
    
