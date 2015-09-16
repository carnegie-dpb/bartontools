import java.util.ArrayList;
import edu.carnegiescience.dpb.bartonlab.*;
import org.apache.commons.math3.stat.StatUtils;

/**
 * Fit an RC-rise/decay like function to the mid-time expression values; uses t=0 as the starting point and t=120 as the effective final value, therefore fits the six 
 * t=30 and t=60 point in between.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class RCFit {

  public static void main(String[] args) {

    if (args.length<2) {
      System.out.println("Usage: RCFit expressionTable condition");
      return;
    }

    String expressionTable = args[0];
    String condition = args[1];

    DB db = null;

    try {

      db = new DB();

      Sample[] samples = Sample.getAll(db);
      Expression[] expr = Expression.getAll(db, expressionTable);

      // scan all expression rows
      for (int i=0; i<expr.length; i++) {

	double baseMean = StatUtils.mean(getValues(samples, expr[i], condition, 0));
	double baseSigma = Math.sqrt(StatUtils.variance(getValues(samples, expr[i], condition, 0)));
	double finalMean = StatUtils.mean(getValues(samples, expr[i], condition, 120));
	double finalSigma = Math.sqrt(StatUtils.variance(getValues(samples, expr[i], condition, 120)));
	
	double[] tau = new double[6];
	double[] s30 = getValues(samples, expr[i], condition, 30);
	double[] s60 = getValues(samples, expr[i], condition, 60);
	for (int j=0; j<3; j++) tau[j] = 30.0 / Math.log((finalMean-baseMean)/(finalMean-s30[j]));
	for (int j=0; j<3; j++) tau[j+3] = 60.0 / Math.log((finalMean-baseMean)/(finalMean-s60[j]));
	double tauMean = StatUtils.mean(tau);
	double tauSigma = Math.sqrt(StatUtils.variance(tau));

	if (!Double.isNaN(tauMean) && tauSigma<tauMean*0.5 && tauMean>0.0 && tauMean<120.0) {
	  System.out.println(expr[i].gene.id+"\t"+tauMean+"\t"+tauSigma);
	  db.executeUpdate("INSERT INTO rcfit VALUES ('"+expr[i].gene.id+"','"+condition+"',"+baseMean+","+baseSigma+","+finalMean+","+finalSigma+","+tauMean+","+tauSigma+")");
	}

      }

    } catch (Exception ex) {

      System.out.println(ex.toString());

    } finally {

      if (db!=null) {
	try {
	  db.close();
	} catch (Exception ex) {
	  System.out.println(ex.toString());
	}
      }

    }

  }

  /**
   * Return an array of values from the given expression that correspond to the given sample condition and time
   */
  public static double[] getValues(Sample[] samples, Expression expr, String condition, int time) {
    ArrayList<Double> list = new ArrayList<Double>();
    for (int i=0; i<samples.length; i++) {
      if (samples[i].condition.equals(condition) && samples[i].time==time) list.add(expr.values[i]);
    }
    double[] vals = new double[list.size()];
    for (int i=0; i<vals.length; i++) vals[i] = (double) list.get(i);
    return vals;
  }

}
