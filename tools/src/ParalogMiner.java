import edu.carnegiescience.dpb.bartonlab.*;
import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;

/**
 * Run through all genes for bl2012, dumping out pairs that have WT Pearson's correlation greater than the input value (sign-definite) over ALL samples for both bl2012 AND bl2013.
 * Absolute values are used, not log2, since we're looking for true paralogs.
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class ParalogMiner {

  public static void main(String[] args) {

    if (args.length!=1) {
      System.err.println("Usage: ParalogMiner corrMin");
      return;
    }

    double corrMin = Double.parseDouble(args[0]);

    DB db = null;

    try {

      // we'll use one connection throughout
      db = new DB();

      // expression for all bl2012 genes
      db.setSearchPath("bl2012");
      Expression[] expr12 = Expression.getAll(db);

      // now we'll use db for bl2013 comparisons
      db.setSearchPath("bl2013");

      PearsonsCorrelation pCorr = new PearsonsCorrelation();

      for (int i=0; i<expr12.length; i++) {
	for (int j=i+1; j<expr12.length; j++) {
	  double pc12 = pCorr.correlation(expr12[i].values, expr12[j].values);
	  if (!Double.isNaN(pc12) && pc12>corrMin) {
	    // get bl2013 version
	    Expression expr13a = new Expression(db, expr12[i].gene);
	    Expression expr13b = new Expression(db, expr12[j].gene);
	    if (expr13a.values!=null && expr13b.values!=null && expr13a.values.length==expr13b.values.length) {
	      double pc13 = pCorr.correlation(expr13a.values, expr13b.values);
	      if (!Double.isNaN(pc13) && pc13>corrMin) {
		System.out.println(expr12[i].gene.id+"\t"+expr12[j].gene.id+"\t"+pc12+"\t"+pc13);
	      }
	    } else {
	      System.out.println(expr12[i].gene.id+"\t"+expr12[j].gene.id+"\t"+expr13a.values+"\t"+expr13b.values);
	    }
	  }
	}
      }
      
      // done with db
      db.close();

    } catch (Exception ex) {

      System.out.println(ex.toString());

    }

  }

    
}
