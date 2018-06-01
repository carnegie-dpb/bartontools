package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

import org.apache.commons.math3.fitting.PolynomialCurveFitter;
import org.apache.commons.math3.fitting.WeightedObservedPoint;

/**
 * Searches for direct targets of a given gene by analyzing curvature of quadratic fit across time series; contains stats results associated with fit.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2357 $ $Date: 2013-12-10 09:58:32 -0600 (Tue, 10 Dec 2013) $
 */
public class DirectTargetResult extends AnalysisResult {

  /** the sample condition that was used for this result */
  public String condition;

  /** logFC computed from first and last points */
  public double logFC;

  /** the coefficients of the fit Expression = coeffs[0] + coeffs[1]*t + coeffs[2]*t^2 */
  public double[] coeffs;

  /** the R^2 of the fit */
  public double RSquared;

  /**
   * Construct a DirectTargetResult for the given condition
   */
  public DirectTargetResult(DB db, Gene gene, String condition) throws SQLException {
    this.gene = gene;
    this.condition = condition;
    fit(db);
  }
  /**
   * Construct a DirectTargetResult for the given condition
   */
  public DirectTargetResult(ServletContext context, Experiment experiment, Gene gene, String condition) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    this.gene = gene;
    this.condition = condition;
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      fit(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Fit quadratic to expression time series
   */
  void fit(DB db) throws SQLException {
    // this gene's expression
    Expression expr = new Expression(db, gene);
    // array of distinct times
    int[] times = Sample.getTimes(db);
    // the polynomial fitter
    PolynomialCurveFitter fitter = PolynomialCurveFitter.create(2);
    // load the points into a list, get logFC from first and last times
    ArrayList<WeightedObservedPoint> points = new ArrayList<WeightedObservedPoint>();
    int nMin = 0;
    int nMax = 0;
    double tMinMean = 0;
    double tMaxMean = 0;
    for (int j=0; j<times.length; j++) {
      double[] values = expr.getValues(condition,times[j]);
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
    tMinMean = tMinMean/nMin;
    tMaxMean = tMaxMean/nMax;
    logFC = Util.log2(tMaxMean/tMinMean);
    // do the fit
    coeffs = fitter.fit(points);
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
    RSquared = 1 - numer/denom;
    // coeffs units need to be normalized to expression(0), in per hour, per hour^2
    coeffs[0] = coeffs[0]/tMinMean;
    coeffs[1] = coeffs[1]/tMinMean*60;
    coeffs[2] = coeffs[2]/tMinMean*3600;
  }

  /**
   * Search for genes that meet the curvature and fit criteria
   */
  public static Gene[] search(DB db, String condition, double logFCmin, double curvatureThreshold, double RSquaredThreshold) throws SQLException {
    // get samples for condition selection
    Sample[] samples = Sample.getAll(db);
    // get distinct times
    int[] times = Sample.getTimes(db);
    // get expression for all genes
    Expression[] expr = Expression.getAll(db);
    // the fitter is instantiated once
    PolynomialCurveFitter fitter = PolynomialCurveFitter.create(2);
    // scan
    ArrayList<Gene> list = new ArrayList<Gene>();
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
      if (Math.abs(logFC)>logFCmin) {
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
	// coeffs units need to be normalized to expression(0), in per hour, per hour^2
	coeffs[0] = coeffs[0]/tMinMean;
	coeffs[1] = coeffs[1]/tMinMean*60;
	coeffs[2] = coeffs[2]/tMinMean*3600;
	// conditional output
	boolean enoughCurvature = (logFC>0 && coeffs[2]<-curvatureThreshold) || (logFC<0 && coeffs[2]>curvatureThreshold);
	boolean enoughStats = RSquared>RSquaredThreshold;
	if (enoughCurvature && enoughStats) list.add(expr[i].gene);
      }
    }
    return list.toArray(new Gene[0]);
  }
  /**
   * Search for genes that meet the curvature and fit criteria
   */
  public static Gene[] search(ServletContext context, Experiment experiment, String condition, double logFCmin, double curvatureThreshold, double RSquaredThreshold) 
    throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return search(db, condition, logFCmin, curvatureThreshold, RSquaredThreshold);
    } finally {
      if (db!=null) db.close();
    }
  }

}
