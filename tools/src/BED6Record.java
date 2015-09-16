/**
 * Encodes a BED6 record. Compare sorts on chrom and start.
 */

public class BED6Record implements Comparable {

    public String chrom;
    public int start;
    public int end;
    public String name;
    public String score;
    public char strand;
    
    /**
     * Instantiate given a BED6 line
     */
    public BED6Record(String line) {
		String[] chunks = line.split("\t");
		if (chunks.length>=6) {
			chrom = chunks[0];
			start = Integer.parseInt(chunks[1]);
			end = Integer.parseInt(chunks[2]);
			name = chunks[3];
			score = chunks[4];
			strand = chunks[5].charAt(0);
		}
    }

    /**
     * Compare using alpha on chrom and start
     */
    public int compareTo(Object o) {
		BED6Record that = (BED6Record)o;
		if (!this.chrom.equals(that.chrom)) {
			return this.chrom.compareTo(that.chrom);
		} else {
			return this.start - that.start;
		}
    }

    /**
     * Equal if chrom, start and end are equal
     */
    public boolean equals(Object o) {
		BED6Record that = (BED6Record)o;
		return this.chrom.equals(that.chrom) && this.start==that.start && this.end==that.end;
    }

}
    
