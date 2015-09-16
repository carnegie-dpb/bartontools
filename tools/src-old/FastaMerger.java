import java.io.File;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Collections;
import java.util.Comparator;
import java.util.ArrayList;
import java.util.TreeSet;

import org.biojava.nbio.core.sequence.AccessionID;
import org.biojava.nbio.core.sequence.DNASequence;
import org.biojava.nbio.core.sequence.io.FastaReaderHelper;
import org.biojava.nbio.core.sequence.io.FastaWriterHelper;

/**
 * Merge sequences from a FASTA file into one single sequence with each original sequence separated by SEPARATOR.
 * Also output a GFF containing the positions of the original sequences.
 * Output files are named input-merged.fa and input-merged.gff if input file is input.fasta or input.fa.
 * If stdin is used, output files are merged.fa and merged.gff.
 */

public class FastaMerger {

    public static final String SEPARATOR = "NNNNNNNNN";

    public static void main(String[] args) throws Exception{

	if (args.length<1) {
	    System.out.println("Usage: java FastaMerger --help --trinity --id=accession_id input.fasta|-");
	    System.exit(0);
	}

	// parse command line
	HashMap<String,String> options = new HashMap<String,String>();
	String filename = null;
	boolean stdInput = false;
	for (int i=0; i<args.length; i++) {
	    if (args[i].equals("-")) {
		stdInput = true;
	    } else if (args[i].startsWith("--")) {
		String[] pieces = args[i].split("=");
		String option = pieces[0].substring(2);
		String value = "";
		if (pieces.length>1) value = pieces[1];
		options.put(option,value);
	    } else {
		filename = args[i];
	    }
	}

	// the options
	boolean help = options.containsKey("help"); // show help and exit
	boolean trinity = options.containsKey("trinity");
	String accessionID = "";
	if (options.containsKey("id")) accessionID = options.get("id");

	// spit out help and exit
	if (help) {
	    System.out.println("java FastaMerger --help --thin-trinity-genes --id=accession_id input.fasta|-");
	    System.out.println("Merges a FASTA file containing many sequences into a single FASTA sequence.");
	    System.out.println("Options:");
	    System.out.println("\t--trinity\tkeep Trinity genes in order (so TR200 precedes TR1000)");
	    System.out.println("\t--id=accession_id\tset the accession id placed at the top of the FASTA file: >accession_id");
	    System.exit(0);
	}

	if (filename==null && !stdInput) {
	    System.out.println("FASTA file name or stdin flag (-) is missing.");
	    System.out.println("Usage: java FastaMerger --help --trinity --id=accession_id input.fasta|-");
	    System.exit(0);
	}	    

	// get a map of sequences from the FASTA file
	LinkedHashMap<String,DNASequence> fastaMap;
	if (stdInput) {
	    fastaMap = FastaReaderHelper.readFastaDNASequence(System.in);
	} else {
	    fastaMap = FastaReaderHelper.readFastaDNASequence(new File(filename));
	}

	// load sequences into a TreeSet for sorting and thinning
	TreeSet<DNASequence> seqSet;
	if (trinity) {
	    // use the TrinityComparator for sorting
	    seqSet = new TreeSet<DNASequence>(TrinityComparator);
	} else {
	    // use an accession ID comparator - not the greatest choice if IDs go like A1, A2, ..., A1000, A1001
	    seqSet = new TreeSet<DNASequence>(AccessionIDComparator);
	    seqSet.addAll(fastaMap.values());
	}

	// create the output files
	File gffFile = null;
	File fastaFile = null;
	if (stdInput) {
	    gffFile = new File("merged.gff");
	    fastaFile = new File("merged.fa");
	} else {
	    String[] parts = filename.split("\\.");
	    gffFile = new File(parts[0]+"-merged.gff");
	    fastaFile = new File(parts[0]+"-merged.fa");
	}
	FileWriter gffWriter = new FileWriter(gffFile);

	// append each sequence to the merged sequence, outputting GFF line for each one
	String sequence = "";
	int separatorLength = SEPARATOR.length();
	int start = 1;
	gffWriter.write("##gff-version 3\n");
	for ( DNASequence seq : seqSet ) {
	    String id = seq.getAccession().getID();
	    String s = seq.getSequenceAsString();
	    if (s.length()==0) {
		System.err.println("ERROR: sequence of length 0 found.");
		System.exit(1);
	    }
	    sequence += s+SEPARATOR;
	    // write GFF line
	    int end = start + s.length() - 1;
	    String attributes = "Name="+id+";Note="+id+";"; // include Note for GBrowse
	    GFFRecord gff = new GFFRecord(accessionID, "source", "type", start, end, ".", '+', '.', attributes);
	    gffWriter.write(gff.toString()+"\n");
	    // increment GFF position
	    start = end + separatorLength + 1;
	}
	gffWriter.close();

	// output the merged sequence
	DNASequence merged = new DNASequence(sequence);
	merged.setAccession(new AccessionID(accessionID));
	FastaWriterHelper writer = new FastaWriterHelper();
	writer.writeSequence(fastaFile, merged);

    }

    /**
     * Compare based on accessionID, alpha ascending
     */
    public static final Comparator<DNASequence> AccessionIDComparator = new Comparator<DNASequence>() {
	@Override
	public int compare(DNASequence seq1, DNASequence seq2) {
	    return seq1.getAccession().getID().compareTo(seq2.getAccession().getID());
	}
    };

    /**
     * Compare based on Trinity TR #, cluster #, gene # and instance #
     */
    public static final Comparator<DNASequence> TrinityFullComparator = new Comparator<DNASequence>() {
	@Override
	public int compare(DNASequence seq1, DNASequence seq2) {
	    // seq1
	    String id1 = seq1.getAccession().getID();
	    String[] ch1 = id1.split("_");
	    int tr1 = Integer.parseInt(ch1[0].substring(2));   // [TR]1234, etc.
	    int clus1 = Integer.parseInt(ch1[1].substring(1)); // [c]0, [c]1, etc.
	    int gene1 = Integer.parseInt(ch1[2].substring(1)); // [g]1, [g]2, etc.
	    // seq2
	    String id2 = seq2.getAccession().getID();
	    String[] ch2 = id2.split("_");
	    int tr2 = Integer.parseInt(ch2[0].substring(2));   // [TR]1234, etc.
	    int clus2 = Integer.parseInt(ch2[1].substring(1)); // [c]0, [c]1, etc.
	    int gene2 = Integer.parseInt(ch2[2].substring(1)); // [g]1, [g]2, etc.
	    // compare
	    if (tr1!=tr2) {
		return tr1 - tr2;
	    } else if (clus1!=clus2) {
		return clus1 - clus2;
	    } else if (gene1!=gene2) {
		return gene1 - gene2;
	    } else {
		return seq2.getLength() - seq1.getLength();    // descending
	    }
	}
    };

    /**
     * Compare based on Trinity TR #, cluster # and gene #, to thin out sequences from the same gene.
     * NOTE: Trinity-generated pipe must be converted to underscore for this to work!
     */
    public static final Comparator<DNASequence> TrinityThinningComparator = new Comparator<DNASequence>() {
	@Override
	public int compare(DNASequence seq1, DNASequence seq2) {
	    // seq1
	    String id1 = seq1.getAccession().getID();
	    String[] ch1 = id1.split("_");
	    int tr1 = Integer.parseInt(ch1[0].substring(2));   // [TR]1234, etc.
	    int clus1 = Integer.parseInt(ch1[1].substring(1)); // [c]0, [c]1, etc.
	    int gene1 = Integer.parseInt(ch1[2].substring(1)); // [g]1, [g]2, etc.
	    // seq2
	    String id2 = seq2.getAccession().getID();
	    String[] ch2 = id2.split("_");
	    int tr2 = Integer.parseInt(ch2[0].substring(2));   // [TR]1234, etc.
	    int clus2 = Integer.parseInt(ch2[1].substring(1)); // [c]0, [c]1, etc.
	    int gene2 = Integer.parseInt(ch2[2].substring(1)); // [g]1, [g]2, etc.
	    // compare
	    if (tr1!=tr2) {
		return tr1 - tr2;
	    } else if (clus1!=clus2) {
		return clus1 - clus2;
	    } else {
		return gene1 - gene2;
	    }
	}
    };

}
