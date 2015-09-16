import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.HashMap;

/**
 * Offset mapped read locations in the given SAM file by the positions of the ref seqs given in the GFF file.
 */

public class SAMOffsetter {

    public static void main(String[] args) throws Exception{

	if (args.length<2) {
	    System.out.println("Usage: java SAMOffsetter <SAM file> <GFF file>");
	    System.exit(0);
	}

	String samFilename = args[0];
	String gffFilename = args[1];
	
	// Load the GFF file features into a HashMap for quick access when they appear in the SAM file
	// using attributeName as the key between the GFF and the SAM file
	HashMap<String,GFFRecord> gffHash = new HashMap<String,GFFRecord>();
	try {
	    String line = null;
	    BufferedReader in = new BufferedReader(new FileReader(gffFilename));
	    while ((line=in.readLine())!=null) {
		GFFRecord gff = new GFFRecord(line);
		if (gff.attributeName!=null) {
		    gffHash.put(gff.attributeName, gff);
		}
	    }
	    in.close();
	} catch (Exception ex) {
	    System.err.println(ex.toString());
	}

	// Now scan through the SAM file, replacing each POS value with POS+start-1 where start is found in the GFF file for this
	// ref seq.
	String line = null;
	BufferedReader in = new BufferedReader(new FileReader(samFilename));
	while ((line=in.readLine())!=null) {
	    if (line.charAt(0)=='@') {
		// header line
		System.out.println(line);
	    } else {
		SAMRecord sam = new SAMRecord(line);
		if (sam!=null && sam.qname!=null) {
		    // offset
		    GFFRecord gff = gffHash.get(sam.rname);
		    if (gff!=null && gff.attributeName!=null) {
			sam.rname = gff.seqid;
			sam.pos += gff.start - 1;
			System.out.println(sam.toString());
		    }
		}
	    }
	}
	
    }

}
    
    
	
