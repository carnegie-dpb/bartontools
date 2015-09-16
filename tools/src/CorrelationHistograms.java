import edu.carnegiescience.dpb.bartonlab.*;

import java.text.DecimalFormat;
import java.util.Scanner;
import java.util.TreeSet;

/**
 * Run through all of the genes, binning the correlations with all other genes and outputting one line per gene.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class CorrelationHistograms {

  public static void main(String[] args) {

    DecimalFormat df = new DecimalFormat(" 0.0;-0.0");

    if (args.length!=2) {
      System.out.println("Usage: CorrelationHistograms schema condition");
      return;
    }

    String schema = args[0];
    String condition = args[1];

    DB db = null;

    try {

      db = new DB();
      db.setSearchPath(schema);

	  // samples for condition selection
	  Sample[] samples = new Sample[0];
	  if (condition.equals("ALL")) {
		  samples = Sample.getAll(db);
	  } else {
		  samples = Sample.get(db, condition);
	  }

      // expression for all genes
      System.out.print("Loading expression for all genes...");
      Expression[] expr = Expression.getAll(db);
      System.out.println("done.");

      db.close();

      // gene1 loop
      for (int i=0; i<expr.length; i++) {

	// store corrs in a TreeSet for later binning
	TreeSet<Double> set = new TreeSet<Double>();

	// gene2 loop
	for (int j=0; j<expr.length; j++) {
	    set.add(CorrelationResult.spearmansCorrelation(expr[i].values, expr[j].values, samples));
	}

	// now output counts within bins
	System.out.print(expr[i].gene.id);
	for (double d=-1.0; d<0.95; d+=0.1) {
	  System.out.print("\t"+set.subSet(d,d+0.1).size());
	}
	System.out.println("");

      }

    } catch (Exception ex) {

      System.out.println(ex.toString());

    }

  }

    
}
