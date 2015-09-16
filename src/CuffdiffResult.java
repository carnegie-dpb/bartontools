package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains a Cuffdiff analysis results record, and methods for getting arrays of results, conditions, etc.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2427 $ $Date: 2014-02-06 16:51:47 -0600 (Thu, 06 Feb 2014) $
 */
public class CuffdiffResult extends AnalysisResult {

  /** Flag for UP expression */
  public static final int UP = 1;

  /** Flag for DOWN expression */
  public static final int DN = -1;

  /** Flag for NO CHANGE of expression */
  public static final int NC = 9;

  /** Max logFC for defining NO CHANGE */
  public static final double maxLogFCNC = 0.5;

  public String test_id;
  public String shortname;     // gene
  public String locus;
  public String baseCondition; // sample_1
  public String deCondition;   // sample_2
  public double baseMean;      // value_1
  public double deMean;        // value_2
  public double logFC;         // logfc
  public double stat;          // test_stat
  public double p;             // p_value
  public double q;             // q_value

  /**
   * Construct given a base condition, DE condition and a gene
   */
  public CuffdiffResult(DB db, String baseCondition, String deCondition, Gene gene) throws SQLException {
    select(db, baseCondition, deCondition, gene);
  }
  /**
   * Construct given a base condition, DE condition and a gene
   */
  public CuffdiffResult(ServletContext context, Experiment experiment, String baseCondition, String deCondition, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      select(db, baseCondition, deCondition, gene);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Populate intance vars for a given Gene; only sets the instance gene if a result exists
   */
  void select(DB db, String baseCondition, String deCondition, Gene gene) throws SQLException {
    db.executeQuery("SELECT * FROM cuffdiffresults WHERE sample_1='"+baseCondition+"' AND sample_2='"+deCondition+"' AND id='"+gene.id+"'");
    if (db.rs.next()) {
      this.gene = gene;
      populate(db.rs);
    }
  }

  /**
   * Construct given a ResultSet
   */
  CuffdiffResult(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate instance variables from a loaded ResultSet
   */
  void populate(ResultSet rs) throws SQLException {
    test_id = rs.getString("test_id");
    shortname = rs.getString("gene");
    locus = rs.getString("locus");
    baseCondition = rs.getString("sample_1");
    deCondition = rs.getString("sample_2");
    baseMean = rs.getDouble("value_1");
    deMean = rs.getDouble("value_2");
    logFC = rs.getDouble("logfc");
    stat = rs.getDouble("test_stat");
    p = rs.getDouble("p_value");
    q = rs.getDouble("q_value");
  }

  /**
   * Return an array of all Cuffdiff rows for a given Base and DE condition
   */
  public static CuffdiffResult[] getAll(DB db, String baseCondition, String deCondition) throws SQLException {
    ArrayList<CuffdiffResult> list = new ArrayList<CuffdiffResult>();
    db.executeQuery("SELECT * FROM cuffdiffresults WHERE sample_1='"+baseCondition+"' AND sample_2='"+deCondition+"' ORDER BY id");
    while (db.rs.next()) list.add(new CuffdiffResult(db.rs));
    return list.toArray(new CuffdiffResult[0]);
  }

  /**
   * Return an array of genes selected against minimum counts and max adjusted p with given change directions.
   */
  public static Gene[] searchOnDirections(DB db, String baseCondition, String[] deConditions, double minBase, double minlogFC, double qMax, int[] directions) throws SQLException {
    // build the query for all the DESeq conditions with non-zero directions
    String query = "";
    boolean first = true;
    for (int i=0; i<deConditions.length; i++) {
      if (directions[i]!=0) {
	if (first) {
	  first = false;
	} else {
	  query += " INTERSECT ";
	}
	query += "SELECT id FROM cuffdiffresults WHERE sample_1='"+baseCondition+"' AND sample_2='"+deConditions[i]+"' AND value_1>"+minBase;
	if (directions[i]==UP) query += " AND q_value<"+qMax+" AND logFC>" +minlogFC;
	if (directions[i]==DN) query += " AND q_value<"+qMax+" AND logFC<-"+minlogFC;
	if (directions[i]==NC) query += " AND abs(logFC)<"+maxLogFCNC;
      }
    }
    query += " ORDER BY id";
    db.executeQuery(query);
    ArrayList<Gene> list = new ArrayList<Gene>();
    while (db.rs.next()) list.add(new Gene(db.rs.getString("id")));
    return list.toArray(new Gene[0]);
  }
  /**
   * Return an array of genes selected against minimum counts and max adjusted p with given change directions.
   */
  public static Gene[] searchOnDirections(ServletContext context, Experiment experiment, String baseCondition, String[] deConditions, double minBase, double minlogFC, double qMax, int[] directions)
    throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return searchOnDirections(db, baseCondition, deConditions, minBase, minlogFC, qMax, directions);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of genes selected against minimum counts and max adjusted p for at least one condition
   */
  public static Gene[] search(DB db, String baseCondition, String[] deConditions, double minBase, double minlogFC, double qMax) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    String query = "";
    boolean first = true;
    for (int i=0; i<deConditions.length; i++) {
      if (first) {
	first = false;
      } else {
	query += " UNION ";
      }
      query += "SELECT id FROM cuffdiffresults WHERE sample_1='"+baseCondition+"' AND sample_2='"+deConditions[i]+"' AND value_1>"+minBase+" AND q_value<"+qMax+" AND abs(logfc)>"+minlogFC;
    }
    query += " ORDER BY id";
    db.executeQuery(query);
    ArrayList<Gene> list = new ArrayList<Gene>();
    while (db.rs.next()) list.add(new Gene(db.rs.getString("id")));
    return list.toArray(new Gene[0]);
  }
  /**
   * Return an array of genes selected against minimum counts and max adjusted p for at least one condition
   */
  public static Gene[] search(ServletContext context, Experiment experiment, String baseCondition, String[] deConditions, double minBase, double minlogFC, double qMax) 
    throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return search(db, baseCondition, deConditions, minBase, minlogFC, qMax);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Get array of all DE conditions by querying the given index table
   */
  public static String[] getDEConditions(DB db) throws SQLException {
    ArrayList<String> list = new ArrayList<String>();
    db.executeQuery("SELECT DISTINCT sample_2 FROM cuffdiffresults ORDER BY sample_2");
    while (db.rs.next()) list.add(new String(db.rs.getString("sample_2")));
    return list.toArray(new String[0]);
  }
  /**
   * Get array of all DE conditions by querying the given index table
   */
  public static String[] getDEConditions(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return getDEConditions(db);
    } finally {
      if (db!=null) db.close();
    }
  }

}
