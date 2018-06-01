 package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains a ExpFit analysis results record, and methods for getting arrays of results, conditions, etc.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2370 $ $Date: 2013-12-19 13:23:30 -0600 (Thu, 19 Dec 2013) $
 */
public class ExpFitResult extends AnalysisResult {

  /** gamma level considered to be "no change" */
  public static final double gammaNC = 0.01;

  /** Flag for UP expression */
  public static final int UP = 1;

  /** Flag for DOWN expression */
  public static final int DN = -1;

  /** Flag for NO CHANGE of expression */
  public static final int NC = 9;

  /** the sample condition associated with this result */
  public String condition;

  /** Estimate of t=0 signal */
  public double s0_est;
  public double s0_se;
  public double s0_t;
  public double s0_pr;

  /** Estimate of e-folding time */
  public double gamma_est;
  public double gamma_se;
  public double gamma_t;
  public double gamma_pr;

  /**
   * Construct given a condition and a gene
   */
  public ExpFitResult(DB db, String condition, Gene gene) throws SQLException {
    select(db, condition, gene);
  }
  /**
   * Construct given a condition and a gene
   */
  public ExpFitResult(ServletContext context, Experiment experiment, String condition, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      select(db, condition, gene);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Populate intance vars for a given Gene; only sets the instance gene if a result exists
   */
  void select(DB db, String condition, Gene gene) throws SQLException {
    db.executeQuery("SELECT * FROM expfitresults WHERE condition='"+condition+"' AND id='"+gene.id+"'");
    if (db.rs.next()) {
      this.gene = gene;
      populate(db.rs);
    }
  }

  /**
   * Construct given a ResultSet
   */
  ExpFitResult(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate instance variables from a loaded ResultSet
   */
  void populate(ResultSet rs) throws SQLException {
    condition = rs.getString("condition");
    s0_est = rs.getDouble("s0_est");
    s0_se = rs.getDouble("s0_se");
    s0_t = rs.getDouble("s0_t");
    s0_pr = rs.getDouble("s0_pr");
    gamma_est = rs.getDouble("gamma_est");
    gamma_se = rs.getDouble("gamma_se");
    gamma_t = rs.getDouble("gamma_t");
    gamma_pr = rs.getDouble("gamma_pr");
  }

  /**
   * Return an array of genes selected against a minimum gamma and maximum relative error for the given conditions and change directions
   */
  public static Gene[] searchOnDirections(DB db, double s0Min, double gammaMin, double gammaREMax, String[] conditions, int[] directions) throws SQLException {

    // build the query for all the DESeq conditions with non-zero directions
    String query = "";
    boolean first = true;
    for (int i=0; i<conditions.length; i++) {
      if (directions[i]!=0) {
	if (first) {
	  first = false;
	} else {
	  query += " INTERSECT ";
	}
	query += "SELECT id FROM expfitresults WHERE condition='"+conditions[i]+"' AND s0_est>"+s0Min+" AND gamma_se/abs(gamma_est)<"+gammaREMax;
	if (directions[i]==UP) query += " AND gamma_est>" +gammaMin;
	if (directions[i]==DN) query += " AND gamma_est<-"+gammaMin;
	if (directions[i]==NC) query += " AND abs(gamma_ext)<"+gammaNC;
      }
    }
    query += " ORDER BY id";
    db.executeQuery(query);
    ArrayList<Gene> list = new ArrayList<Gene>();
    while (db.rs.next()) list.add(new Gene(db.rs.getString("id")));
    return list.toArray(new Gene[0]);
  }
  /**
   * Return an array of genes selected against a minimum gamma and maximum relative error for the given conditions and change directions
   */
  public static Gene[] searchOnDirections(ServletContext context, Experiment experiment, double s0Min, double gammaMin, double gammaREMax, String[] conditions, int[] directions)
    throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return searchOnDirections(db, s0Min, gammaMin, gammaREMax, conditions, directions);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of genes selected against a minimum gamma and maximum relative error for at least one condition
   */
  public static Gene[] search(DB db, double s0Min, double gammaMin, double gammaREMax) throws SQLException {
    db.executeQuery("SELECT DISTINCT id FROM expfitresults WHERE s0_est>"+s0Min+" AND abs(gamma_est)>"+gammaMin+" AND gamma_se/abs(gamma_est)<"+gammaREMax+" ORDER BY id");
    ArrayList<Gene> list = new ArrayList<Gene>();
    while (db.rs.next()) list.add(new Gene(db.rs.getString("id")));
    return list.toArray(new Gene[0]);
  }
  /**
   * Return an array of genes selected against a minimum gamma and maximum relative error for at least one condition
   */
  public static Gene[] search(ServletContext context, Experiment experiment, double s0Min, double gammaMin, double gammaREMax) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return search(db, s0Min, gammaMin, gammaREMax);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Get array of all conditions
   */
  public static String[] getConditions(DB db) throws SQLException {
    ArrayList<String> list = new ArrayList<String>();
    db.executeQuery("SELECT DISTINCT condition FROM expfitresults ORDER BY condition");
    while (db.rs.next()) list.add(new String(db.rs.getString("condition")));
    return list.toArray(new String[0]);
  }
  /**
   * Get array of all conditions
   */
  public static String[] getConditions(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return getConditions(db);
    } finally {
      if (db!=null) db.close();
    }
  }

}
