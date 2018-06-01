package edu.carnegiescience.dpb.bartonlab;

import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ListIterator;
import java.util.TreeSet;

import javax.naming.NamingException;
import javax.servlet.ServletContext;

/**
 * Contains a Cuffdiff time-wise analysis results record, with values stored in double arrays. Get times from Samples; not stored here.
 *
 * @author Sam Hokin <shokin@carnegiescience.edu>
 * @version $Revision: 2346 $ $Date: 2013-11-27 19:35:25 -0600 (Wed, 27 Nov 2013) $
 */
public class CuffdiffTimeResult extends AnalysisResult {

    /** Flag for UP expression */
    public static final int UP = 1;

    /** Flag for DOWN expression */
    public static final int DN = -1;

    /** Flag for NO CHANGE of expression */
    public static final int NC = 9;

    public String test_id;
    public String shortname;       // gene
    public String locus;
    public String condition;       // condition
    public double[] baseMean;      // value_1
    public double[] deMean;        // value_2
    public double[] logFC;         // logfc
    public double[] stat;          // test_stat
    public double[] p;             // p_value
    public double[] q;             // q_value
    public String[] status;        // status code
    public boolean[] significant;  // yes or no in database

    /**
     * Construct given a condition and gene
     */
    public CuffdiffTimeResult(ServletContext context, Experiment experiment, String condition, Gene gene) throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context, experiment.schema);
            select(db, condition, gene);
        } finally {
            if (db!=null) db.close();
        }
    }
    /**
     * Construct given a condition and gene
     */
    public CuffdiffTimeResult(DB db, String condition, Gene gene) throws SQLException {
        select(db, condition, gene);
    }

    /**
     * Construct given a ResultSet
     */
    CuffdiffTimeResult(ResultSet rs) throws SQLException {
        populate(rs);
    }

    /**
     * Populate intance vars for a given Gene; only sets the instance gene if a result exists
     */
    void select(DB db, String condition, Gene gene) throws SQLException {
        db.executeQuery("SELECT * FROM cuffdifftimeresults WHERE condition='"+condition+"' AND id='"+gene.id+"'");
        if (db.rs.next()) {
            this.gene = gene;
            populate(db.rs);
        }
    }

    /**
     * Populate instance from a loaded ResultSet
     */
    void populate(ResultSet rs) throws SQLException {
        if (gene==null) gene = new Gene(rs.getString("id"));
        // scalars
        test_id = rs.getString("test_id");
        shortname = rs.getString("gene");
        locus = rs.getString("locus");
        condition = rs.getString("condition");
        try {
            // catch exception when we have non-doubles in PG array
            baseMean = Util.getDoubles(rs,"value_1");
            deMean = Util.getDoubles(rs,"value_2");
            logFC = Util.getDoubles(rs,"logfc");
            stat = Util.getDoubles(rs,"test_stat");
            p = Util.getDoubles(rs,"p_value");
            q = Util.getDoubles(rs,"q_value");
            status = Util.getStrings(rs,"status");
            String[] sigString = Util.getStrings(rs,"significant");
            significant = new boolean[sigString.length];
            for (int i=0; i<significant.length; i++) {
                significant[i] = sigString[i].equals("yes");
            }
        } catch (Exception e) {
            System.err.println("CuffdiffTimeResult error on gene "+gene.id+": "+e.toString());
        }
    }

    /**
     * Return true if this is an uninstantiated instance
     */
    public boolean isDefault() {
        return gene==null;
    }

    /**
     * Return an array of genes selected against minimum logFC and max q with given change directions.
     * Requires: public.array_avg(double precision[])
     */
    public static Gene[] searchOnDirections(DB db, String[] conditions, double minBase, double minlogFC, double maxQ, int[] directions) throws SQLException {
        // build the query for all the conditions with non-zero directions
        String query = "";
        boolean first = true;
        // build the query - NOTE PostgreSQL arrays are 1-based, so j starts with 1!
        for (int i=0; i<conditions.length; i++) {
            int[] times = Sample.getTimes(db, conditions[i]);
            int len = times.length - 1; // t=0 is base condition, len = non-zero conditions
            if (directions[i]!=0) {
                if (first) {
                    first = false;
                } else {
                    query += " INTERSECT ";
                }
                query += "SELECT id FROM cuffdifftimeresults WHERE public.array_avg(value_1)>0 AND public.array_avg(value_2)>0 AND condition='"+conditions[i]+"'";
                if (directions[i]==UP) {
                    query += " AND (";
                    for (int j=1; j<=len; j++) {
                        if (j>1) query += " OR ";
                        query += "(status["+j+"]='OK' AND q_value["+j+"]<"+maxQ+" AND value_1["+j+"]>="+minBase+" AND logfc["+j+"]>"+minlogFC+")";
                    }
                    query += ")";
                } else if (directions[i]==DN) {
                    query += " AND (";
                    for (int j=1; j<=len; j++) {
                        if (j>1) query += " OR ";
                        query += "(status["+j+"]='OK' AND q_value["+j+"]<"+maxQ+" AND value_1["+j+"]>="+minBase+" AND -logfc["+j+"]>"+minlogFC+")";
                    }
                    query += ")";
                } else if (directions[i]==NC) {
                    for (int j=1; j<=len; j++) {
                        query += " AND (status["+j+"]='OK' AND abs(logfc["+j+"])<1)";
                    }
                }
            }
        }
        db.executeQuery(query);
        TreeSet<Gene> candidates = new TreeSet<Gene>();
        while (db.rs.next()) candidates.add(new Gene(db.rs.getString("id")));
        // cull genes that don't have expression records
        TreeSet<Gene> set = new TreeSet<Gene>();
        for (Gene g : candidates) {
            if (g.hasExpression(db)) set.add(g);
        }
        return set.toArray(new Gene[0]);
    }
    /**
     * Return an array of genes selected against minimum logFC and max q with given change directions.
     */
    public static Gene[] searchOnDirections(ServletContext context, Experiment experiment, String[] conditions, double minBase, double minlogFC, double maxQ, int[] directions)
        throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context, experiment.schema);
            return searchOnDirections(db, conditions, minBase, minlogFC, maxQ, directions);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Return an array of genes selected against minimum logFC and max q with given change directions. Confidence term ("p" or "q") to minimize is supplied.
     * Requires: public.array_avg(double precision[])
     */
    public static Gene[] searchOnDirections(DB db, String[] conditions, double minBase, double minlogFC, double maxPQ, String confidenceTerm, int[] directions) throws SQLException {
        // build the query for all the conditions with non-zero directions
        String query = "";
        boolean first = true;
        String pq_value = confidenceTerm+"_value";
        // build the query - NOTE PostgreSQL arrays are 1-based, so j starts with 1!
        for (int i=0; i<conditions.length; i++) {
            int[] times = Sample.getTimes(db, conditions[i]);
            int len = times.length - 1; // t=0 is base condition, len = non-zero conditions
            if (directions[i]!=0) {
                if (first) {
                    first = false;
                } else {
                    query += " INTERSECT ";
                }
                query += "SELECT id FROM cuffdifftimeresults WHERE public.array_avg(value_1)>0 AND public.array_avg(value_2)>0 AND condition='"+conditions[i]+"'";
                if (directions[i]==UP) {
                    query += " AND (";
                    for (int j=1; j<=len; j++) {
                        if (j>1) query += " OR ";
                        query += "(status["+j+"]='OK' AND "+pq_value+"["+j+"]<"+maxPQ+" AND value_1["+j+"]>="+minBase+" AND logfc["+j+"]>"+minlogFC+")";
                    }
                    query += ")";
                } else if (directions[i]==DN) {
                    query += " AND (";
                    for (int j=1; j<=len; j++) {
                        if (j>1) query += " OR ";
                        query += "(status["+j+"]='OK' AND "+pq_value+"["+j+"]<"+maxPQ+" AND value_1["+j+"]>="+minBase+" AND -logfc["+j+"]>"+minlogFC+")";
                    }
                    query += ")";
                } else if (directions[i]==NC) {
                    for (int j=1; j<=len; j++) {
                        query += " AND (status["+j+"]='OK' AND abs(logfc["+j+"])<1)";
                    }
                }
            }
        }
        db.executeQuery(query);
        TreeSet<Gene> candidates = new TreeSet<Gene>();
        while (db.rs.next()) candidates.add(new Gene(db.rs.getString("id")));
        // cull genes that don't have expression records
        TreeSet<Gene> set = new TreeSet<Gene>();
        for (Gene g : candidates) {
            if (g.hasExpression(db)) set.add(g);
        }
        return set.toArray(new Gene[0]);
    }
    /**
     * Return an array of genes selected against minimum logFC and max q with given change directions. Confidence term is supplied.
     */
    public static Gene[] searchOnDirections(ServletContext context, Experiment experiment, String[] conditions, double minBase, double minlogFC, double maxPQ, String confidenceTerm, int[] directions)
        throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context, experiment.schema);
            return searchOnDirections(db, conditions, minBase, minlogFC, maxPQ, confidenceTerm, directions);
        } finally {
            if (db!=null) db.close();
        }
    }


    /**
     * Return an array of genes selected against minimum logFC and max q for at least one condition and time
     * Requires: public.array_avg(double precision[])
     */
    public static Gene[] search(DB db, String[] conditions, double minBase, double minlogFC, double maxPQ) throws SQLException {
        String query = "";
        boolean first = true;
        // determine the size of the full arrays, we don't include genes that are not fully populated
        for (int i=0; i<conditions.length; i++) {
            int[] times = Sample.getTimes(db, conditions[i]);
            int len = times.length - 1; // t=0 is base condition
            if (first) {
                first = false;
            } else {
                query += " UNION ";
            }
            query += "SELECT id FROM cuffdifftimeresults WHERE public.array_avg(value_1)>0 AND public.array_avg(value_2)>0 AND condition='"+conditions[i]+"'";
            query += " AND (";
            for (int j=1; j<=len; j++) {
                if (j>1) query += " OR ";
                query += "(status["+j+"]='OK' AND q_value["+j+"]<"+maxPQ+" AND value_1["+j+"]>="+minBase+" AND abs(logfc["+j+"])>"+minlogFC+")";
            }
            query += ")";
        }
        db.executeQuery(query);
        TreeSet<Gene> candidates = new TreeSet<Gene>();
        // cull genes that don't have expression records
        TreeSet<Gene> set = new TreeSet<Gene>();
        for (Gene g : candidates) {
            if (g.hasExpression(db)) set.add(g);
        }
        return set.toArray(new Gene[0]);
    }
    /**
     * Return an array of genes selected against minimum logFC[2] and max adjusted p[2] for at least one condition
     */
    public static Gene[] search(ServletContext context, Experiment experiment, String[] conditions, double minBase, double minlogFC, double maxPQ) 
        throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context, experiment.schema);
            return search(db, conditions, minBase, minlogFC, maxPQ);
        } finally {
            if (db!=null) db.close();
        }
    }

    /**
     * Return an array of genes selected against minimum logFC and max q for at least one condition. Confidence term "p" or "q" is given.
     * Requires: public.array_avg(double precision[])
     */
    public static Gene[] search(DB db, String[] conditions, double minBase, double minlogFC, double maxPQ, String confidenceTerm) throws SQLException {
        String query = "";
        boolean first = true;
        String pq_value = confidenceTerm+"_value";
        // determine the size of the full arrays, we don't include genes that are not fully populated
        for (int i=0; i<conditions.length; i++) {
            int[] times = Sample.getTimes(db, conditions[i]);
            int len = times.length - 1; // t=0 is base condition
            if (first) {
                first = false;
            } else {
                query += " UNION ";
            }
            query += "SELECT id FROM cuffdifftimeresults WHERE public.array_avg(value_1)>0 AND public.array_avg(value_2)>0 AND condition='"+conditions[i]+"'";
            query += " AND (";
            for (int j=1; j<=len; j++) {
                if (j>1) query += " OR ";
                query += "(status["+j+"]='OK' AND "+pq_value+"["+j+"]<"+maxPQ+" AND value_1["+j+"]>="+minBase+" AND abs(logfc["+j+"])>"+minlogFC+")";
            }
            query += ")";
        }
        db.executeQuery(query);
        TreeSet<Gene> candidates = new TreeSet<Gene>();
        while (db.rs.next()) candidates.add(new Gene(db.rs.getString("id")));
        // cull genes that don't have expression records
        TreeSet<Gene> set = new TreeSet<Gene>();
        for (Gene g : candidates) {
            if (g.hasExpression(db)) set.add(g);
        }
        return set.toArray(new Gene[0]);
    }
    /**
     * Return an array of genes selected against minimum logFC[2] and max adjusted p[2] for at least one condition
     */
    public static Gene[] search(ServletContext context, Experiment experiment, String[] conditions, double minBase, double minlogFC, double maxPQ, String confidenceTerm) 
        throws SQLException, FileNotFoundException, NamingException, ClassNotFoundException {
        DB db = null;
        try {
            db = new DB(context, experiment.schema);
            return search(db, conditions, minBase, minlogFC, maxPQ, confidenceTerm);
        } finally {
            if (db!=null) db.close();
        }
    }

}
