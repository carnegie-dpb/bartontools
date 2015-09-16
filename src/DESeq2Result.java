package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains a DESeq2 analysis results record, and methods for getting arrays of results, conditions, etc.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2799 $ $Date: 2015-08-07 15:41:11 -0500 (Fri, 07 Aug 2015) $
 */
public class DESeq2Result extends AnalysisResult {

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
  public String deCondition;
  public double baseMean;
  public double logFC;
  public double logFCse;
  public double stat;
  public double p;
  public double pAdj;

  /**
   * Construct given a base condition, DE condition and a gene
   */
  public DESeq2Result(DB db, String baseCondition, String deCondition, Gene gene) throws SQLException {
    select(db, baseCondition, deCondition, gene);
  }
  /**
   * Construct given a base condition, DE condition and a gene
   */
  public DESeq2Result(ServletContext context, Experiment experiment, String baseCondition, String deCondition, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
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
    db.executeQuery("SELECT * FROM deseq2results WHERE basecondition='"+baseCondition+"' AND decondition='"+deCondition+"' AND id='"+gene.id+"'");
    if (db.rs.next()) {
      this.gene = gene;
      populate(db.rs);
    }
  }

  /**
   * Construct given a ResultSet
   */
  DESeq2Result(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate instance variables from a loaded ResultSet
   */
  void populate(ResultSet rs) throws SQLException {
    baseCondition = rs.getString("basecondition");
    deCondition = rs.getString("decondition");
    baseMean = rs.getDouble("basemean");
    logFC = rs.getDouble("logfc");
    logFCse = rs.getDouble("logfcse");
    p = rs.getDouble("pval");
    stat = rs.getDouble("stat");
    pAdj = rs.getDouble("padj");
  }

  /**
   * Return an array of genes selected against minimum counts and max adjusted p with given change directions.
   */
  public static Gene[] searchOnDirections(DB db, String baseCondition, String[] deConditions, double minBase, double minlogFC, double maxPAdj, int[] directions) throws SQLException {
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
	query += "SELECT id FROM deseq2results WHERE basecondition='"+baseCondition+"' AND decondition='"+deConditions[i]+"' AND basemean>"+minBase;
	if (directions[i]==UP) query += " AND pAdj<"+maxPAdj+" AND logFC>" +minlogFC;
	if (directions[i]==DN) query += " AND pAdj<"+maxPAdj+" AND logFC<-"+minlogFC;
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
  public static Gene[] searchOnDirections(ServletContext context, Experiment experiment, String baseCondition, String[] deConditions, double minBase, double minlogFC, double maxPAdj, int[] directions)
    throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return searchOnDirections(db, baseCondition, deConditions, minBase, minlogFC, maxPAdj, directions);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of genes selected against minimum counts and max adjusted p for at least one condition
   */
  public static Gene[] search(DB db, String baseCondition, String[] deConditions, double minBase, double minlogFC, double maxPAdj) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    String query = "";
    boolean first = true;
    for (int i=0; i<deConditions.length; i++) {
      if (first) {
	first = false;
      } else {
	query += " UNION ";
      }
      query += "SELECT id FROM deseq2results WHERE basecondition='"+baseCondition+"' AND decondition='"+deConditions[i]+"' AND basemean>"+minBase+" AND padj<"+maxPAdj+" AND abs(logfc)>"+minlogFC;
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
  public static Gene[] search(ServletContext context, Experiment experiment, String baseCondition, String[] deConditions, double minBase, double minlogFC, double maxPAdj) 
    throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return search(db, baseCondition, deConditions, minBase, minlogFC, maxPAdj);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Get array of all DE conditions by querying the given index table
   */
  public static String[] getDEConditions(DB db) throws SQLException {
    ArrayList<String> list = new ArrayList<String>();
    db.executeQuery("SELECT DISTINCT decondition FROM deseq2results ORDER BY decondition");
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
