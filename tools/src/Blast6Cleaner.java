import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.TreeSet;


/**
 * Clean duplicate sequences from a BLAST outfmt 6 file, removing identical target maps with inferior percent identity.
 */

public class Blast6Cleaner {

    public static void main(String[] args) throws Exception{

	if (args.length<1) {
	    System.out.println("Usage: java Blast6Cleaner <Blast outfmt 6 file>");
	    System.exit(0);
	}
	
	// inputs
	String blast6File = args[0];

	// step 1 - sort based on bit score for otherwise equal hits
	TreeSet<Blast6Record> sortingSet = new TreeSet<Blast6Record>(Blast6Record.BitScoreComparator);
	try {
	    String line = null;
	    BufferedReader in = new BufferedReader(new FileReader(blast6File));
	    while ((line=in.readLine())!=null) {
		sortingSet.add(new Blast6Record(line));
	    }
	    in.close();
	} catch (Exception ex) {
	    System.err.println(ex.toString());
	}

	// step 2 - load the sorted records into a target-sorted set to eliminate lesser hits on the same target range
	TreeSet<Blast6Record> cullingSet = new TreeSet<Blast6Record>(Blast6Record.TargetComparator);
	cullingSet.addAll(sortingSet);

	// Write out the culled records
	for (Blast6Record br : cullingSet) {
	    System.out.println(br.toString());
	}

    }

}
