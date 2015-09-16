 package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains a limma analysis results record, and various methods for searching through the limma analysis results.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2799 $ $Date: 2015-08-07 15:41:11 -0500 (Fri, 07 Aug 2015) $
 */
public class LimmaResult extends AnalysisResult {

  public String probe_set_id = null;

  public String baseCondition = null;
  public String deCondition = null;

  public double logFC = 0.0;
  public double aveexpr = 0.0;
  public double t = 0.0;
  public double p = 0.0;
  public double q = 0.0;
  public double b = 0.0;

  /**
   * Construct given a results table and a gene
   */
  public LimmaResult(DB db, String baseCondition, String deCondition, Gene gene) throws SQLException {
    select(db, baseCondition, deCondition, gene);
  }
  /**
   * Construct given a results table and a gene
   */
  public LimmaResult(ServletContext context, Experiment experiment, String baseCondition, String deCondition, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
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
    db.executeQuery("SELECT * FROM limmaresults WHERE basecondition='"+baseCondition+"' AND decondition='"+deCondition+"' AND id='"+gene.id+"'");
    if (db.rs.next()) {
      this.gene = gene;
      populate(db.rs);
    }
  }

  /**
   * Construct given a ResultSet
   */
  LimmaResult(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate instance variables from a loaded ResultSet
   */
  void populate(ResultSet rs) throws SQLException {
    baseCondition = rs.getString("basecondition");
    deCondition = rs.getString("decondition");
    probe_set_id = rs.getString("probe_set_id");
    logFC = rs.getDouble("logfc");
    aveexpr = rs.getDouble("aveexpr");
    p = rs.getDouble("pvalue");
    q = rs.getDouble("adjpvalue");
    t = rs.getDouble("t");
    b = rs.getDouble("b");
  }

  /**
   * Return an array of genes selected against minimum counts and max adjusted p with given change directions.
   */
  public static Gene[] searchOnValuesAndDirections(ServletContext context, Experiment experiment, String baseCondition, String[] deConditions, double minAveExpr, double minlogFC, double maxAdjPValue, int[] directions)
    throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      // build the query for all the DE conditions with non-zero directions
      String query = "";
      boolean first = true;
      for (int i=0; i<deConditions.length; i++) {
	if (directions[i]!=0) {
	  if (first) {
	    first = false;
	  } else {
	    query += " INTERSECT ";
	  }
	  query += "SELECT id FROM limmaresults WHERE basecondition='"+baseCondition+"' AND decondition='"+deConditions[i]+"' AND aveexpr>"+minAveExpr+" AND adjpvalue<"+maxAdjPValue;
	  if (directions[i]==-1) query += " AND logfc<-"+minlogFC;
	  if (directions[i]==+1) query += " AND logfc>" +minlogFC;
	}
      }
      query += " ORDER BY id";
      db.executeQuery(query);
      ArrayList<Gene> list = new ArrayList<Gene>();
      while (db.rs.next()) list.add(new Gene(db.rs.getString("id")));
      return list.toArray(new Gene[0]);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Return an array of genes selected against minimum counts and max adjusted p for at least one condition
   */
  public static Gene[] searchOnValues(DB db, String baseCondition, String[] deConditions, double minAveExpr, double minlogFC, double maxAdjPValue) throws SQLException {
    String query = "";
    boolean first = true;
    for (int i=0; i<deConditions.length; i++) {
      if (first) {
	first = false;
      } else {
	query += " UNION ";
      }
      query += "SELECT id FROM limmaresults WHERE basecondition='"+baseCondition+"' AND decondition='"+deConditions[i]+"' AND aveexpr>"+minAveExpr+" AND adjpvalue<"+maxAdjPValue+" AND abs(logfc)>"+minlogFC;
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
  public static Gene[] searchOnValues(ServletContext context, Experiment experiment, String baseCondition, String[] deConditions, double minAveExpr, double minlogFC, double maxAdjPValue)
    throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context, experiment.schema);
      return searchOnValues(db, baseCondition, deConditions, minAveExpr, minlogFC, maxAdjPValue);
    } finally {
      if (db!=null) db.close();
    }
  }

  /**
   * Get array of all DE conditions by querying the given index table
   */
  public static String[] getDEConditions(DB db) throws SQLException {
    ArrayList<String> list = new ArrayList<String>();
    db.executeQuery("SELECT DISTINCT decondition FROM limmaresults ORDER BY decondition");
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
