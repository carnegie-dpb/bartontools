 package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains a DESeq2 time-wise analysis results record, with values stored in double arrays. Get times from Samples; not stored here.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2346 $ $Date: 2013-11-27 19:35:25 -0600 (Wed, 27 Nov 2013) $
 */
public class DESeq2TimeResult extends AnalysisResult {

  /** Flag for UP expression */
  public static final int UP = 1;

  /** Flag for DOWN expression */
  public static final int DN = -1;

  /** Flag for NO CHANGE of expression */
  public static final int NC = 9;

  /** Max logFC for defining NO CHANGE */
  public static final double maxLogFCNC = 0.5;

  /** condition */
  public String condition = null;

  /** base time mean counts */
  public double[] baseMean;

  /** log2 fold change of differential expression */
  public double[] logFC;

  /** standard error on log2foldchange */
  public double[] logFCse;

  /** DESeq2 stat parameter - from DESeq2 v1.2.5 */
  public double stat[];

  /** raw p-value */
  public double p[];
  
  /** adjusted p-value */
  public double q[];

  /**
   * Construct given a condition and gene
   */
  public DESeq2TimeResult(ServletContext context, Experiment experiment, String condition, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context,experiment.schema);
      select(db, condition, gene);
    } finally {
      if (db!=null) db.close();
    }
  }
  /**
   * Construct given a condition and gene
   */
  public DESeq2TimeResult(DB db, String condition, Gene gene) throws SQLException {
    select(db, condition, gene);
  }

  /**
   * Populate intance vars for a given Gene; only sets the instance gene if a result exists
   */
  void select(DB db, String condition, Gene gene) throws SQLException {
    db.executeQuery("SELECT * FROM deseq2timeresults WHERE condition='"+condition+"' AND id='"+gene.id+"'");
    if (db.rs.next()) {
      this.gene = gene;
      populate(db.rs);
    }
  }

  /**
   * Construct given a ResultSet
   */
  DESeq2TimeResult(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate instance from a loaded ResultSet
   */
  void populate(ResultSet rs) throws SQLException {
    if (gene==null) gene = new Gene(rs.getString("id"));
    condition = rs.getString("condition");
    baseMean = Util.getDoubles(rs, "basemean");
    logFC = Util.getDoubles(rs, "logfc");
    logFCse = Util.getDoubles(rs, "logfcse");
    stat = Util.getDoubles(rs, "stat");
    p = Util.getDoubles(rs, "pval");
    q = Util.getDoubles(rs, "padj");
  }

  /**
   * Get array of all DE conditions
   */
  public static String[] getConditions(DB db) throws SQLException {
    ArrayList<String> list = new ArrayList<String>();
    db.executeQuery("SELECT DISTINCT condition FROM deseq2timeresults ORDER BY condition");
    while (db.rs.next()) list.add(new String(db.rs.getString("condition")));
    return list.toArray(new String[0]);
  }
  /**
   * Get array of all DE conditions
   */
  public static String[] getConditions(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context,experiment.schema);
      return getConditions(db);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of genes selected against minimum base[2], minimum logFC[2] and max adjusted p[2] with given change directions.
   */
  public static Gene[] searchOnDirections(DB db, String[] conditions, double minBase, double minlogFC, double maxPAdj, int[] directions) throws SQLException {
    // build the query for all the conditions with non-zero directions
    String query = "";
    boolean first = true;
    for (int i=0; i<conditions.length; i++) {
      if (directions[i]!=0) {
	if (first) {
	  first = false;
	} else {
	  query += " INTERSECT ";
	}
	query += "SELECT id FROM deseq2timeresults WHERE array_length(basemean,1)=3 AND condition='"+conditions[i]+"' " +
	  "AND basemean[1]>"+minBase+" AND basemean[2]>"+minBase+" AND basemean[3]>"+minBase;
	if (directions[i]==UP)
	  query += " AND ((padj[1]<"+maxPAdj+" AND logfc[1]>"+minlogFC+") OR (padj[2]<"+maxPAdj+" AND logfc[2]>"+minlogFC+") OR (padj[3]<"+maxPAdj+" AND logfc[3]>"+minlogFC+"))";
	if (directions[i]==DN)
	  query += " AND ((padj[1]<"+maxPAdj+" AND -logfc[1]>"+minlogFC+") OR (padj[2]<"+maxPAdj+" AND -logfc[2]>"+minlogFC+") OR (padj[3]<"+maxPAdj+" AND -logfc[3]>"+minlogFC+"))";
	if (directions[i]==NC) 
	  query += " AND abs(logfc[1])<"+maxLogFCNC+" AND abs(logfc[2])<"+maxLogFCNC+" AND abs(logfc[3])<"+maxLogFCNC;
      }
    }
    query += " ORDER BY id";
    db.executeQuery(query);
    ArrayList<Gene> list = new ArrayList<Gene>();
    while (db.rs.next()) list.add(new Gene(db.rs.getString("id")));
    return list.toArray(new Gene[0]);
  }
  /**
   * Return an array of genes selected against minimum base[2], minimum logFC[2] and max adjusted p[2] with given change directions.
   */
  public static Gene[] searchOnDirections(ServletContext context, Experiment experiment, String[] conditions, double minBase, double minlogFC, double maxPAdj, int[] directions)
    throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return searchOnDirections(db, conditions, minBase, minlogFC, maxPAdj, directions);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of genes selected against minimum base[2], minimum logFC[2] and max adjusted p[2] for at least one condition
   */
  public static Gene[] search(DB db, String[] conditions, double minBase, double minlogFC, double maxPAdj) throws SQLException {
    String query = "";
    boolean first = true;
    for (int i=0; i<conditions.length; i++) {
      if (first) {
	first = false;
      } else {
	query += " UNION ";
      }
      query += "SELECT id FROM deseq2timeresults WHERE array_length(basemean,1)=3 AND condition='"+conditions[i]+"' " +
	"AND basemean[1]>"+minBase+" AND basemean[2]>"+minBase+" AND basemean[3]>"+minBase+" " +
	"AND ((padj[1]<"+maxPAdj+" AND abs(logfc[1])>"+minlogFC+") OR (padj[2]<"+maxPAdj+" AND abs(logfc[2])>"+minlogFC+") OR (padj[3]<"+maxPAdj+" AND abs(logfc[3])>"+minlogFC+"))";
    }
    query += " ORDER BY id";
    db.executeQuery(query);
    ArrayList<Gene> list = new ArrayList<Gene>();
    while (db.rs.next()) list.add(new Gene(db.rs.getString("id")));
    return list.toArray(new Gene[0]);
  }
  /**
   * Return an array of genes selected against minimum base[2], minimum logFC[2] and max adjusted p[2] for at least one condition
   */
  public static Gene[] search(ServletContext context, Experiment experiment, String[] conditions, double minBase, double minlogFC, double maxPAdj) 
    throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return search(db, conditions, minBase, minlogFC, maxPAdj);
    } finally {
      if (db!=null) db.close();
    }
  }


}
