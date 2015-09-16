import java.util.ArrayList;
import edu.carnegiescience.dpb.bartonlab.*;
import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;

/**
 * Run through all of the genes for an input condition, dumping out pairs that have co-expression correlation exceeding the input threshold.
 * This variation restricts to correlation of all genes WITH high-DE genes for the given condition, where correlation is over [WT,condition];
 * OR, if gene1 is given, correlation of all genes against gene1.
 *
 * Dual version: TWO conditions are input, and correlations are only output if they exceed the threshold under both conditions.
 *
 * Only correlations above corrPearsonThreshold are output. Product of corrs is output (preserving sign asymmetry).
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class DualCorrelationMiner {

  static int TAIRVERSION = 9;
  static String EXPRESSIONTABLE = "deseq2f_expression";
  static String RESULTSTABLE = "deseq2f_results";
  static double BETA = 6.0;

  // DE filter params
  static double LOGFCMIN = 1.0; 
  static int MINCOUNTS = 1;
  static double MAXPADJ = 0.05;

  public static void main(String[] args) {

    if (args.length<3 || args.length>4) {
      System.out.println("Usage: DualCorrelationMiner condition1 condition2 corrPearsonThreshhold [gene1]");
      return;
    }

    String condition1 = args[0];
    String condition2 = args[1];
    double threshold = Double.parseDouble(args[2]);

    DB db1 = null;
    DB db2 = null;

    try {

      db1 = new DB();
      db2 = new DB();

      Sample[] samples = Sample.getAll(db1);

      PearsonsCorrelation pCorr = new PearsonsCorrelation();

      // all genes
      Expression[] expr2 = Expression.getAll(db1, EXPRESSIONTABLE);
      for (int i=0; i<expr2.length; i++) expr2[i].values = Expression.log21p(expr2[i].values); // convert to log2 to discount outliers in correlation

      if (args.length==3) {

	// need conditions array
	String[] conditions = new String[2];
	conditions[0] = condition1;
	conditions[1] = condition2;
	TAIRGene[] gene1 = DESeq2Result.searchOnValues(db1, db2, TAIRVERSION, RESULTSTABLE, "WT", conditions, MINCOUNTS, LOGFCMIN, MAXPADJ);

	// high DE genes - DE under BOTH conditions
	Expression[] expr1 = new Expression[gene1.length];
	for (int i=0; i<expr1.length; i++) {
	  expr1[i] = new Expression(db1, EXPRESSIONTABLE, gene1[i]);
	  expr1[i].values = Expression.log21p(expr1[i].values); // convert to log2 to discount outliers in correlation
	}

	// scan across all genes, checking correlation under condition1 and condition2
	for (int i=0; i<expr1.length; i++) {
	  ArrayList<Gene> genes2save = new ArrayList<Gene>();
	  ArrayList<Double> corrs2save = new ArrayList<Double>();
	  int count = 0;
	  for (int j=0; j<expr2.length; j++) {
	    if (!expr1[i].equals(expr2[j])) {
	      double corr1 = pCorr.correlation(getValues(samples,expr1[i],"WT",condition1), getValues(samples,expr2[j],"WT",condition1));
	      double corr2 = pCorr.correlation(getValues(samples,expr1[i],"WT",condition2), getValues(samples,expr2[j],"WT",condition2));
	      if (Math.abs(corr1)>threshold && Math.abs(corr2)>threshold) {
		count++;
		genes2save.add(expr2[j].gene);
		corrs2save.add(corr1*corr2);
	      }
	    }
	  }
	  // output the winning pairs
	  Gene[] genes = genes2save.toArray(new Gene[0]);
	  Double[] corrs = corrs2save.toArray(new Double[0]);
	  for (int k=0; k<genes.length; k++) {
	    double corr = (double) corrs[k];
	    // output combined conditions for edge identification
	    System.out.println(expr1[i].gene.id+"\t"+condition1+"+"+condition2+"\t"+genes[k].id+"\t"+corr);
	  }
	}

      } else {

	// scan correlation with given gene
	TAIRGene gene1 = new TAIRGene(db1, TAIRVERSION, args[2]);
	Expression expr1 = new Expression(db1, EXPRESSIONTABLE, gene1);
	expr1.values = Expression.log21p(expr1.values);

	// scan genes checking correlation under condition1 and condition2
	for (int j=0; j<expr2.length; j++) {
	  if (!expr1.equals(expr2[j])) {
	    double corr1 = pCorr.correlation(getValues(samples,expr1,"WT",condition1), getValues(samples,expr2[j],"WT",condition1));
	    double corr2 = pCorr.correlation(getValues(samples,expr1,"WT",condition2), getValues(samples,expr2[j],"WT",condition2));
	    if (Math.abs(corr1)>threshold && Math.abs(corr2)>threshold) {
	      // output condition between genes so we can combine networks
	      System.out.println(expr1.gene.id+"\t"+condition1+"+"+condition2+"\t"+expr2[j].gene.id+"\t"+corr1*corr2);
	    }
	  }
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
