import edu.carnegiescience.dpb.bartonlab.*;
import java.util.ArrayList;
import org.apache.commons.math3.fitting.PolynomialCurveFitter;
import org.apache.commons.math3.fitting.WeightedObservedPoint;

/**
 * Run through all of the genes for an input condition, dumping out genes that have concave-down time profiles with fit exceeding stats thresholds,
 * characteristic of direct transcription targets.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2338 $ $Date: 2013-11-27 12:35:04 -0600 (Wed, 27 Nov 2013) $
 */
public class DirectTargetMiner {

  public static void main(String[] args) {

    if (args.length!=5) {
      System.err.println("Usage: DirectTargetMiner schema condition logFCmin curvatureThreshold RSquaredThreshold");
      return;
    }

    String schema = args[0];
    String condition = args[1];
    double logFCMin = Double.parseDouble(args[2]);
    double curvatureThreshold = Double.parseDouble(args[3]);
    double RSquaredThreshold = Double.parseDouble(args[4]);

    DB db = null;

    try {

      // open db connection
      db = new DB();
      db.setSearchPath(schema);

      // get samples for condition selection
      Sample[] samples = Sample.getAll(db);

      // distinct times
      int[] times = Sample.getTimes(db);

      // get expression for all genes
      Expression[] expr = Expression.getAll(db);

      // done with db
      db.close();
      
      // the fitter is instantiated once
      PolynomialCurveFitter fitter = PolynomialCurveFitter.create(2);

      // scan
      System.out.println("condition\tgene\tlogFC\tintercept\tcoeff1\tcoeff2\tRSquared");
      for (int i=0; i<expr.length; i++) {
	// samples isn't initialized in Expression.getAll(db)
	expr[i].samples = samples;
	// load the points list
	ArrayList<WeightedObservedPoint> points = new ArrayList<WeightedObservedPoint>();
	int nMin = 0;
	int nMax = 0;
	double tMinMean = 0;
	double tMaxMean = 0;
	for (int j=0; j<times.length; j++) {
	  double[] values = expr[i].getValues(condition,times[j]);
	  for (int k=0; k<values.length; k++) {
	    if (j==0) {
	      nMin++;
	      tMinMean += values[k];
	    } else if (j==times.length-1) {
	      nMax++;
	      tMaxMean += values[k];
	    }
	    points.add(new WeightedObservedPoint(1.0, times[j], values[k]));
	  }
	}
	// weed out low logFC genes
	tMinMean = tMinMean/nMin;
	tMaxMean = tMaxMean/nMax;
	double logFC = Util.log2(tMaxMean/tMinMean);
	if (Math.abs(logFC)>logFCMin) {
	  // do the fit
	  double[] coeffs = fitter.fit(points);
	  // get some fit stats
	  WeightedObservedPoint[] pointsArray = points.toArray(new WeightedObservedPoint[0]);
	  double numer = 0;
	  double denom = 0;
	  double mean = 0;
	  int n = pointsArray.length;
	  int p = 3;
	  for (int k=0; k<n; k++) mean += pointsArray[k].getY();
	  mean = mean/n;
	  for (int k=0; k<n; k++) {
	    double t = pointsArray[k].getX();
	    double y = pointsArray[k].getY();
	    double yfit = coeffs[0] + coeffs[1]*t + coeffs[2]*t*t;
	    numer += (y-yfit)*(y-yfit);
	    denom += (y-mean)*(y-mean);
	  }
	  double RSquared = 1 - numer/denom;
	  // conditional output
	  boolean enoughCurvature = (logFC>0 && coeffs[2]<-curvatureThreshold) || (logFC<0 && coeffs[2]>curvatureThreshold);
	  boolean enoughStats = RSquared>RSquaredThreshold;
	  if (enoughCurvature && enoughStats) {
	    System.out.println(condition+"\t"+expr[i].gene.id+"\t"+logFC+"\t"+coeffs[0]+"\t"+coeffs[1]+"\t"+coeffs[2]+"\t"+RSquared);
	  }
	}
      }

    } catch (Exception ex) {

      System.out.println(ex.toString());

    }

  }

    
}
