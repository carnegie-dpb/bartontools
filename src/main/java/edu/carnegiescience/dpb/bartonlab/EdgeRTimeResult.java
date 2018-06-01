package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains a EdgeR time-wise analysis results record, with values stored in double arrays. Get times from Samples; not stored here.
 *
 * @author Sam Hokin <hokin@stanford.edu>
 * @version $Revision: 2346 $ $Date: 2013-11-27 19:35:25 -0600 (Wed, 27 Nov 2013) $
 */
public class EdgeRTimeResult extends AnalysisResult {

  public String baseCondition = null;
  public String deCondition = null;

  /** results from topTags on glmLRT output */
  public double[] logFC;
  public double[] logCPM;
  public double[] lr;
  public double[] p;
  public double[] FDR;

  /**
   * Construct given a base condition, DE condition and gene
   */
  public EdgeRTimeResult(ServletContext context, Experiment experiment, String baseCondition, String deCondition, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context,experiment.schema);
      select(db, baseCondition, deCondition, gene);
    } finally {
      if (db!=null) db.close();
    }
  }
  /**
   * Construct given a base condition, DE condition and gene
   */
  public EdgeRTimeResult(DB db, String baseCondition, String deCondition, Gene gene) throws SQLException {
    select(db, baseCondition, deCondition, gene);
  }

  /**
   * Populate intance vars for a given Gene; only sets the instance gene if a result exists
   */
  void select(DB db, String baseCondition, String deCondition, Gene gene) throws SQLException {
    db.executeQuery("SELECT * FROM edgertimeresults WHERE basecondition='"+baseCondition+"' AND decondition='"+deCondition+"' AND id='"+gene.id+"'");
    if (db.rs.next()) {
      this.gene = gene;
      populate(db.rs);
    }
  }

  /**
   * Construct given a ResultSet
   */
  EdgeRTimeResult(ResultSet rs) throws SQLException {
    populate(rs);
  }

  /**
   * Populate instance from a loaded ResultSet
   */
  void populate(ResultSet rs) throws SQLException {
    if (gene==null) gene = new Gene(rs.getString("id"));
    baseCondition = rs.getString("basecondition");
    deCondition = rs.getString("decondition");
    logFC = Util.getDoubles(rs, "logfc");
    logCPM = Util.getDoubles(rs, "logcpm");
    lr = Util.getDoubles(rs, "lr");
    p = Util.getDoubles(rs, "pval");
    FDR = Util.getDoubles(rs, "fdr");
  }

  /**
   * Get array of all DE conditions
   */
  public static String[] getDEConditions(DB db) throws SQLException {
    ArrayList<String> list = new ArrayList<String>();
    db.executeQuery("SELECT DISTINCT decondition FROM edgertimeresults ORDER BY decondition");
    while (db.rs.next()) list.add(new String(db.rs.getString("decondition")));
    return list.toArray(new String[0]);
  }
  /**
   * Get array of all DE conditions
   */
  public static String[] getDEConditions(ServletContext context, Experiment experiment) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
    DB db = null;
    try {
      db = new DB(context,experiment.schema);
      return getDEConditions(db);
    } finally {
      if (db!=null) db.close();
    }
  }


}
