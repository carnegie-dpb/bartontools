import java.util.Comparator;

/**
 * Encapsulates a single RapDB GFF3 record, parsing out the attributes plus any special cases.
 * Native comparator is based on seqid, strand, start and end.
 * Alternative comparators are provided for alternative sorting.
 * NOTE: Missing string attributes are null.
 *
 * chr03	irgsp1_locus	gene	29596367	29606861	.	-	.	
 * ID=Os03g0727000;
 * Name=Os03g0727000;
 * Note=Similar to Homeobox protein. (Os03t0727000-01)%3BKnotted1-like homeobox protein%2C Shoot apical meristem maintenance%2C Embryogenesis (Os03t0727000-02);
 * Transcript variants=Os03t0727000-01,Os03t0727000-02;
 * RAP-DB Gene Symbol Synonym(s)=OSH1%2C OSKN1%2C Oskn1%2C OsKN1%2C OSH1/Oskn1%2C HB75;
 * RAP-DB Gene Name Synonym(s)=HOMEOBOX 1%2C Oryza sativa homeobox1%2C Homeobox protein OSH1%2C Homeobox protein knotted-1-like 6%2C Homeobox protein knotted-1-like 1%2C Rice KNOX gene-1%2C KNOX PROTEIN 1%2C KNOX protein 1%2C  HOMEOBOX PROTEIN OSH1;
 * CGSNL Gene Symbol=OSH1;
 * CGSNL Gene Name=HOMEOBOX 1;
 * Oryzabase Gene Symbol Synonym(s)=OSKN1%2C Oskn1%2C OsKN1%2C OSH1/Oskn1%2C HB75;
 * Oryzabase Gene Name Synonym(s)=Oryza sativa homeobox1%2C Homeobox protein OSH1%2C Homeobox protein knotted-1-like 6%2C Homeobox protein knotted-1-like 1%2C Rice KNOX gene-1%2C KNOX PROTEIN 1%2C KNOX protein 1%2C KNOX protein 1%2C HOMEOBOX 1%2C HOMEOBOX PROTEIN OSH1
 */
public class RapGFFRecord implements Comparable {

    // GFF3 fields
    public String seqid;
    public String source;
    public String type;
    public int start;
    public int end;
    public String score;
    public char strand;
    public char phase;
    public String attributes;

    // RapDB attributes
    String attributeID;
    String attributeName;
    String attributeNote;
    
    /**
     * Instantiate from a line from a GFF file. Do nothing if it's a comment.
     */
    public RapGFFRecord(String line) {
        if (!line.startsWith("#")) {
            // parse out fields
            String[] chunks = line.split("\t");
            if (chunks.length==9) {
                // main fields
                seqid = chunks[0];
                source = chunks[1];
                type = chunks[2];
                start = Integer.parseInt(chunks[3]);
                end = Integer.parseInt(chunks[4]);
                score = chunks[5];
                strand = chunks[6].charAt(0);
                phase = chunks[7].charAt(0);
                attributes = chunks[8];
                // parse out RapDB attributes
                parseAttributes();
            }
        }
    }

    /**
     * Native comparator: compare on seqid, strand, start and end.
     */
    public int compareTo(Object o) {
        RapGFFRecord that = (RapGFFRecord)o;
        // alpha seqid
        if (!this.seqid.equals(that.seqid)) return this.seqid.compareTo(that.seqid);
        // + strand ahead of - strand
        if (this.strand!='.' && that.strand!='.' && this.strand!=that.strand) {
            if (this.strand=='+') return 1; else return -1;
        }
        // left start before right start
        if (this.start!=that.start) return this.start - that.start;
        // left end before right end
        if (this.end!=that.end) return this.end - that.end;
        // it's a tie!
        return 0;
    }
    
    /**
     * Equal if both have same seqid, strand, start and end (has to be consistent with compareTo above).
     */
    public boolean equals(Object o) {
        RapGFFRecord that = (RapGFFRecord)o;
        return this.seqid.equals(that.seqid) && this.strand==that.strand && this.start==that.start && this.end==that.end;
    }

    /**
     * Output a tab-delimited line containing this instance's values
     */
    public String toString() {
        return seqid+'\t'+source+'\t'+type+'\t'+start+'\t'+end+'\t'+score+'\t'+strand+'\t'+phase+'\t'+attributes;
    }

    /**
     * Parse out known attributes; if Name is missing, set it to ID
     */
    void parseAttributes() {
        String[] chunks = attributes.split(";");
        for (int i=0; i<chunks.length; i++) {
            // ID
            if (chunks[i].startsWith("ID=")) attributeID = getAttributeValue(chunks[i]);
            // Name
            if (chunks[i].startsWith("Name=")) attributeName = getAttributeValue(chunks[i]);
            // Note
            if (chunks[i].startsWith("Note=")) attributeNote = getAttributeValue(chunks[i]);
            // CGSNL Gene Symbol replaces Name if present
            if (chunks[i].startsWith("CGSNL Gene Symbol")) attributeName = getAttributeValue(chunks[i]);
        }
    }

    /**
     * Parse the value from a single attribute string
     */
    String getAttributeValue(String attributeString) {
        String[] parts = attributeString.split("=");
        return parts[1];
    }

}
