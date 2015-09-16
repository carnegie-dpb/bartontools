import java.util.ArrayList;
import java.sql.SQLException;

import edu.carnegiescience.dpb.bartonlab.*;

import org.apache.commons.math3.stat.StatUtils;

/**
 * Calculate monotonicity parameter by group.
 *
 * @author Sam Hokin <sam@ims.net>
 */
public class Monotonicity {

  public static void main(String[] args) {

    if (args.length<1) {
      System.out.println("Usage: Monotonicity expressionTable");
      return;
    }

    String expressionTable = args[0];

    DB db = null;

    try {

      db = new DB();

      Sample[] samples = Sample.getAll(db);
      String[] conditions = Sample.getConditions(db);
      int[] times = Sample.getTimes(db);
      Expression[] expr = Expression.getAll(db, expressionTable);

      System.out.print("ID");
      for (int j=0; j<conditions.length; j++) System.out.print("\t"+conditions[j]);
      System.out.println("");

      // convert to log2 pseudocounts
      for (int i=0; i<expr.length; i++) expr[i].values = Expression.log21p(expr[i].values);

      // scan over genes
      for (int i=0; i<expr.length; i++) {
	System.out.print(expr[i].gene.id);
	// scan over conditions
	for (int j=0; j<conditions.length; j++) {
	  int M = 0; // monotonicity
	  // scan over times past first one
	  for (int k=1; k<times.length; k++) {
	    double a = (StatUtils.mean(getValues(samples,expr[i],conditions[j],times[k])) - StatUtils.mean(getValues(samples,expr[i],conditions[j],times[k-1])))/(times[k]-times[k-1]);
	    M += Util.sign(a);
	  }
	  System.out.print("\t"+M);
	}
	System.out.println("");
      }

    } catch (Exception ex) {

      System.err.println(ex.toString());

    } finally {

      try {
	db.close();
      } catch (Exception ex) {
	System.err.println(ex.toString());
      }

    }

  }

  /**
   * Return an array of values that correspond to the given sample condition and time
   */
  public static double[] getValues(Sample[] samples, Expression expr, String condition, int time) {
    ArrayList<Double> list = new ArrayList<Double>();
    for (int i=0; i<samples.length; i++) {
      if (samples[i].condition.equals(condition) && samples[i].time==time) list.add(expr.values[i]);
    }
    double[] values = new double[list.size()];
    for (int i=0; i<values.length; i++) values[i] = (double) list.get(i);
    return values;
  }
  
}
