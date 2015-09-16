import java.io.FileReader;
import java.io.BufferedReader;

/**
 * Parses the output from bedtools coverage to form a matrix file with genes on rows and samples on columns for input into R for analysis
 *
 * The input files are given on the command line.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision$ $Date$
 */
public class CoverageParser {

  public static void main(String[] args) {

    if (args.length==0) {
      System.err.println("Usage: CoverageParser coveragefile1.txt coveragefile2.txt ...");
      return;
    }

    int num = args.length;
    BufferedReader[] br = new BufferedReader[num];

    try {

      // load each file into a BufferedReader
      for (int i=0; i<num; i++) {
	br[i] = new BufferedReader(new FileReader(args[i]));
      }

      // write out the header in R format (no heading for gene column)
      System.out.print(args[0]);
      for (int i=1; i<num; i++) System.out.print("\t"+args[i]);
      System.out.println("");
      
      // It is assumed each file is exactly the same length and line order; otherwise this will fail miserably.
      // Normally that is the case if the original sample data is from the same assay.
      String lines[] = new String[num];
      while ((lines[0]=br[0].readLine()) != null) {

	// get the same line from the other files
	for (int i=1; i<num; i++) lines[i] = br[i].readLine();

	// parse first line to see if it's a gene line
	String[] pieces = lines[0].split("\t");
	if (pieces[2].equals("gene")) {
	  String idChunk = pieces[8];
	  String[] idPieces = idChunk.split("=");
	  String[] idMorePieces = idPieces[1].split(";");
	  String geneID = idMorePieces[0];
	  int[] counts = new int[num];
	  counts[0] = Integer.parseInt(pieces[9]);
	  for (int i=1; i<num; i++) {
	    pieces = lines[i].split("\t");
	    counts[i] = Integer.parseInt(pieces[9]);
	  }
	  // output this line
	  System.out.print(geneID);
	  for (int i=0; i<num; i++) System.out.print("\t"+counts[i]);
	  System.out.println("");
	}

      }

    } catch (Exception ex) {
      
      System.out.println(ex.getMessage());
      return;
      
    }

  }

}

      


