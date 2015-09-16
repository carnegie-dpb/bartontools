import java.util.Comparator;

/**
 * Encodes a blastn -outfmt 6 record. Target labels are truncated past the second underscore.
 * The "native" comparator is based on 10 fields, excluding eValue and pctIdent, since they're doubles.
 */
public class Blast6Record implements Comparable {

    public String queryLabel;
    public String targetLabel;
    public double pctIdent;
    public int alignLength;
    public int numMismatches;
    public int numGaps;
    public int queryStart;
    public int queryEnd;
    public int targetStart;
    public int targetEnd;
    public double eValue;
    public int bitScore;

    /**
     * Instantiate a default record.
     */
    public Blast6Record() {
	queryLabel = "";
	targetLabel = "";
	pctIdent = 0.0;
	alignLength = 0;
	numMismatches = 0;
	numGaps = 0;
	queryStart = 0;
	queryEnd = 0;
	targetStart = 0;
	targetEnd = 0;
	eValue = 0.0;
	bitScore = 0;
    }
	
    /**
     * Instantiate given a line from the file
     */
    public Blast6Record(String line) {
	String[] chunks = line.split("\t");
	queryLabel = chunks[0].trim();
	targetLabel = chunks[1].trim();
	pctIdent = Double.parseDouble(chunks[2].trim());
	alignLength = Integer.parseInt(chunks[3].trim());
	numMismatches = Integer.parseInt(chunks[4].trim());
	numGaps = Integer.parseInt(chunks[5].trim());
	queryStart = Integer.parseInt(chunks[6].trim());
	queryEnd = Integer.parseInt(chunks[7].trim());
	targetStart = Integer.parseInt(chunks[8].trim());
	targetEnd = Integer.parseInt(chunks[9].trim());
	eValue = Double.parseDouble(chunks[10].trim());
	bitScore = (int) Double.parseDouble(chunks[11].trim()); // on rare occasions bitScore is a decimal

    }

    /**
     * Output a tabbed line containing all instance values
     */
    public String toString() {
	return queryLabel+'\t'+targetLabel+'\t'+pctIdent+'\t'+alignLength+'\t'+numMismatches+'\t'+numGaps+'\t'+queryStart+'\t'+queryEnd+'\t'+targetStart+'\t'+targetEnd+'\t'+eValue+'\t'+bitScore;
    }

    /**
     * Native equals - based on 11 fields (evalue not used)
     */
    public boolean equals(Object o) {
	Blast6Record that = (Blast6Record) o;
	return this.queryLabel.equals(that.queryLabel) &&
	    this.targetLabel.equals(that.targetLabel) &&
	    this.queryLabel.equals(that.queryLabel) &&
	    this.alignLength==that.alignLength &&
	    this.numMismatches==that.numMismatches &&
	    this.numGaps==that.numGaps &&
	    this.queryStart==that.queryStart &&
	    this.queryEnd==that.queryEnd &&
	    this.targetStart==that.targetStart &&
	    this.targetEnd==that.targetEnd &&
	    this.bitScore==that.bitScore;
    }

    /**
     * Native compareTo - based on all 11 fields (evalue not used), targetLabel has precedence
     */
    public int compareTo(Object o) {
	Blast6Record that = (Blast6Record) o;
	if (!this.targetLabel.equals(that.targetLabel)) {
	    return this.targetLabel.compareTo(that.targetLabel);
	} else if (!this.queryLabel.equals(that.queryLabel)) {
	    return this.queryLabel.compareTo(that.queryLabel);
	} else if (this.targetStart!=that.targetStart) {
	    return that.targetStart - this.targetStart; // favor the one that starts leftmost
	} else if (this.targetEnd!=that.targetEnd) {
	    return this.targetEnd - that.targetEnd;     // favor the one that ends rightmost
	} else if (this.queryStart!=that.queryStart) {
	    return this.queryStart - that.queryStart;
	} else if (this.queryEnd!=that.queryEnd) {
	    return this.queryEnd - that.queryEnd;
	} else if (this.alignLength!=that.alignLength) {
	    return this.alignLength - that.alignLength;
	} else if (this.numMismatches!=that.numMismatches) {
	    return that.numMismatches - this.numMismatches;
	} else if (this.numGaps!=that.numGaps) {
	    return that.numGaps - this.numGaps;
	} else {
	    return Math.round(this.bitScore - that.bitScore);
	}
    }
	


    /**
     * Alpha compare on target label, query label, start, end
     */
    public static final Comparator<Blast6Record> NameComparator = new Comparator<Blast6Record>() {
	@Override
	public int compare(Blast6Record blast1, Blast6Record blast2) {
	    if (!blast1.targetLabel.equals(blast2.targetLabel)) {
		return blast1.targetLabel.compareTo(blast2.targetLabel);
	    } else if (!blast1.queryLabel.equals(blast2.queryLabel)) {
		return blast1.queryLabel.compareTo(blast2.queryLabel);
	    } else if (blast1.targetStart!=blast2.targetStart) {
		return blast2.targetStart - blast1.targetStart; // favor the one that starts leftmost
	    } else {
		return blast1.targetEnd - blast2.targetEnd;     // favor the one that ends rightmost
	    }
	}
    };

    /**
     * Compare based on alignment length as well as query and target
     */
    public static final Comparator<Blast6Record> LengthComparator = new Comparator<Blast6Record>() {
	@Override
	public int compare(Blast6Record blast1, Blast6Record blast2) {
	    if (!blast1.queryLabel.equals(blast2.queryLabel)) {
		return blast1.queryLabel.compareTo(blast2.queryLabel);
	    } else if (!blast1.targetLabel.equals(blast2.targetLabel)) {
		return blast1.targetLabel.compareTo(blast2.targetLabel);
	    } else {
		return blast1.alignLength - blast2.alignLength; // favor the longer length
	    }
	}
    };

    /**
     * Compare based on targetLabel, targetStart, targetEnd and bitScore (sorts better hits above worse ones with identical target mappings)
     */
    public static final Comparator<Blast6Record> BitScoreComparator = new Comparator<Blast6Record>() {
	@Override
	public int compare(Blast6Record blast1, Blast6Record blast2) {
	    if (!blast1.targetLabel.equals(blast2.targetLabel)) {
		return blast1.targetLabel.compareTo(blast2.targetLabel);
	    } else if (blast1.targetStart!=blast2.targetStart) {
		return blast2.targetStart - blast1.targetStart; // favor the one that starts leftmost
	    } else if (blast1.targetEnd!=blast2.targetEnd) {
		return blast1.targetEnd - blast2.targetEnd;     // favor the one that ends rightmost
	    } else {
		return blast2.bitScore - blast1.bitScore;
	    }
	}
    };

    /**
     * Compare based on targetLabel, targetStart and targetEnd (eliminates same maps with first in taking precedence)
     */
    public static final Comparator<Blast6Record> TargetComparator = new Comparator<Blast6Record>() {
	@Override
	public int compare(Blast6Record blast1, Blast6Record blast2) {
	    if (!blast1.targetLabel.equals(blast2.targetLabel)) {
		return blast1.targetLabel.compareTo(blast2.targetLabel);
	    } else if (blast1.targetStart!=blast2.targetStart) {
		return blast2.targetStart - blast1.targetStart; // favor the one that starts leftmost
	    } else {
		return blast1.targetEnd - blast2.targetEnd;     // favor the one that ends rightmost
	    }
	}
    };

    /**
     * Return strand
     */
    public char strand() {
	if (targetEnd<targetStart) {
	    return '-';
	} else {
	    return '+';
	}
    }

    
    /**
     * Calculate the gap between two contigs
     */
    public static int gap(Blast6Record blast1, Blast6Record blast2) {
	if (blast1.strand()=='+' && blast2.strand()=='+') {
	    if (blast1.targetEnd<blast2.targetStart) {
		return blast2.targetStart - blast1.targetEnd;  // 1 left of 2
	    } else {
		return blast1.targetStart - blast2.targetEnd;  // 2 left of 1
	    }
	} else if (blast1.strand()=='-' && blast2.strand()=='-') {
	    if (blast1.targetStart<blast2.targetEnd) {
		return blast2.targetEnd - blast1.targetStart;  // 1 left of 2
	    } else {
		return blast1.targetEnd - blast2.targetStart;  // 2 left of 1
	    }
	} else if (blast1.strand()=='+' && blast2.strand()=='-') {
	    if (blast1.targetEnd<blast2.targetEnd) {
		return blast2.targetEnd - blast1.targetEnd;    // 1 left of 2
	    } else {
		return blast1.targetStart - blast2.targetStart; // 2 left of 1
	    }
	} else {
	    if (blast1.targetStart<blast2.targetStart) {
		return blast2.targetStart - blast1.targetStart; // 1 left of 2
	    } else {
		return blast1.targetEnd - blast2.targetEnd;    // 2 left of 1
	    }
	}
    }

}
    
