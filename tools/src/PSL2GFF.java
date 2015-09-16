import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.TreeSet;

/**
 * Reads in a PSL formatted file and outputs a GFF file, condensing identical blocks into a single ones according to GFFRecord's 
 * equals method.
 * minLength [int] minimum feature length to keep
 * trinity [true/false] tells the code to pull the feature name from the trinity-style query name before the | symbol.
 */

public class PSL2GFF {

    public static void main(String[] args) {

	if (args.length<6) {
	    System.out.println("java PSL2GFF <input.psl> <source> <assembly> <feature> <minLength> <trinity>");
	    System.exit(0);
	}

	// inputs
	String pslFile = args[0];
	String source = args[1];
	String assembly = args[2];
	String feature = args[3];
	int minLength = Integer.parseInt(args[4]);
	boolean trinity = Boolean.parseBoolean(args[5]);

	// place the saved GFF records in a TreeSet so they're automatically sorted
	TreeSet<GFFRecord> gffSet = new TreeSet<GFFRecord>();
	try {
	    String line = null;
	    BufferedReader in = new BufferedReader(new FileReader(pslFile));
	    while ((line=in.readLine())!=null) {
		PSLRecord psl = new PSLRecord(line);
		if (psl.qName!=null) {
		    if (trinity) {
			String[] pieces = psl.qName.split("\\|");
			psl.qName = pieces[0];
		    }
		    // GFF score = percentage matched
		    double score = (double)(psl.matches+psl.repMatches)/(double)(psl.matches+psl.misMatches+psl.repMatches)*100;
		    // add a GFF record for each block from the PSL record
		    for (int i=0; i<psl.blockCount; i++) {
			if (psl.blockSizes[i]>=minLength) {
			    GFFRecord gff = new GFFRecord(psl.tName, source, feature,
							  psl.tStarts[i]+1, psl.tStarts[i]+psl.blockSizes[i], ""+score, psl.strand, '.',
							  "Name="+psl.qName+";assembly_name="+assembly+";");
			    gffSet.add(gff);
			}
		    }
		}
	    }
	    in.close();
	} catch (Exception ex) {
	    System.err.println(ex.toString());
	}

	// Write out the sorted, condensed set of GFF records
	System.out.println("##gff-version 3");
	for (GFFRecord gff : gffSet) {
	    System.out.println(gff.toString());
	}

    }

}
