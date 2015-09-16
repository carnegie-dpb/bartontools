import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.LinkedHashMap;
import java.util.Map.Entry;
import java.util.ArrayList;

import org.biojava.nbio.core.sequence.DNASequence;
import org.biojava.nbio.core.sequence.io.FastaReaderHelper;
import org.biojava.nbio.core.sequence.io.FastaWriterHelper;

/**
 * Removes sequences from a FASTA file that are listed in a BED file.
 */

public class SequenceRemover {

    public static void main(String[] args) throws Exception{

	if (args.length<2) {
	    System.out.println("Usage: java SequenceRemover <FASTAfile> <BEDfile>");
	    System.exit(0);
	}
	
	// a map of sequences in the FASTA file
	LinkedHashMap<String,DNASequence> fastaMap = FastaReaderHelper.readFastaDNASequence(new File(args[0]));

	// list of names in the BED6 file
	ArrayList<String> bedNameList = new ArrayList<String>();
	try {
	    String line = null;
	    BufferedReader in = new BufferedReader(new FileReader(args[1]));
	    while ((line=in.readLine())!=null) {
		BED6Record bed = new BED6Record(line);
		// remove before | symbol if it exists
		String[] chunks = bed.name.split("\\|");
		bedNameList.add(chunks[0]);
	    }
	    in.close();
	} catch (Exception ex) {
	    System.err.println(ex.toString());
	}

	// run through the FASTA file, output sequence if it is NOT in the list of BED6 names
	FastaWriterHelper writer = new FastaWriterHelper();
	for (  Entry<String,DNASequence> entry : fastaMap.entrySet() ) {
	    String name = (String) entry.getKey();
	    DNASequence sequence = (DNASequence) entry.getValue();
	    if (bedNameList.contains(name)) {
		// do nothing
	    } else {
		writer.writeSequence(System.out, sequence);
	    }
	}

    }

}
