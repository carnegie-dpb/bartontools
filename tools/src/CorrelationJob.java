import edu.carnegiescience.dpb.bartonlab.*;

import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;

/**
 * Run correlation of all genes against all genes for WT plus an optional input condition, outputting Pearson's if it is above corrMin
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class CorrelationJob {

  public static void main(String[] args) {

    if (args.length<2) {
      System.err.println("Usage: CorrelationJob schema corrMin [condition]");
      return;
    }

    String schema = args[0];
    Double corrMin = Double.parseDouble(args[1]);
    String condition = null;
    if (args.length==3) condition = args[2];

    DB db = null;

    try {

      // we'll use one connection throughout
      db = new DB();
      db.setSearchPath(schema);

      // get samples for WT and optional condition
      Sample[] samples;
      if (condition==null) {
	samples = Sample.get(db, "WT");
      } else {
	String[] conditions = new String[2];
	conditions[0] = "WT";
	conditions[1] = condition;
	samples = Sample.get(db, conditions);
      }
      int numSamples = samples.length;

      // expression for all genes over all conditions
      Expression[] expr = Expression.getAll(db);
      int numGenes = expr.length;

      // done with db
      db.close();

      // now build a 2-d matrix with expression for the samples we want
      double[][] exprMatrix = new double[numGenes][numSamples];
      for (int i=0; i<numGenes; i++) {
	for (int k=0; k<numSamples; k++) {
	  exprMatrix[i][k] = expr[i].values[samples[k].num-1];
	}
      }

      // header
      System.out.println("gene1\tgene2\tpCorr\tpCorr2");

      // now crank the correlation matrix
      PearsonsCorrelation pCorr = new PearsonsCorrelation();
      for (int i=0; i<numGenes; i++) {
	for (int j=i+1; j<numGenes; j++) {
	  double pc = pCorr.correlation(exprMatrix[i], exprMatrix[j]);
	  if (Math.abs(pc)>corrMin) System.out.println(expr[i].gene.id+"\t"+expr[j].gene.id+"\t"+pc+"\t"+pc*pc);
	}
      }
      
    } catch (Exception ex) {

      System.out.println(ex.toString());

    }

  }

    
}
