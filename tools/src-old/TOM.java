import java.util.ArrayList;
import edu.carnegiescience.dpb.bartonlab.*;
import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;

/**
 * Run through all of the genes for an input condition, filling the correlation matrix, then computing the Topological Overlap Matrix.
 * To keep size down, genes are restricted to those with provided DE logFC>threshold for the input condition.
 * If TOM exceets threshTOM it is output.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class TOM {

  static int TAIRVERSION = 9;
  static String EXPRESSIONTABLE = "deseq2f_expression";
  static String RESULTSTABLE = "deseq2f_results";
  static double BETA = 6.0;

  public static void main(String[] args) {

    if (args.length!=3) {
      System.out.println("Usage: TOM condition min(logFC) threshTOM");
      return;
    }

    String condition = args[0];
    double minlogFC = Double.parseDouble(args[1]);
    double threshTOM = Double.parseDouble(args[2]);

    DB db1 = null;
    DB db2 = null;

    try {

      db1 = new DB();
      db2 = new DB();

      Sample[] samples = Sample.getAll(db1);

      PearsonsCorrelation pCorr = new PearsonsCorrelation();

      // need conditions array
      String[] conditions = new String[1];
      conditions[0] = condition;

      // high DE genes
      TAIRGene[] gene = DESeq2Result.searchOnValues(db1, db2, TAIRVERSION, RESULTSTABLE, "WT", conditions, 1, minlogFC, 0.05);
      Expression[] expr = new Expression[gene.length];
      for (int i=0; i<expr.length; i++) {
	expr[i] = new Expression(db1, EXPRESSIONTABLE, gene[i]);
	expr[i].values = Expression.log21p(expr[i].values); // convert to log2 to discount outliers in correlation
      }
	    
      // weighted correlation matrix, which is symmetric
      double[][] a = new double[expr.length][expr.length];
      for (int i=0; i<expr.length; i++) {
	a[i][i] = 1.0;
	for (int j=i+1; j<expr.length; j++) {
	  double corr = pCorr.correlation(getValues(samples,expr[i],"WT",condition), getValues(samples,expr[j],"WT",condition));
	  a[i][j] = Math.pow(Math.abs(corr),BETA);
	  a[j][i] = a[i][j];
	}
      }

      // connectivity/degree
      double[] k = new double[expr.length];
      for (int i=0; i<expr.length; i++) {
	for (int j=0; j<expr.length; j++) {
	  if (j!=i) k[i] += a[i][j];
	}
      }		    

      // TOM, also symmetric in i,j
      for (int i=0; i<expr.length; i++) {
	for (int j=i+1; j<expr.length; j++) {
	  // inner sum of corrs over ALL?
	  double aaSum = 0.0;
	  for (int u=0; u<expr.length; u++) {
	    if (u!=i && u!=j) aaSum += a[i][u]*a[u][j];
	  }
	  double tom = (aaSum + a[i][j]) / (Math.min(k[i],k[j]) + 1.0 - a[i][j]);
	  if (tom>threshTOM) System.out.println(expr[i].gene.id+"\t"+expr[j].gene.id+"\t"+tom+"\t"+(1-tom));
	}
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
   * Return an array of values from the given expression that correspond to the given single sample conditions
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
    
  /**
   * Return an array of values from the given expression that correspond to the two given sample conditions
   */
  public static double[] getValues(Sample[] samples, Expression expr, String condition1, String condition2) {
    ArrayList<Double> list = new ArrayList<Double>();
    for (int i=0; i<samples.length; i++) {
      if (samples[i].condition.equals(condition1) || samples[i].condition.equals(condition2)) list.add(expr.values[i]);
    }
    double[] vals = new double[list.size()];
    for (int i=0; i<vals.length; i++) vals[i] = (double) list.get(i);
    return vals;
  }

    
}
