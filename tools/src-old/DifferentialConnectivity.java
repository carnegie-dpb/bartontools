import java.util.ArrayList;
import edu.carnegiescience.dpb.bartonlab.*;
import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;

/**
 * Analyze differential connectivity: the difference between the number of correlated genes (given a criterion) under a condition and WT.
 * Restricted to genes that show significant DE UP expression (logFC>1.0, p<0.05) under the given condition.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class DifferentialConnectivity {

  static int TAIRVERSION = 9;
  static String EXPRESSIONTABLE = "deseq2f_expression";
  static String RESULTSTABLE = "deseq2f_results";

  public static void main(String[] args) {

    if (args.length!=2) {
      System.out.println("Usage: DifferentialConnectivity condition corrPearsonThreshhold");
      return;
    }

    DB db1 = null;
    DB db2 = null;

    try {

      String condition = args[0];
      double threshold = Double.parseDouble(args[1]);

      db1 = new DB();
      db2 = new DB();

      Sample[] samples = Sample.getAll(db1);

      PearsonsCorrelation pCorr = new PearsonsCorrelation();

      String[] conditions = new String[1];
      conditions[0] = condition;
      int[] directions = { DESeq2Result.UP };

      TAIRGene[] genes = DESeq2Result.searchOnValuesAndDirections(db1, db2, TAIRVERSION, RESULTSTABLE, "WT", conditions, 1, 1.0, 0.05, directions);

      Expression[] expr = new Expression[genes.length];
      for (int i=0; i<expr.length; i++) {
	expr[i] = new Expression(db1, EXPRESSIONTABLE, genes[i]);
	expr[i].values = Expression.log21p(expr[i].values); // convert to log2 to discount outliers in correlation
      }

      // scan full 2-way correlation matrix, checking DE first
      for (int i=0; i<expr.length; i++) {
	// scan over WT
	int countWT = 0;
	for (int j=0; j<expr.length; j++) {
	  if (j!=i) {
	    double corr = pCorr.correlation(getValues(samples,expr[i],"WT"), getValues(samples,expr[j],"WT"));
	    if (Math.abs(corr)>threshold) countWT++;
	  }
	}
	// scan over condition
	int countCondition = 0;
	for (int j=0; j<expr.length; j++) {
	  if (j!=i) {
	    double corr = pCorr.correlation(getValues(samples,expr[i],condition), getValues(samples,expr[j],condition));
	    if (Math.abs(corr)>threshold) countCondition++;
	  }
	}
	// output the numbers
	System.out.println(expr[i].gene.id+"\t"+countCondition+"\t"+countWT+"\t"+(countCondition-countWT));
      }

    } catch (Exception ex) {

      System.out.println(ex.toString());

    } finally {

      try {
	db1.close();
	db2.close();
      } catch (Exception ex) {
	System.out.println(ex.toString());
      }

    }

  }

  /**
   * Return an array of values from the given expression that correspond to the given sample conditions
   */
  public static double[] getValues(Sample[] samples, Expression expr, String condition) {
    ArrayList<Double> list = new ArrayList<Double>();
    for (int i=0; i<samples.length; i++) {
      if (samples[i].condition.equals(condition)) list.add(expr.values[i]);
    }
    double[] vals = new double[list.size()];
    for (int i=0; i<vals.length; i++) vals[i] = (double) list.get(i);
    return vals;
  }

}
