import edu.carnegiescience.dpb.bartonlab.*;
import org.apache.commons.math3.stat.StatUtils;
import java.util.ArrayList;

/**
 * Purges genes from expression and assocated DE records for the given experiment that:
 * 1. contain a zero expression value
 * 2. have excessive variance in the WT values for a particular time
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class PurgeExpression {

  public static void main(String[] args) {

    if (args.length!=3) {
      System.err.println("Usage: PurgeExpression schema detable cvThreshold");
      return;
    }

    String schema = args[0];
    String detable = args[1];
    double cvThreshold = Double.parseDouble(args[2]);

    DB db = null;

    try {

      // get the expression data
      db = new DB();
      db.setSearchPath(schema);
      Sample[] samples = Sample.getAll(db);
      int[] times = Sample.getTimes(db);
      Expression[] expr = Expression.getAll(db);

      // loop through each gene, check that min is nonzero, otherwise blow it away as well as the corresponding rows in the detable
      int count = 0;
      for (int i=0; i<expr.length; i++) {
	boolean hasZero = false;
	for (int j=0; j<expr[i].values.length; j++) {
	  if (expr[i].values[j]==0) hasZero = true;
	}
	if (hasZero) {
	  // we've got a zero value, blow it away
	  db.executeUpdate("DELETE FROM expression WHERE id='"+expr[i].gene.id+"'");
	  db.executeUpdate("DELETE FROM "+detable+" WHERE id='"+expr[i].gene.id+"'");
	  count++;
	  System.out.println(count+":\t"+expr[i].gene.id+"\tcontained zero values.");
	} else {
	  boolean hasHighCV = false;
	  for (int k=0; k<times.length; k++) {
	    double[] valuesWT = getValues(expr[i], samples, "WT", times[k]);
	    double mean = StatUtils.mean(valuesWT);
	    double variance = StatUtils.variance(valuesWT);
	    double cv = Math.sqrt(variance/Math.pow(mean,2));
	    if (cv>cvThreshold) hasHighCV = true;
	  }
	  if (hasHighCV) {
	    // blow away this high CV gene
	    db.executeUpdate("DELETE FROM expression WHERE id='"+expr[i].gene.id+"'");
	    db.executeUpdate("DELETE FROM "+detable+" WHERE id='"+expr[i].gene.id+"'");
	    count++;
	    System.out.println(count+":\t"+expr[i].gene.id+"\tcontained high CV WT values.");
	  }
	}
      }

    } catch (Exception ex) {

      System.out.println(ex.toString());

    } finally {

      try {
	db.close();
      } catch (Exception ex) {
	System.out.println(ex.toString());
      }

    }

  }

  /**
   * Return an array of values that correspond to the given sample condition
   */
  public static double[] getValues(Expression expr, Sample[] samples, String condition, int time) {
    ArrayList<Double> list = new ArrayList<Double>();
    for (int i=0; i<samples.length; i++) {
      if (samples[i].condition.equals(condition) && samples[i].time==time) list.add(expr.values[i]);
    }
    double[] vals = new double[list.size()];
    for (int i=0; i<vals.length; i++) vals[i] = (double) list.get(i);
    return vals;
  }


}



