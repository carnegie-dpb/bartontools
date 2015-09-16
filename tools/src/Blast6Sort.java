import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStreamReader;

import java.util.HashMap;
import java.util.TreeSet;
import java.util.Collections;

/**
 * Sorts a BLAST outfmt 6 file by Blast6Record's NameComparator.
 * Options:
 * --trim-trinity            trim off the part after | in the Trinity-assigned query name
 * --append-target-to-query  append the target name to the query name
 * --group-neighbors=N       group neighbors within N bases of each other
 * --min-bitscore=N          drop hits with bitscore less than N
 */

public class Blast6Sort {

    public static void main(String[] args) {

	if (args.length==0) {
	    System.out.println("java Blast6Sort --help --trim-trinity --append-target-to-query --group-neighbors=N --min-bitscore=N blast6.out|-");
	    System.exit(0);
	}

	// parse command line
	HashMap<String,String> options = new HashMap<String,String>();
	boolean stdInput = false;
	String blastFile = null;
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
		blastFile = args[i];
	    }
	}
	// the options
	boolean help = options.containsKey("help"); // show help and exit
	boolean trimTrinity = options.containsKey("trim-trinity");
	boolean appendTarget = options.containsKey("append-target-to-query");
	int maxNeighborGap = 10000;
	boolean groupNeighbors = options.containsKey("group-neighbors"); // American spelling, muthas
	if (groupNeighbors && options.get("group-neighbors").length()>0) maxNeighborGap = Integer.parseInt(options.get("group-neighbors"));
	int minBitScore = 0;
	if (options.containsKey("min-bitscore") && options.get("min-bitscore").length()>0) minBitScore = Integer.parseInt(options.get("min-bitscore"));

	// spit out help and exit
	if (help) {
	    System.out.println("java Blast6Sort --help --trim-trinity --append-target-to-query --group-neighbors=N --min-bitscore=N blast6.out|-");
	    System.out.println("Sorts a BLAST -outfmt 6 file by Blast6Record's NameComparator.");
	    System.out.println("Options:");
	    System.out.println("\t--trim-trinity\t\t\ttrim off the part after | in the Trinity-assigned query names");
	    System.out.println("\t--append-target-to-query\tappend the target name to the query name");
	    System.out.println("\t--group-neighbors=N\t\tgroup neighbors within N bases of each other [10000]");
	    System.out.println("\t--min-bitscore=N\t\tdrop hits with bitscore less than N [0]");
	    System.exit(0);
	}

	// place the Blast6 records in a TreeSet for sorting
	TreeSet<Blast6Record> blastSet = new TreeSet<Blast6Record>();
	String line = null;
	try {
	    BufferedReader in = null;
	    if (stdInput) {
		in = new BufferedReader(new InputStreamReader(System.in));
	    } else if (blastFile!=null) {
		in = new BufferedReader(new FileReader(blastFile));
	    }
	    while ((line=in.readLine())!=null) {
		Blast6Record blast = new Blast6Record(line);
		if (blast.queryLabel!=null) {
		    if (trimTrinity) {
			String[] pieces = blast.queryLabel.split("\\|");
			blast.queryLabel = pieces[0];
		    }
		    if (appendTarget) {
			blast.queryLabel += "."+blast.targetLabel;
		    }
		    if (blast.bitScore>=minBitScore) blastSet.add(blast);
		} else {
		    System.out.println(line);
		}
	    }
	    in.close();
	} catch (Exception ex) {
	    System.err.println(ex.toString());
	    System.err.println("Offending line:");
	    System.err.println(line);
	}

	// write out the sorted Blast6 records, optionally appending an additional identifier for nearby hits if requested
	Blast6Record lastContig = new Blast6Record();
	int scaffold = 0;
	for (Blast6Record contig : blastSet) {
	    // neighbors are hits within maxNeighborGap of each other
	    if (groupNeighbors) {
		if (Blast6Record.gap(contig,lastContig)>maxNeighborGap) scaffold++;
		contig.queryLabel += "."+scaffold;
	    }
	    System.out.println(contig.toString());
	    lastContig = contig;
	}

    }

}
