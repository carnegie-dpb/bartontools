import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedReader;
import java.io.FileReader;

/**
 * Reads in a PSL formatted file and outputs a GFF file, condensing identical blocks into a single ones according to GFFRecord's 
 * equals method.
 *
 * input.psl   PSL file to process
 * source      GFF source of data (e.g. BartonLab)
 * assembly    assembly (e.g. Trinity-1a), placed in assembly_name attribute
 * feature     GFF feature (e.g. transcript)
 * minLength   minimum transcript length to keep (e.g. 100)
 * minScore    minimum score to keep (e.g. 98.0)
 *
 * @author Sam Hokin
 */

public class PSL2GFF {

    public static void main(String[] args) {

	if (args.length<6) {
	    System.out.println("java PSL2GFF <input.psl> <source> <assembly> <feature> <minLength>");
	    System.out.println("\tinput.psl\tPSL file to process");
	    System.out.println("\tsource\t\tGFF source of data (e.g. BartonLab)");
	    System.out.println("\tassembly\tassembly (e.g. Trinity-1a), placed in assembly_name attribute");
	    System.out.println("\tfeature\t\tGFF feature (e.g. transcript)");
	    System.out.println("\tminLength\tminimum transcript length to keep (e.g. 100)");
	    System.out.println("\tminScore\tminimum % score to keep (e.g. 98.0)");
	    System.exit(0);
	}

	// inputs
	String pslFile = args[0];
	String source = args[1];
	String assembly = args[2];
	String feature = args[3];
	int minLength = Integer.parseInt(args[4]);
	double minScore = Double.parseDouble(args[5]);

	try {
	    int id = 0;
	    String line = null;
	    BufferedReader in = new BufferedReader(new FileReader(pslFile));
	    while ((line=in.readLine())!=null) {
		PSLRecord psl = new PSLRecord(line);
		if (psl.qName!=null) {
		    // pull part before |, which often applies to Trinity transcripts
		    String[] pieces = psl.qName.split("\\|");
		    psl.qName = pieces[0];
		    // GFF score = percentage matched
		    double score = (double)(psl.matches+psl.repMatches)/(double)(psl.matches+psl.misMatches+psl.repMatches)*100;
		    if (score>minScore) {
			// output a GFF record for each block from the PSL record
			for (int i=0; i<psl.blockCount; i++) {
			    if (psl.blockSizes[i]>=minLength) {
				id++;
				String idStr = "PSL2GFF"+id;
				String attributes = "ID="+idStr+";Name="+psl.qName+";assembly_name="+assembly;
				GFFRecord gff = new GFFRecord(psl.tName, source, 
							      feature, psl.tStarts[i]+1, psl.tStarts[i]+psl.blockSizes[i], ""+score, psl.strand, '.',
							      attributes);
				System.out.println(gff.toString());
			    }
			}
		    }
		}
	    }
	    in.close();
	} catch (Exception ex) {
	    System.err.println(ex.toString());
	}

    }

}
