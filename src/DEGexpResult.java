package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains a DEGexp analysis results record, and methods for getting arrays of results, conditions, etc.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2396 $ $Date: 2014-01-19 11:29:06 -0600 (Sun, 19 Jan 2014) $
 */
public class DEGexpResult extends AnalysisResult {

  /** Flag for UP expression */
  public static final int UP = 1;

  /** Flag for DOWN expression */
  public static final int DN = -1;

  /** Flag for NO CHANGE of expression */
  public static final int NC = 9;

  /** Max logFC for defining NO CHANGE */
  public static final double maxLogFCNC = 0.5;

  /** base condition */
  public String baseCondition;

  /** DE condition */
  public String deCondition;

  /** base condition mean RPKM */
  public double baseMean;

  /** DE condition mean RPKM */
  public double deMean;

  /** log2 fold change of differential expression, use for RPKM data */
  public double logFC;

  /** log2 fold change of differential expression, use for count data */
  public double logFCNorm;

  /** raw p-value */
  public double pvalue;

  /** adjusted Q value, Benjamini */
  public double qBenjamini;

  /** adjusted Q value, Storey */
  public double qStorey;
  
  /** boolean indicating whether DE is regarded as significant (default is p<0.001) */
  public boolean significant;

  /**
   * Construct given a base condition, DE condition and a gene
   */
  public DEGexpResult(DB db, String baseCondition, String deCondition, Gene gene) throws SQLException {
    select(db, baseCondition, deCondition, gene);
  }
  /**
   * Construct given a base condition, DE condition and a gene
   */
  public DEGexpResult(ServletContext context, Experiment experiment, String baseCondition, String deCondition, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
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
    db.executeQuery("SELECT * FROM degexpresults WHERE basecondition='"+baseCondition+"' AND decondition='"+deCondition+"' AND id='"+gene.id+"'");
    if (db.rs.next()) {
      this.gene = gene;
      populate(db.rs);
    }
  }

  /**
   * Construct given a ResultSet
   */
  DEGexpResult(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate instance variables from a loaded ResultSet
   */
  void populate(ResultSet rs) throws SQLException {
    baseCondition = rs.getString("basecondition");
    deCondition = rs.getString("decondition");
    baseMean = rs.getDouble("basemean");
    deMean = rs.getDouble("demean");
    logFC = rs.getDouble("logfc");
    logFCNorm = rs.getDouble("logfcnorm");
    pvalue = rs.getDouble("pvalue");
    qBenjamini = rs.getDouble("q_benjamini");
    qStorey = rs.getDouble("q_storey");
    significant = rs.getBoolean("significant");
  }

  /**
   * Return an array of genes selected against max adjusted p for at least one condition
   */
  public static Gene[] search(DB db, String baseCondition, String[] deConditions, double minlogFC, double maxQBenjamini) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    String query = "";
    boolean first = true;
    for (int i=0; i<deConditions.length; i++) {
      if (first) {
	first = false;
      } else {
	query += " UNION ";
      }
      query += "SELECT id FROM degexpresults WHERE basecondition='"+baseCondition+"' AND decondition='"+deConditions[i]+"' AND q_benjamini<"+maxQBenjamini+" AND abs(logfc)>"+minlogFC;
    }
    query += " ORDER BY id";
    db.executeQuery(query);
    ArrayList<Gene> list = new ArrayList<Gene>();
    while (db.rs.next()) list.add(new Gene(db.rs.getString("id")));
    return list.toArray(new Gene[0]);
  }
  /**
   * Return an array of genes selected against minimum fold change and max adjusted p for at least one condition
   */
  public static Gene[] search(ServletContext context, Experiment experiment, String baseCondition, String[] deConditions, double minlogFC, double maxQBenjamini) 
    throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return search(db, baseCondition, deConditions, minlogFC, maxQBenjamini);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of genes selected against minimum fold change and max adjusted p with given change directions.
   */
  public static Gene[] searchOnDirections(DB db, String baseCondition, String[] deConditions, double minlogFC, double maxQBenjamini, int[] directions) throws SQLException {
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
	query += "SELECT id FROM degexpresults WHERE basecondition='"+baseCondition+"' AND decondition='"+deConditions[i]+"'";
	if (directions[i]==UP) query += " AND q_benjamini<"+maxQBenjamini+" AND logFC>" +minlogFC;
	if (directions[i]==DN) query += " AND q_benjamini<"+maxQBenjamini+" AND logFC<-"+minlogFC;
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
   * Return an array of genes selected against minimum fold change and max adjusted p with given change directions.
   */
  public static Gene[] searchOnDirections(ServletContext context, Experiment experiment, String baseCondition, String[] deConditions, double minlogFC, double maxQBenjamini, int[] directions)
    throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return searchOnDirections(db, baseCondition, deConditions, minlogFC, maxQBenjamini, directions);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Get array of all DE conditions by querying the given index table
   */
  public static String[] getDEConditions(DB db) throws SQLException {
    ArrayList<String> list = new ArrayList<String>();
    db.executeQuery("SELECT DISTINCT decondition FROM degexpresults ORDER BY decondition");
    while (db.rs.next()) list.add(new String(db.rs.getString("decondition")));
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
