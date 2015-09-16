import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.LinkedHashMap;
import java.util.TreeSet;
import java.util.Map;

import org.biojava.nbio.core.sequence.AccessionID;
import org.biojava.nbio.core.sequence.DNASequence;
import org.biojava.nbio.core.sequence.io.FastaReaderHelper;
import org.biojava.nbio.core.sequence.io.FastaWriterHelper;

/**
 * Clean duplicate sequences from a FASTA file.
 */

public class FastaCleaner {

    public static void main(String[] args) throws Exception{

	if (args.length<1) {
	    System.out.println("Usage: java FastaCleaner <FASTA file>");
	    System.exit(0);
	}
	
	// a map of sequences in the FASTA file
	LinkedHashMap<String,DNASequence> fastaMap = FastaReaderHelper.readFastaDNASequence(new File(args[0]));

	// run through the map, placing sequences in a Set of ComparableSequences which enforces unique sequences
	TreeSet<ComparableSequence> seqSet = new TreeSet<ComparableSequence>();
	for (  Map.Entry<String,DNASequence> entry : fastaMap.entrySet() ) {
	    DNASequence dna = (DNASequence) entry.getValue();
	    seqSet.add(new ComparableSequence(dna));
	}

	// output the resulting set
	FastaWriterHelper writer = new FastaWriterHelper();
	for (ComparableSequence seq : seqSet) {
	    writer.writeSequence(System.out, seq.dna);
	}

    }

}
