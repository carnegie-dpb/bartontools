import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.TreeMap;
import java.util.Map;

/**
 * Computes the total depth per refseq in the given SAM file. This differs from samtools depth which totals for every position within
 * each refseq, so you have to add them up to get total depth per refseq. The SAM file does NOT have to be sorted. The output is sorted
 * alphabetically by refseq.
 */

public class SAMDepth {

    public static void main(String[] args) throws Exception{

	if (args.length<1) {
	    System.out.println("Usage: java SAMDepth <file.sam>");
	    System.exit(0);
	}
	String samFilename = args[0];

	TreeMap<String,Integer> tallyMap = new TreeMap<String,Integer>();

	BufferedReader in = new BufferedReader(new FileReader(samFilename));
	String line = null;
	while ((line=in.readLine())!=null) {
	    if (line.charAt(0)=='@') {
		// skip header lines
	    } else {
		SAMRecord sam = new SAMRecord(line);
		if (sam!=null && sam.rname!=null) {
		    // increment tally
		    int count = 0;
		    if (tallyMap.containsKey(sam.rname)) {
			count = tallyMap.get(sam.rname);
		    }
		    tallyMap.put(sam.rname, count+1);
		}
	    }
	}

	// output as tab-delimited columns
	System.out.println("RefSeq\tDepth");
	for (Map.Entry<String,Integer> entry : tallyMap.entrySet()) {
	    System.out.println(entry.getKey()+"\t"+entry.getValue());
	}
	
    }

}
