import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Collections;
import java.util.Comparator;
import java.util.ArrayList;

import org.biojava.nbio.core.sequence.AccessionID;
import org.biojava.nbio.core.sequence.DNASequence;
import org.biojava.nbio.core.sequence.io.FastaReaderHelper;
import org.biojava.nbio.core.sequence.io.FastaWriterHelper;

/**
 * Simply reformats the sequences from a FASTA file that has inconsistent line lengths
 */

public class FastaReformat {

    public static void main(String[] args) throws Exception{

	if (args.length<1) {
	    System.out.println("Usage: java FastaReformat input.fasta");
	    System.exit(0);
	}

	String filename = args[0];
	
	// read in a map of sequences in the FASTA file
	LinkedHashMap<String,DNASequence> fastaMap = FastaReaderHelper.readFastaDNASequence(new File(filename));

	// output each sequence
	FastaWriterHelper writer = new FastaWriterHelper();
	for (  Map.Entry<String,DNASequence> entry : fastaMap.entrySet() ) {
	    DNASequence seq = (DNASequence) entry.getValue();
	    writer.writeSequence(System.out, seq);
	}

    }

}
