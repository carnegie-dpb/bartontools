import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.LinkedHashMap;
import java.util.Collections;
import java.util.Comparator;
import java.util.ArrayList;
import java.util.Map;

import org.biojava.nbio.core.sequence.AccessionID;
import org.biojava.nbio.core.sequence.DNASequence;
import org.biojava.nbio.core.sequence.Strand;
import org.biojava.nbio.core.sequence.io.FastaReaderHelper;
import org.biojava.nbio.core.sequence.io.FastaWriterHelper;

/**
 * Extracts the sequence in the given FASTA file corresponding to the range given in the given GFF file.
 * Uses the GFF attribute Name to label the FASTA sequence.
 *
 * Similar to bedtools getfasta, which doesn't grab NAME from the attributes string.
 */

public class GetFasta {

    public static void main(String[] args) throws Exception{

	if (args.length<2) {
	    System.out.println("Usage: java GetFasta <FASTA file> <GFF file>");
	    System.exit(0);
	}
	
	// a map of sequences in the FASTA file
	System.err.print("Loading FASTA...");
	LinkedHashMap<String,DNASequence> fastaMap = FastaReaderHelper.readFastaDNASequence(new File(args[0]));
	System.err.println("done.");

	// run through the GFF records, outputting a FASTA sequence for each one
	FastaWriterHelper writer = new FastaWriterHelper();
	String line = null;
	BufferedReader in = null;
	in = new BufferedReader(new FileReader(args[1]));
	System.err.print("Writing multi-FASTA...");
	while ((line=in.readLine())!=null) {
	    GFFRecord gff = new GFFRecord(line);
	    if (gff.seqid!=null) {
		Strand strand;
		if (gff.strand=='+') {
		    strand = Strand.POSITIVE;
		} else if (gff.strand=='-') {
		    strand = Strand.NEGATIVE;
		} else {
		    strand = Strand.UNDEFINED;
		}
		try {
		    DNASequence seq = new DNASequence(fastaMap.get(gff.seqid).getSequenceAsString(gff.start, gff.end, strand));
		    seq.setAccession(new AccessionID(gff.attributeName));
		    writer.writeSequence(System.out, seq);
		} catch (Exception ex) {
		    // do nothing - Exception is thrown if getSequenceAsString fails
		}
	    }
	}
	System.err.println("done.");
	in.close();

    }

}

