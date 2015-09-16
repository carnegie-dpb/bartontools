import java.util.ArrayList;
import edu.carnegiescience.dpb.bartonlab.*;
import org.apache.commons.math3.stat.correlation.PearsonsCorrelation;

/**
 * Run through all of the genes for an input condition, summing the weighted correlation to form the weighted connectivity, also outputting the
 * threshold connectivity.
 *
 * This variation restricts to connectivity of high-DE genes for the given condition, where correlation is over [WT,condition];
 * OR, if gene1 is given, connectivity of just gene1.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class Connectivity {

    static int TAIRVERSION = 9;

    public static void main(String[] args) {

	if (args.length<3 || args.length>4) {
	    System.out.println("Usage: Connectivity schema condition corrPearsonThreshhold [gene1]");
	    return;
	}

	String schema = args[0];
	String condition = args[1];
	double threshold = Double.parseDouble(args[2]);

	DB db1 = null;
	DB db2 = null;

	try {

	    db1 = new DB();
	    db2 = new DB();
	    db1.setSearchPath(schema);
	    db2.setSearchPath(schema);

	    Sample[] samples = Sample.getAll(db1);

	    PearsonsCorrelation pCorr = new PearsonsCorrelation();

	    // all genes
	    Expression[] expr2 = Expression.getAll(db1);
	    for (int i=0; i<expr2.length; i++) expr2[i].values = Expression.log21p(expr2[i].values); // convert to log2 to discount outliers in correlation

	    if (args.length==2) {

		// need conditions array
		String[] conditions = new String[1];
		conditions[0] = condition;
		TAIRGene[] gene1 = DESeq2Result.searchOnValues(db1, db2, TAIRVERSION, "WT", conditions, 1, 1.0, 0.05);

		// high DE genes
		Expression[] expr1 = new Expression[gene1.length];
		for (int i=0; i<expr1.length; i++) {
		    expr1[i] = new Expression(db1, gene1[i]);
		    expr1[i].values = Expression.log21p(expr1[i].values); // convert to log2 to discount outliers in correlation
		}

		// scan against all genes
		for (int i=0; i<expr1.length; i++) {
		    ArrayList<Gene> genes2save = new ArrayList<Gene>();
		    ArrayList<Double> corrs2save = new ArrayList<Double>();
		    double weightedConn = 0.0;
		    int thresholdConn = 0;
		    for (int j=0; j<expr2.length; j++) {
			if (!expr1[i].equals(expr2[j])) {
			    double corr = pCorr.correlation(getValues(samples,expr1[i],"WT",condition), getValues(samples,expr2[j],"WT",condition));
			    weightedConn += Math.pow(Math.abs(corr),6.0); // use beta=6.0
			    if (Math.abs(corr)>threshold) thresholdConn++;
			}
		    }
		    // output the connectivity
		    System.out.println(expr1[i].gene.id+"\t"+thresholdConn+"\t"+weightedConn);
		}

	    } else {

		// scan correlation with given gene
		TAIRGene gene1 = new TAIRGene(db1, TAIRVERSION, args[2]);
		Expression expr1 = new Expression(db1, gene1);
		expr1.values = Expression.log21p(expr1.values);

		double weightedConn = 0.0;
		int thresholdConn = 0;
		for (int j=0; j<expr2.length; j++) {
		    if (!expr1.equals(expr2[j])) {
			double corr = pCorr.correlation(getValues(samples,expr1,"WT",condition), getValues(samples,expr2[j],"WT",condition));
			weightedConn += Math.pow(Math.abs(corr),6.0); // use beta=6.0
			if (Math.abs(corr)>threshold) thresholdConn++;
		    }
		}
		// output the connectivity
		System.out.println(expr1.gene.id+"\t"+thresholdConn+"\t"+weightedConn);

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
