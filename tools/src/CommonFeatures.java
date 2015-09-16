/**
 * Compare two GFF files and output features which are common to both. They need not be mapped to the same sequence/chromosome; all that needs
 * to match is the feature Name in the attributes.
 */

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Iterator;
import java.util.TreeMap;
import java.util.TreeSet;

public class CommonFeatures {
  
    public static void main(String[] args) {
	
	if (args.length!=2) {
	    System.out.println("Usage: java CommonFeatures <gff1> <gff2>");
	    System.exit(1);
	}
	
	String gff1Filename = args[0];
	String gff2Filename = args[1];

	// fill a TreeSet with the names from the first file
	TreeSet<GFFRecord> gff1Set = new TreeSet<GFFRecord>();
	try {
	    String line = null;
	    BufferedReader in = new BufferedReader(new FileReader(gff1Filename));
	    while ((line=in.readLine())!=null) {
		gff1Set.add(new GFFRecord(line));
	    }
	    in.close();
	} catch (Exception ex) {
	    System.err.println(ex.toString());
	}

	// spit out the lines from the second file if the name is in the first file
	try {
	    String line = null;
	    BufferedReader in = new BufferedReader(new FileReader(gff2Filename));
	    while ((line=in.readLine())!=null) {
		GFFRecord record2 = new GFFRecord(line);
		if (gff1Set.contains(record2)) {
		    System.out.println(line);
		}
	    }
	    in.close();
	} catch (Exception ex) {
	    System.err.println(ex.toString());
	}

    }

}

	
