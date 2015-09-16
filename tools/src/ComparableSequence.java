import org.biojava.nbio.core.sequence.DNASequence;

/**
 * A simple wrapper for a DNASequence with a comparator to enforce uniqueness in a Set.
 * It privately stores the sequence as a string.
 */

public class ComparableSequence implements Comparable {

    public DNASequence dna;

    private String seq;

    /**
     * Instantiate from a name and DNASequence.
     */
    public ComparableSequence(DNASequence dna) {
	this.dna = dna;
	this.seq = dna.getSequenceAsString().trim();
	if (seq.startsWith("GAAGTCATAGCTCCCAACAAGAT")) {
	    System.out.println("SEQ: "+seq);
	}
    }

    /**
     * Two ComparableSequences are equal if they have equal DNA sequences.
     */
    public boolean equals(Object o) {
	ComparableSequence that = (ComparableSequence)o;
	return this.seq.equals(that.seq);
    }

    /**
     * Compare based on accession, not seq, if not equal.
     */
    public int compareTo(Object o) {
	ComparableSequence that = (ComparableSequence)o;
	if (this.equals(that)) {
	    return 0;
	} else {
	    return this.dna.getAccession().getID().compareTo(that.dna.getAccession().getID());
	}
    }

}

